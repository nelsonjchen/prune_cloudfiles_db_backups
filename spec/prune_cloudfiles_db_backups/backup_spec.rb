require "rspec"
require 'prune_cloudfiles_db_backups/backup'

module PruneCloudfilesDbBackups
  describe Backup do
    describe '#initialize' do
      before(:each) do
        @names = %w{
          reports_production-20120819000003.pgdump
          reports_production-20120819000003.pgdump.000
          reports_production-20120819000003.pgdump.001
        }
      end
      it 'can create a backup with a set of object names' do
        Backup.new(names:@names)
      end

      it 'can create a new backup with no flags set' do
        b = Backup.new(names:@names)
        b.daily || b.weekly || b.monthly == false
      end
    end

    describe '#deletable?' do
      it 'returns false if either the name, date, or set of object are not  set' do

      end
      it 'returns true if none of the daily, weekly, or monthly flags are set'
      it 'returns false if no flags are set'
    end

    describe '#date' do
      it 'allows reading of the date'
    end

    %w{daily weekly monthly}.map do |interval|
      describe "##{interval}" do
        it "allows setting of the #{interval} flag"
      end
    end

  end
end
