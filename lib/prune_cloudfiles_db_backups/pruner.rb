require 'cloudfiles'
require 'active_support/time'

module PruneCloudfilesDbBackups
  class RetentionCalculator
    attr_reader :result

    def initialize(objects)
      @keep_objects = objects.select do |o|
        date = /(\d{8})/.match(o)[0]
        keep_dates.map { |d| d.strftime("%Y%m%d") }.include?(date)
      end

      @delete_objects = objects - @keep_objects
      @result = RetentionCalculatorResult.new(@delete_objects, @keep_objects)
    end

    def keep_dates
      # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
      keep_list = []

      day_retention = 14
      week_retention = 8
      month_retention = 12

      day_retention.times { |i|
        keep_list.push Time.now.utc.at_midnight.advance(:days => -i)
      }

      week_retention.times { |i|
        # Sunday on the last couple of weeks
        keep_list.push Time.now.utc.at_beginning_of_week(:sunday).advance(:weeks => -i)
      }

      month_retention.times { |i|
        # First Sunday of every month
        keep_list.push Time.now.utc.at_beginning_of_month.advance(:months => -i).advance(:days => 6).beginning_of_week(:sunday)
      }

      keep_list
    end
  end

  class RetentionCalculatorResult
    attr_reader :delete_objects, :keep_objects

    def initialize(delete_objects, keep_objects)
      @delete_objects = delete_objects
      @keep_objects = keep_objects
    end
  end

  class Pruner
    def initialize(opts)
      @cf = CloudFiles::Connection.new(username: opts[:user], api_key: opts[:key])
      container = @cf.container(opts[:container])
      objects = container.list_objects

      # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
      results = RetentionCalculator.new(objects).result


      results.keep_objects.map do |o|
        puts "Keeping: #{o}"
      end

      if opts[:yes]
        results.delete_objects.map do |o|
          puts "Deleting: #{o}"
          # Not until I'm comfortable
          #container.delete_object(o)
        end
      else
        results.delete_objects.map do |o|
          puts "To be deleted: #{o}"
        end
      end

      puts "Count: TBD - #{results.delete_objects.size} Keep - #{results.keep_objects.size}"
    end
  end

end