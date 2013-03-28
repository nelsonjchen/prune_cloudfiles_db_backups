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

      backup_sets = sets.map do |k, v|
        Backup.new(v)
      end

      @backup_sets_by_date = backup_sets.group_by do |set|
         set.date.to_date
      end



    end

    # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
    def keep_daily_dates
      (0...DAY_RETENTION).map do |i|
        now.at_midnight.advance(days: -i).to_date
      end
    end

    def keep_weekly_dates
      (0...WEEK_RETENTION).map do |i|
        # Sunday on the last couple of weeks
        now.at_beginning_of_week(:sunday).advance(weeks: -i).to_date
      end
    end

    def keep_monthly_dates
      (0...MONTH_RETENTION).map do |i|
        # First Sunday of every month
        now.at_beginning_of_month.advance(months: -i).advance(days: 6).beginning_of_week(:sunday)
      end
    end

    # @return [Set] a set of files for deletion
    def to_delete

    end

    # @return [Object] a set of files that will be kept
    def to_keep

    end

    #attr_reader :results
    #
    #DAY_RETENTION   = 14
    #WEEK_RETENTION  =  8
    #MONTH_RETENTION = 12
    #
    #def initialize(objects)
    #
    #  @now = Time.now.utc
    #  keep_objects = objects.select do |object|
    #    date = /(\d{8})/.match(object)[0]
    #    keep_dates.map { |d| d.strftime("%Y%m%d") }.include?(date)
    #  end
    #
    #  delete_objects = objects - keep_objects
    #end
    #
    #private
    #
    #def keep_dates
    #  # Based off of http://www.infi.nl/blog/view/id/23/Backup_retention_script
    #  keep_list = []
    #
    #  DAY_RETENTION.times do |i|
    #    keep_list << @now.at_midnight.advance(days: -i)
    #  end
    #
    #  WEEK_RETENTION.times do |i|
    #    # Sunday on the last couple of weeks
    #    keep_list << @now.at_beginning_of_week(:sunday).advance(weeks: -i)
    #  end
    #
    #  MONTH_RETENTION.times do |i|
    #    # First Sunday of every month
    #    keep_list << @now.at_beginning_of_month.advance(months: -i).advance(days: 6).beginning_of_week(:sunday)
    #  end
    #
    #  keep_list
    #end
  end
end
