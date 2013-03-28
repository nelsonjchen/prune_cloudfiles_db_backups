require 'date'

module PruneCloudfilesDbBackups
  class Backup
    attr_reader :daily, :weekly, :monthly
    attr_reader :datetime
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
      @name = options[:name] || self.class.parse_for_name(@objects)
      @datetime = options[:datetime] || self.class.parse_for_datetime(@objects)
      @monthly = options[:monthly]
      @weekly = options[:weekly]
      @daily = options[:daily]
    end

    # @param [Enumerable] objects
    def self.parse_for_name(objects)
      /(^.+\.pgdump).*/.match(objects.first)[1]
    end

    # @param [Enumerable] objects
    def self.parse_for_datetime(objects)
      str_date = /\d{14}/.match(objects.first)[0]
      DateTime.strptime(str_date, '%Y%m%d%H%M%S')
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

      "#{mwd} #{dbname} #{@datetime.rfc822} (#{objects.size} item(s))"
    end
  end
end
