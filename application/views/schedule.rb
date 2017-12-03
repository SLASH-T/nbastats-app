module NBAStats
  module Views
    class Schedule
      def initialize(schedule)
        @schedule = schedule
      end

      def away_team
        @schedule.away_team
      end

      def home_team
        @schedule.home_team
      end

      def away_score
        @schedule.away_score
      end

      def home_score
        @schedule.home_score
      end
      
    end
  end
end
