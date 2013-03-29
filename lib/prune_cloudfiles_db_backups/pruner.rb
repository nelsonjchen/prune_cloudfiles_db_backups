require 'openstack'
require 'logger'
require 'prune_cloudfiles_db_backups/retention_calculator'

module PruneCloudfilesDbBackups
  class Pruner
    def initialize(opts = {})
      logger = Logger.new(STDOUT)

      cf = OpenStack::Connection.create(username: opts[:user],
                                      api_key: opts[:key],
                                      auth_url: 'https://identity.api.rackspacecloud.com/v1.0',
                                      service_type:'object-store')
      @container = cf.container(opts[:container])

      calc = RetentionCalculator.new(@container.objects)
      @list_to_delete = calc.list_to_delete
      @list_to_keep = calc.list_to_delete
    end

    def delete!
      @list_to_delete.map do |object|
         @container.delete_object(object)
      end
    end

    def date_sorted_keep_list
      @list_to_keep.sort_by {|a, b| a.date < b.date}
    end

    def date_sorted_delete_list
      @list_to_delete.sort_by {|a, b| a.date < b.date}
    end

  end
end
