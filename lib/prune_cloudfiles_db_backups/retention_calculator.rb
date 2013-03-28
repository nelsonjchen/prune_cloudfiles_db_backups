require 'active_support/time'

module PruneCloudfilesDbBackups
  class RetentionCalculator

    # Initialize the Retention Calculator with a list of cloudfile
    # container objects
    # @param [Array] objects from cloudfiles
    # @param [Integer] day_retention
    # @param [Integer] week_retention
    # @param [Integer] month_retention
    def initialize(objects,
        day_retention = 14,
        week_retention = 8,
        month_retention = 12)
      @day_retention = day_retention
      @week_retention = week_retention
      @month_retention = month_retention

      @now = DateTime.now

      sets = objects.group_by do |o|
        /(^.+\.pgdump).*/.match(o)[1]
      end

      @backup_sets = sets.map do |_, v|
        objects = Set.new(v)
        datetime = Backup.parse_for_datetime(objects)

        daily = keep_daily_dates.include?(datetime.to_date)
        weekly = keep_weekly_dates.include?(datetime.to_date)
        monthly = keep_monthly_dates.include?(datetime.to_date)

        Backup.new(objects: objects,
                   datetime: datetime,
                   daily: daily,
                   weekly: weekly,
                   monthly: monthly)
      end.to_set

    end

    # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script

    # @return [Set] a calculated array of days to be kept
    def keep_daily_dates
      @daily_dates ||= (0...@day_retention).map do |i|
        @now.at_midnight.advance(days: -i).to_date
      end.to_set
    end

    # @return [Set] a calculated array of days to be kept
    def keep_weekly_dates
      @weekly_dates ||= (0...@week_retention).map do |i|
        # Sunday on the last couple of weeks
        @now.at_beginning_of_week(:sunday).advance(weeks: -i).to_date
      end.to_set
    end

    # @return [Set] a calculated array of days to be kept
    def keep_monthly_dates
      @monthly_dates ||= (0...@month_retention).map do |i|
        # First Sunday of every month
        @now.at_beginning_of_month.advance(months: -i).advance(days: 6).beginning_of_week(:sunday).to_date
      end.to_set
    end

    # @return [Set] a set of files for deletion
    def to_delete
      @backup_sets.select do |set|
        set.deletable?
      end
    end

    # @return [Set] a set of files that will be kept
    def to_keep
      @backup_sets.select do |set|
        !set.deletable?
      end
    end

  end
end
