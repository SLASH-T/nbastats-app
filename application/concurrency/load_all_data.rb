module NBAStats
  class LoadData

    def initialize()
    end

    def load_gameinfo(schedule_hash)
    arr_gameinfo = []
    a = ''
      schedule_hash.each do |game|
        a = Concurrent::Promise.execute do
          game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
          game_info = ApiGateway.new.gameinfo('2017-playoff', game_id)
          gameinfos = NBAStats::GameinfoRepresenter.new(OpenStruct.new)
                                                  .from_json game_info.message
          arr_gameinfo.push(gameinfos)
        end
      end
      a.wait
      a.value
    end
  end
end
