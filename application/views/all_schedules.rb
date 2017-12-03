module NBAStats
  module Views
    class AllSchedules
      def initialize(all_schedules)
        @all_schedules = all_schedules
      end

      def none?
        @all_schedules.schedules.none?
      end

      def any?
        @all_schedules.schedules.any?
      end

      def collection
        @all_schedules.schedules.map { |schedule| Schedule.new(schedule) }
      end
    end
  end
end
