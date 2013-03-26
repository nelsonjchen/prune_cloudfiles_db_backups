module PruneCloudfilesDbBackups
  class Backup
    attr_accessor :daily, :weekly, :monthly
    # Creates a new instance of backup with a grouped list of related files
    # @param [Array] array
    # @return [Backup]
    def initialize(array)
      @daily = false
      @weekly = false
      @monthly = false
    end

    def deletable?
      !(@daily|@weekly|@monthly)
    end
  end
end
