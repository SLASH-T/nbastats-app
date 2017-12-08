module NBAStats
  class LoadData

  	def initialize()
  	end

  	def load_gameinfo(schedule_hash)
	  arr_gameinfo = []
      schedule_hash.each do |game|
        Concurrent::Promise.execute do
          game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
          game_info = ApiGateway.new.gameinfo('2017-playoff', game_id)
          gameinfos = NBAStats::GameinfoRepresenter.new(OpenStruct.new)
                                                  .from_json game_info
          arr_gameinfo.push(gameinfos)
        end
      end
      arr_gameinfo
    end
  end
end
