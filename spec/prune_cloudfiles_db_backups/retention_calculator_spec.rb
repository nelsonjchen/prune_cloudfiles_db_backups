require 'spec_helper'
require 'prune_cloudfiles_db_backups/retention_calculator'

module PruneCloudfilesDbBackups

  describe RetentionCalculator do
    context 'March 24, 2013' do
      before(:each) do
        @time_now = Time.parse(self.class.description)
        Time.stub!(:now).and_return(@time_now)
      end

      it 'is able to be created on this date with a stubbed Time#now'

      it 'accepts keyword initialization arguments'

      it 'accepts an Array of Strings'

      describe '#to_delete' do

      end

      describe '#to_keep' do

      end
    end

  end
end
