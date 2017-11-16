# frozen_string_literal: true

require_relative 'gameinfo_representer'

# Represents essential gameinfo information for API output
module NBAStats
  class GameInfosRepresenter < Roar::Decorator
    include Roar::JSON

    collection :gameinfos, extend: GameInfoRepresenter, class: OpenStruct
  end
end