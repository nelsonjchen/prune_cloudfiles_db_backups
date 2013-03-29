require 'openstack'
require 'logger'
require 'prune_cloudfiles_db_backups/retention_calculator'

module PruneCloudfilesDbBackups
  class Pruner
    def initialize(opts)
      cf = OpenStack::Connection.create(username: opts[:user],
                                      api_key: opts[:key],
                                      auth_url: 'https://identity.api.rackspacecloud.com/v1.0',
                                      service_type:'object-store')
      container = cf.container(opts[:container])
      logger = Logger.new(STDOUT)

      calc = RetentionCalculator.new(container.objects)
      calc.list_to_delete.map do |object|
        container.delete_object(object)
        logger.info('Deleting ' + object.to_s)
      end

      calc.list_to_keep.map do |object|
        logger.info('Keeping ' + object.to_s)
      end
    end


  end
end
