require 'cloudfiles'
require 'active_support/time'

module PruneCloudfilesDbBackups
  class Pruner
    def initialize(opts)
      @cf = CloudFiles::Connection.new(username: opts[:user], api_key: opts[:key])
      container = @cf.container(opts[:container])
      objects = container.list_objects


      # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
      keep_list = []

      day_retention = 14
      week_retention = 8
      month_retention = 12

      day_retention.times { |i|
        keep_list.push Time.now.utc.at_midnight.advance(:days => -i)
      }

      week_retention.times { |i|
        keep_list.push Time.now.utc.at_beginning_of_week.advance(:weeks => -i)
      }

      month_retention.times { |i|
        keep_list.push Time.now.utc.at_beginning_of_month.advance(:months => -i).advance(:days => 6).beginning_of_week
      }

      keep_fdate = keep_list.map do |time|
        time.strftime("%Y%m%d")
      end

      keep_objects = objects.select do |o|
        date = /(\d{8})/.match(o)[0]
        keep_fdate.include?(date)
      end

      delete_objects = objects - keep_objects

      keep_objects.map do |o|
        puts "Keeping: #{o}"
      end

      if opts[:yes]
        delete_objects.map do |o|
          puts "Deleting: #{o}"
          # Not until I'm comfortable
          #container.delete_object(o)
        end
      else
        delete_objects.map do |o|
          puts "To be deleted: #{o}"
        end
      end
    end
  end
end