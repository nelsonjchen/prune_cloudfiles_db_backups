require 'date'

module PruneCloudfilesDbBackups
  class Backup
    attr_accessor :daily, :weekly, :monthly
    attr_reader :date
    attr_reader :objects
    attr_reader :dbname

    # Creates a new instance of backup with a grouped set of related files
    # @param [Set] object_set
    # @return [Backup]
    def initialize(object_set)
      @objects = object_set
      @daily = false
      @weekly = false
      @monthly = false
      str_date = /\d{14}/.match(@objects.first)[0]
      @name = /(^.+\.pgdump).*/.match(@objects.first)[1]
      @dbname = /(^.+)-\d{14}\.pgdump.*/.match(@objects.first)[1]
      @date = DateTime.strptime(str_date, '%Y%m%d%H%M%S')
    end

    def deletable?
      !(@daily|@weekly|@monthly)
    end

    # @param [Backup] other_backup
    def ==(other_backup)
      self.objects == other_backup.objects
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

      "#{mwd} #{@dbname} #{@date.rfc822} (#{objects.size} item(s))"
    end
  end
end
