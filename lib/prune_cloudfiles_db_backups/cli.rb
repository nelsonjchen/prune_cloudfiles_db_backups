require 'slop'
require 'prune_cloudfiles_db_backups/pruner'

module PruneCloudfilesDbBackups
  class CLI
    def self.start
      opts = Slop.parse(strict: true, help: true) do
        banner 'Usage: prune_cloudfiles_db_backups [options]'
        on :u, :user=,      'Rackspace user to use. Default: ENV["N_RACKSPACE_API_USERNAME"]', default: ENV['N_RACKSPACE_API_USERNAME']
        on :k, :key=,       'Rackspace key to use. Default: ENV["N_RACKSPACE_API_KEY"]', as: String, default: ENV['N_RACKSPACE_API_KEY']
        on :c, :container=, 'Rackspace key to use. Default: database_backups', default: 'database_backups'
        on :y, :yes,        'WARNING: Actually delete files from Rackspace Cloud. Without this option, only a listing of files to be deleted are given'
        on :d, :daily,     'Set daily retention time. Default: 14', default:14
        on :w, :weekly,     'Set monthly retention time. Default: 8', default:12
        on :m, :monthly,     'Set monthly retention time. Default: 8', default:8
      end

      pruner = PruneCloudfilesDbBackups::Pruner.new(opts)

      puts pruner.date_sorted_delete_list.map {|backup| "Delete: #{backup.to_s}"}
      puts pruner.date_sorted_keep_list.map {|backup| "Keep: #{backup.to_s}"}

    end
  end
end
