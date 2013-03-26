require 'spec_helper'
require 'prune_cloudfiles_db_backups/version'

module PruneCloudfilesDbBackups
  describe 'VERSION' do
    it 'returns a string with a valid version' do
      VERSION.should be_a(String)
    end
  end
end
