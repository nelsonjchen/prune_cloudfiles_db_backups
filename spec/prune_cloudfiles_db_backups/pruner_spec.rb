require 'spec_helper'
require 'prune_cloudfiles_db_backups/pruner'

require 'openstack'

module PruneCloudfilesDbBackups

  describe Pruner do
    before(:each) do
      @time_now = DateTime.parse('March 24, 2013')
      DateTime.stub!(:now).and_return(@time_now)

      @object_pile = IO.read("#{File.dirname(__FILE__)}/lists/backup_pile.txt").split("\n")
      container = double('an openstack container')
      container.stub(:objects) {
        @object_pile
      }
      container.stub(:delete_object) { |arg|
        @object_pile.delete(arg)
      }
      OpenStack::Connection.stub_chain(:create, :container).and_return(container)

    end

    it 'can be tested with the cloudfile mocked to object_pile' do
      cf = OpenStack::Connection.create(username: 'a_real_username',
                                        api_key: 'a_real_key',
                                        auth_url: 'https://identity.api.rackspacecloud.com/v1.0',
                                        service_type:'object-store')
      container = cf.container('database_backups')
      container.objects.size.should be > 1000
      size = container.objects.size
      marked_for_death_object = container.objects[0]
      container.delete_object(marked_for_death_object)
      container.objects.size.should be == (size - 1)
    end

    context 'running' do
      before(:each) do
        @pruner = Pruner.new({})
      end

      it 'returns TBD and Keep values' do
        @pruner.list_to_delete.should_not be_nil
        @pruner.list_to_keep.should_not be_nil
      end

      it 'returns a sorted list of stuff to keep with the older stuff at top' do
        @pruner.date_sorted_keep_list.first.datetime.year.should be == 2012
      end

      it 'will actually delete things if #delete! is called' do
        size = container.objects.size
        @pruner.delete!
        container.objects.size.should be < size
      end

    end
  end
end
