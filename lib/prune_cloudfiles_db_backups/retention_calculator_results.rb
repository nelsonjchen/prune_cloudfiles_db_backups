module PruneCloudfilesDbBackups
  class RetentionCalculatorResults
    attr_reader :delete_objects, :keep_objects

    def initialize(delete_objects, keep_objects)
      @delete_objects = delete_objects
      @keep_objects = keep_objects
    end
  end
end
