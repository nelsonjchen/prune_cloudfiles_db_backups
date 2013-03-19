require 'slop'
require 'prune_cf_db_backups/pruner'

module PruneCfDbBackups
  class CLI
    def self.start
      opts = Slop.parse(strict: true, help: true) do
        banner "Usage: prune_cf_db_backups [options]"
        on 'u', 'user', "Rackspace user to use. Default: ENV[\"N_RACKSPACE_API_USERNAME\"] || \"aguilar\"", :default => ENV["N_RACKSPACE_API_USERNAME"] || "aguilar"
        on 'k', 'key', "Rackspace key to use. Default: ENV[\"N_RACKSPACE_API_KEY\"]", :default => ENV["N_RACKSPACE_API_KEY"]
        on 'c', 'container', "Rackspace key to use. Default: database_backups", :default => "database_backups"
        on 'y', 'yes', 'WARNING: Actually delete files from Rackspace Cloud. Without this option, only a listing of files to be deleted are given'
      end

      PruneCfDbBackups::Pruner.new(opts[:user], opts[:key], opts[:container], opts[:yes])
    end
  end
end