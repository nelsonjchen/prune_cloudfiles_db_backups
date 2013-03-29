require 'openstack'
require 'logger'
require 'prune_cloudfiles_db_backups/retention_calculator'

module PruneCloudfilesDbBackups
  class Pruner
    attr_reader :list_to_keep, :list_to_delete

    def initialize(opts = {})
      cf = OpenStack::Connection.create(username: opts[:user],
                                      api_key: opts[:key],
                                      auth_url: 'https://identity.api.rackspacecloud.com/v1.0',
                                      service_type:'object-store')
      @container = cf.container(opts[:container])

      calc = RetentionCalculator.new(@container.objects)
      @list_to_delete = calc.list_to_delete
      @list_to_keep = calc.list_to_keep
    end

    def delete!
      @list_to_delete.map do |set|
        # TODO: Recursively delete the set
        @container.delete_object(set)
      end
    end

    def date_sorted_keep_list
      @list_to_keep.sort_by {|a| a.datetime}
    end

    def date_sorted_delete_list
      @list_to_delete.sort_by {|a| a.datetime}
    end

  end
end
