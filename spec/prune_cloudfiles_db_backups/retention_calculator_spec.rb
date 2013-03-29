# encoding: utf-8

require 'spec_helper'
require 'prune_cloudfiles_db_backups/retention_calculator'
require 'prune_cloudfiles_db_backups/backup'

module PruneCloudfilesDbBackups

  describe RetentionCalculator do
    context 'March 24, 2013' do
      before(:each) do
        @time_now = DateTime.parse('March 24, 2013')
        DateTime.stub!(:now).and_return(@time_now)
      end

      let (:objects) {
        IO.read("#{File.dirname(__FILE__)}/lists/backup_pile.txt").split("\n")
      }

      it 'is able to be created on this date with a stubbed Time#now' do
        DateTime.now.should eq(DateTime.parse('March 24, 2013'))
        RetentionCalculator.new(objects)
      end

      it 'accepts keyword initialization arguments' do
        RetentionCalculator.new(objects)
      end

      context 'calculations' do
        before(:each) do
          @calc = RetentionCalculator.new(objects)
        end

        describe '#list_to_keep' do
          it 'contains trans_production-20130322000006.pgdump' do
            backup = Backup.new(
                objects:
                Set.new(
                    %w(
                    trans_production-20130322000006.pgdump
                    trans_production-20130322000006.pgdump.000
                    trans_production-20130322000006.pgdump.001
                    trans_production-20130322000006.pgdump.003
                    trans_production-20130322000006.pgdump.004
                  )
                )
            )
            @calc.list_to_keep.include?(backup).should be_true
          end
        end

        describe '#list_to_delete' do
          it 'contains reports_production-20120524000003.pgdump' do
            backup = Backup.new(
                objects:
                Set.new(
                    %w(
                    reports_production-20120524000003.pgdump
                    reports_production-20120524000003.pgdump.000
                  )
                )
            )
            @calc.list_to_delete.include?(backup).should be_true
          end
        end
      end
    end

  end
end
