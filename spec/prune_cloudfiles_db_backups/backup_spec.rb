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
      @date = DateTime.strptime('20120819000003', '%Y%m%d%H%M%S')
      @name = 'reports_production-20120819000003'
    end

    describe '#initialize' do
      it 'is created with a hash' do
        Backup.new({ objects: @objects,
                     name: @name,
                     date: @date,
                     monthly: false,
                     weekly: false,
                     daily: false
                   })
      end
    end

    describe '#deletable?' do
      it 'returns true if none of the daily, weekly, or monthly flags are
 false' do
        backup = Backup.new({ objects: @objects,
                               name: @name,
                               date: @date,
                               monthly: false,
                               weekly: false,
                               daily: false
                             })

        backup.deletable?.should be_true
      end

      it 'returns false if a certain flag (say, monthly) is set' do
        backup = Backup.new({ objects: @objects,
                               name: @name,
                               date: @date,
                               monthly: true,
                               weekly: false,
                               daily: false
                             })

        backup.deletable?.should be_false
      end
    end

    describe '#==' do
      it 'allows an equality comparison of backups that checks each field' do
        Backup.new(@objects).should == Backup.new(@objects)
      end
    end

  end
end
