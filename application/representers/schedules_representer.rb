# frozen_string_literal: true

require_relative 'schedule_representer'

# Represents essential gameinfo information for API output
module NBAStats
  class SchedulesRepresenter < Roar::Decorator
    include Roar::JSON

    collection :schedules, extend: ScheduleRepresenter, class: OpenStruct
  end
end
