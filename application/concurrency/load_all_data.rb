module NBAStats
  class LoadData

    def initialize()
    end

    def load_gameinfo(schedule_hash)
      promises = schedule_hash.map do |game|
        Concurrent::Promise.execute do
          date_int = game['date'].to_i
          case date_int
          when 20151028..20160417
            season = '2015-2016-regular'
          when 20160418..20160620
            season = '2016-playoff'
          when 20161024..20170414
            season = '2016-2017-regular'
          when 20170415..20170613
            season = '2017-playoff'
          else
            season = '2017-2018-regular'
          end
          game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
          game_info = ApiGateway.new.gameinfo(season, game_id)
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
          date_int = game['date'].to_i
          case date_int
          when 20151028..20160417
            season = '2015-2016-regular'
          when 20160418..20160620
            season = '2016-playoff'
          when 20161024..20170414
            season = '2016-2017-regular'
          when 20170415..20170613
            season = '2017-playoff'
          else
            season = '2017-2018-regular'
          end
          game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
          player_info = ApiGateway.new.playerinfo(season, game_id)
          players = NBAStats::PlayersRepresenter.new(OpenStruct.new)
                                                  .from_json player_info.message
        end
      end
      promises.map { |promised_stats| promised_stats.value }
    end
  end
end
