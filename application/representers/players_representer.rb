# frozen_string_literal: true

require_relative 'player_representer'

# Represents essential gameinfo information for API output
module NBAStats
  class PlayersRepresenter < Roar::Decorator
    include Roar::JSON

    collection :players, extend: PlayerRepresenter, class: OpenStruct
  end
end