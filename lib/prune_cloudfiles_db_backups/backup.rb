require 'date'

module PruneCloudfilesDbBackups
  class Backup
    attr_accessor :daily, :weekly, :monthly
    attr_reader :date

    # Creates a new instance of backup with a grouped list of related files
    # @param [Array] array
    # @return [Backup]
    def initialize(array)
      @daily = false
      @weekly = false
      @monthly = false
      str_date = /.*(\d{14}).*/.match(array[:names].first)[0]
      @date = DateTime.strptime(str_date, '%Y%m%d%H%M%S')
    end

    def deletable?
      !(@daily|@weekly|@monthly)
    end
  end
end
