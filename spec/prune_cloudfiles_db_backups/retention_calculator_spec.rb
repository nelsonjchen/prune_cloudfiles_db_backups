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
        DateTime.now.should eq(DateTime.parse(self.class.description))
        RetentionCalculator.new(objects:@objects)
      end

      it 'accepts keyword initialization arguments' do
        RetentionCalculator.new(objects:@objects)
      end

      context 'calculations' do
        let(:calc) {RetentionCalculator.new(objects:@objects)}

        describe '#to_delete' do
          it 'contains account_production-20120307000001.pgdump' do
            @calc.to_delete.include?('account_production-20120307000001.pgdump').should be_true
          end
        end

        describe '#to_keep' do
          @calc.to_keep.include?('trans_production-20130322000006.pgdump
').should be_true
        end
      end
    end

  end
end
