require 'spec_helper'
require 'prune_cloudfiles_db_backups/retention_calculator'

module PruneCloudfilesDbBackups

  describe RetentionCalculator do
    context 'March 24, 2013' do
      before(:each) do
        @time_now = DateTime.parse(self.class.description)
        DateTime.stub!(:now).and_return(@time_now)
      end

      let (:objects) {
        IO.readlines("#{File.dirname(__FILE__)}/lists/backup_pile.txt")
      }

      it 'is able to be created on this date with a stubbed Time#now' do

      end

      it 'accepts keyword initialization arguments'

      it 'accepts an Array of Strings'

      describe '#to_delete' do

      end

      describe '#to_keep' do

      end
    end

  end
end
