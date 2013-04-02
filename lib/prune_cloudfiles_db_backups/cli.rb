require 'slop'
require 'prune_cloudfiles_db_backups/pruner'
require 'ruby-progressbar'


module PruneCloudfilesDbBackups
  class CLI
    def self.start
      opts = Slop.parse(strict: true, help: true) do
        banner 'Usage: prune_cloudfiles_db_backups [options]'
        on :u, :user=,      'Rackspace user to use. Default: ENV["N_RACKSPACE_API_USERNAME"]', default: ENV['N_RACKSPACE_API_USERNAME']
        on :k, :key=,       'Rackspace key to use. Default: ENV["N_RACKSPACE_API_KEY"]', as: String, default: ENV['N_RACKSPACE_API_KEY']
        on :authurl=, 'Auth URL Default: https://identity.api.rackspacecloud.com/v1.0', default: 'https://identity.api.rackspacecloud.com/v1.0'
        on :c, :container=, 'Rackspace containe to prune. Default: dummy_container', default: 'dummy_container'
        on :allow_deletion,        'WARNING: Actually delete files from Rackspace Cloud. Without this option, only a listing of files to be deleted are given'
        on :d, :daily,     'Set daily retention time. Default: 14', default:14, as: Integer
        on :w, :weekly,     'Set weekly retention time. Default: 12', default:12, as: Integer
        on :m, :monthly,     'Set monthly retention time. Default: 8', default:8, as: Integer
      end

      pruner = PruneCloudfilesDbBackups::Pruner.new(opts)

      puts pruner.date_sorted_delete_list.map {|backup| "Delete: #{backup.to_s}"}
      puts pruner.date_sorted_keep_list.map {|backup| "Keep: #{backup.to_s}"}

      if opts[:allow_deletion]
        puts "Commencing deletion in #{opts[:container]}!"
        progress = ProgressBar.create(title: 'Objects for deletion deleted',
                                      total: pruner.list_to_delete.size,
                                      format: '%e %a |%b>%i| %p%% %t'
        )
        pruner.delete! do |object|
          progress.increment
        end
        progress.finish
        puts 'Deletion completed.'
      else
        puts "Dry run on #{opts[:container]}. No files deleted. Run with --allow_deletion to commence deletion."
      end

    end
  end
end
