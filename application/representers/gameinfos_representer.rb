# frozen_string_literal: true

require_relative 'gameinfo_representer'

# Represents essential gameinfo information for API output
module NBAStats
  class GameinfosRepresenter < Roar::Decorator
    include Roar::JSON

    collection :gameinfos, extend: GameinfoRepresenter, class: OpenStruct
  end
end
