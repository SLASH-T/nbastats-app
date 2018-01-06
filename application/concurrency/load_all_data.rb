module NBAStats
  class LoadData

    def initialize()
    end

    def load_gameinfo(schedule_hash)
      promises = schedule_hash.map do |game|
        Concurrent::Promise.execute do
          game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
          game_info = ApiGateway.new.gameinfo('2017-playoff', game_id)
          gameinfos = NBAStats::GameinfoRepresenter.new(OpenStruct.new)
                                                  .from_json game_info.message
          gameinfos['away_abbreviation'] = game['away_abbreviation']
          gameinfos['home_abbreviation'] = game['home_abbreviation']
          gameinfos
        end
      end
      promises.map { |promised_stats| promised_stats.value }
    end

    def load_playerinfo(schedule_hash)
      promises = schedule_hash.map do |game|
        Concurrent::Promise.execute do
          game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
          player_info = ApiGateway.new.playerinfo('2017-playoff', game_id)
          players = NBAStats::PlayersRepresenter.new(OpenStruct.new)
                                                  .from_json player_info.message
        end
      end
      promises.map { |promised_stats| promised_stats.value }
    end
  end
end
