require 'date'

module PruneCloudfilesDbBackups
  class Backup
    attr_reader :daily, :weekly, :monthly
    attr_reader :date
    attr_reader :objects
    attr_reader :name

    # Creates a new instance of backup with a grouped set of related files
    # @param [Hash] options in the form of a hash
    # @option options [Set] :objects
    # @option options [String] :name
    # @option options [DateTime] :date
    # @option options [Boolean] :monthly
    # @option options [Boolean] :weekly
    # @option options [Boolean] :daily
    # @return [Backup]
    def initialize(options = {})
      @objects = options[:objects] || (raise ArgumentError, 'Objects not specified')
      @name = options[:name] || (raise ArgumentError, 'Name not specified')
      @date = options[:date] || (raise ArgumentError, 'Date not specified')
      @monthly = options[:monthly]
      @weekly = options[:weekly]
      @daily = options[:daily]
    end

    def dbname
      /(.+)\d{14}/.match(@name)
    end

    def deletable?
      !(@daily|@weekly|@monthly)
    end

    # @param [Backup] other_backup
    def ==(other_backup)
      self.objects == other_backup.objects
    end

    #noinspection RubyResolve
    def to_s
      mwd = '['
      mwd << 'd' if @daily
      mwd << '-' unless @daily
      mwd << 'w' if @weekly
      mwd << '-' unless @weekly
      mwd << 'm' if @monthly
      mwd << '-' unless @monthly
      mwd << ']'

      "#{mwd} #{dbname} #{@date.rfc822} (#{objects.size} item(s))"
    end
  end
end
