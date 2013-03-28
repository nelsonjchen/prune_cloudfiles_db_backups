require 'active_support/time'

module PruneCloudfilesDbBackups
  class RetentionCalculator
    DAY_RETENTION   = 14
    WEEK_RETENTION  =  8
    MONTH_RETENTION = 12

    # @param [Array] objects from cloudfiles
    def initialize(objects)
      @now = DateTime.now

      sets = objects.group_by do |o|
        /(^.+\.pgdump).*/.match(o)[1]
      end

      @backup_sets = sets.map do |k, v|
        objects = Set.new(v)
        str_date = /\d{14}/.match(objects.first)[0]
        date = DateTime.strptime(str_date, '%Y%m%d%H%M%S')
        name = /(^.+\.pgdump).*/.match(objects.first)[1]
        daily = keep_daily_dates.include?(set.date.to_date)
        weekly = keep_weekly_dates.include?(set.date.to_date)
        monthly = keep_monthly_dates.include?(set.date.to_date)


        #Backup.new(objects, name, date, daily, weekly, monthly)
        Backup.new(Set.new(v))
      end

    end

    # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
    def keep_daily_dates
      @daily_dates ||= (0...DAY_RETENTION).map do |i|
        @now.at_midnight.advance(days: -i).to_date
      end
    end

    def keep_weekly_dates
      @weekly_dates ||= (0...WEEK_RETENTION).map do |i|
        # Sunday on the last couple of weeks
        @now.at_beginning_of_week(:sunday).advance(weeks: -i).to_date
      end
    end

    def keep_monthly_dates
      @monthly_dates ||= (0...MONTH_RETENTION).map do |i|
        # First Sunday of every month
        @now.at_beginning_of_month.advance(months: -i).advance(days: 6).beginning_of_week(:sunday).to_date
      end
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
