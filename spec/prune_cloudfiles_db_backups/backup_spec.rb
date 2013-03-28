require 'rspec'
require 'prune_cloudfiles_db_backups/backup'

module PruneCloudfilesDbBackups
  describe Backup do
    before(:each) do
      @objects = %w{
          reports_production-20120819000003.pgdump
          reports_production-20120819000003.pgdump.000
          reports_production-20120819000003.pgdump.001
        }.to_set
    end

    describe '#initialize' do
      it 'can create a backup with a set of object names' do
        Backup.new(@objects)
      end

      it 'can create a new backup with no flags set' do
        b = Backup.new(@objects)
        b.daily || b.weekly || b.monthly == false
      end
    end

    describe '#deletable?' do
      before(:each) do
        @backup = Backup.new(@objects)
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
        b = Backup.new(@objects)
        b.date.should == DateTime.strptime('20120819000003', '%Y%m%d%H%M%S')
      end
    end

    %w{daily weekly monthly}.map do |interval|
      describe "##{interval}" do
        it "allows setting of the #{interval} flag" do
          b = Backup.new(@objects)
          b.send("#{interval}=", true)
        end
      end
    end

    describe '#==' do
      it 'allows an equality comparison of backups that checks each field' do
        Backup.new(@objects).should == Backup.new(@objects)
      end
    end

  end
end
