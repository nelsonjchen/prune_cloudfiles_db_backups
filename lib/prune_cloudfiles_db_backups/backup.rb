require 'date'

module PruneCloudfilesDbBackups
  class Backup
    attr_accessor :daily, :weekly, :monthly
    attr_reader :date
    attr_reader :names

    # Creates a new instance of backup with a grouped list of related files
    # @param [Set] names
    # @return [Backup]
    def initialize(names)
      @names = names[:names]
      @daily = false
      @weekly = false
      @monthly = false
      str_date = /\d{14}/.match(@names.first)[0]
      @date = DateTime.strptime(str_date, '%Y%m%d%H%M%S')
    end

    def deletable?
      !(@daily|@weekly|@monthly)
    end

    # @param [Backup] other_backup
    def ==(other_backup)
      self.names == other_backup.names
    end
  end
end
