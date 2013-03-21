require 'cloudfiles'
require 'prune_cloudfiles_db_backups/retention_calculator'

module PruneCloudfilesDbBackups
  class Pruner
    def initialize(opts)
      cf = CloudFiles::Connection.new(username: opts[:user], api_key: opts[:key])
      container = cf.container(opts[:container])

      # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
      results = RetentionCalculator.new(container.list_objects).results

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
