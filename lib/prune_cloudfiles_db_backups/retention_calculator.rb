require 'active_support/time'
require 'prune_cloudfiles_db_backups/retention_calculator_results'

module PruneCloudfilesDbBackups
  class RetentionCalculator
    attr_reader :results

    DAY_RETENTION   = 14
    WEEK_RETENTION  =  8
    MONTH_RETENTION = 12

    def initialize(objects)
      keep_objects = objects.select do |object|
        date = /(\d{8})/.match(object)[0]
        keep_dates.map { |d| d.strftime("%Y%m%d") }.include?(date)
      end

      delete_objects = objects - keep_objects
      @results = RetentionCalculatorResults.new(delete_objects, keep_objects)
    end

    private

    def keep_dates
      # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
      keep_list = []

      DAY_RETENTION.times { |i|
        keep_list.push Time.now.utc.at_midnight.advance(:days => -i)
      }

      WEEK_RETENTION.times { |i|
        # Sunday on the last couple of weeks
        keep_list.push Time.now.utc.at_beginning_of_week(:sunday).advance(:weeks => -i)
      }

      MONTH_RETENTION.times { |i|
        # First Sunday of every month
        keep_list.push Time.now.utc.at_beginning_of_month.advance(:months => -i).advance(:days => 6).beginning_of_week(:sunday)
      }

      keep_list
    end
  end
end
