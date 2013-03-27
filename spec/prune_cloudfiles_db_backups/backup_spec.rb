require 'rspec'
require 'prune_cloudfiles_db_backups/backup'

module PruneCloudfilesDbBackups
  describe Backup do
    before(:each) do
      @names = %w{
          reports_production-20120819000003.pgdump
          reports_production-20120819000003.pgdump.000
          reports_production-20120819000003.pgdump.001
        }
    end

    describe '#initialize' do
      it 'can create a backup with a set of object names' do
        Backup.new(names:@names)
      end

      it 'can create a new backup with no flags set' do
        b = Backup.new(names:@names)
        b.daily || b.weekly || b.monthly == false
      end
    end

    describe '#deletable?' do
      before(:each) do
        @backup = Backup.new(names:@names)
      end

      it 'returns true if none of the daily, weekly, or monthly flags are
 set' do
        @backup.deletable?.should be_true
      end

      describe 'returns false if a flag is set' do
        %w{daily weekly monthly}.map do |interval|
          it "on the #{interval} flag" do
            @backup.send("#{interval}=", true)
            @backup.deletable?.should be_false
          end
        end
      end
    end

    describe '#date' do
      it 'allows reading of the date' do
        b = Backup.new(names:@names)
        b.date.should equal DateTime.strptime('20120819000003', '%Y%m%d%H%M%S')
      end
    end

    %w{daily weekly monthly}.map do |interval|
      describe "##{interval}" do
        it "allows setting of the #{interval} flag"
      end
    end

  end
end
