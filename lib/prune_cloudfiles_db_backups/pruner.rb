require 'openstack'
require 'prune_cloudfiles_db_backups/retention_calculator'

module PruneCloudfilesDbBackups
  class Pruner
    def initialize(opts)
      cf = OpenStack::Connection.new(username: opts[:user],
                                      api_key: opts[:key],
                                      auth_url: 'https://identity.api.rackspacecloud.com/v1.0',
                                      service_type:'object-store')
      container = cf.container(opts[:container])

      # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
      calc = RetentionCalculator.new(container.list_objects)
    end

  end
end
