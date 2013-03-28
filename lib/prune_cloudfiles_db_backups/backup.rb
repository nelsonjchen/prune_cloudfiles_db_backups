require 'date'

module PruneCloudfilesDbBackups
  class Backup
    attr_accessor :daily, :weekly, :monthly
    attr_reader :date
    attr_reader :names

    # Creates a new instance of backup with a grouped set of related files
    # @param [Set] names
    # @return [Backup]
    def initialize(names)
      @names = names
      @daily = false
      @weekly = false
      @monthly = false
      str_date = /\d{14}/.match(@names.first)[0]
      @name = /(^.+\.pgdump).*/.match(@names.first)[1]
      @dbname = /(^.+)-\d{14}\.pgdump.*/.match(@names.first)[1]
      @date = DateTime.strptime(str_date, '%Y%m%d%H%M%S')
    end

    def deletable?
      !(@daily|@weekly|@monthly)
    end

    # @param [Backup] other_backup
    def ==(other_backup)
      self.names == other_backup.names
    end

    def to_s
      mwd = '['
      mwd << 'm' if @daily
      mwd << '-' unless @daily
      mwd << 'w' if @daily
      mwd << '-' unless @daily
      mwd << 'm' if @daily
      mwd << '-' unless @daily
      mwd << ']'

      "#{mwd} #{@dbname} #{@date.rfc822} (#{names.size} item(s))"
    end
  end
end
