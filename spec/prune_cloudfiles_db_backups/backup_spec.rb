require "rspec"
require 'prune_cloudfiles_db_backups/backup'

module PruneCloudfilesDbBackups
  describe Backup do
    describe '#initialize' do
      it 'can create a backup with a name, date, and set of object names'

      it 'can create a new backup with no flags set'
    end

    describe '#deletable?' do
      it 'returns false if either the name, date, or set of object are not set'
      it 'returns true if none of the daily, weekly, or monthly flags are set'
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
