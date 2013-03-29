require 'rspec'
require 'prune_cloudfiles_db_backups/backup'

module PruneCloudfilesDbBackups
  describe Backup do
    before(:each) do
      @object_pile = %w{
          reports_production-20120819000003.pgdump
          reports_production-20120819000003.pgdump.000
          reports_production-20120819000003.pgdump.001
        }.to_set
      @datetime = DateTime.strptime('20120819000003', '%Y%m%d%H%M%S')
      @name = 'reports_production-20120819000003'
    end

    describe '#initialize' do
      it 'is created with a hash' do
        Backup.new({ objects: @object_pile,
                     name: @name,
                     datetime: @datetime,
                     monthly: false,
                     weekly: false,
                     daily: false
                   })
      end
    end

    describe '#deletable?' do
      it 'returns true if none of the daily, weekly, or monthly flags are
 false' do
        backup = Backup.new({ objects: @object_pile,
                              name: @name,
                              datetime: @datetime,
                              monthly: false,
                              weekly: false,
                              daily: false
                            })

        backup.deletable?.should be_true
      end

      it 'returns false if a certain flag (say, monthly) is set' do
        backup = Backup.new({ objects: @object_pile,
                              name: @name,
                              datetime: @datetime,
                              monthly: true,
                              weekly: false,
                              daily: false
                            })

        backup.deletable?.should be_false
      end
    end

    describe '#==' do
      it 'allows an equality comparison of backups that checks each field' do
        one = Backup.new(objects: @object_pile, name: @name, datetime: @datetime)
        two= Backup.new(objects: @object_pile, name: @name, datetime: @datetime)
        one.should == two
      end
    end

  end
end
