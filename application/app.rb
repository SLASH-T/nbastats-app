# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'
require 'benchmark'
require 'concurrent'


module NBAStats
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets'
    plugin :assets, css: 'simple-sidebar.css' , path: 'presentation/assets'
    plugin :flash

    use Rack::Session::Cookie

    route do |routing|
      routing.assets

      # GET / request
      routing.root do
        #repos_json = ApiGateway.new.scheduleinfo
        create_request = Forms::DateRequest.call(INPUT_DATETIME:"2017/04/16")
        result = AddGame.new.call(create_request)
        json_result = JSON.parse(result.success)

        def conc(schedule_hash)
          arr_gameinfo = []
          schedule_hash.each do |game|
            #Concurrent::Promise.execute do
              # game['date'] == '20170416'
              game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
              game_info = ApiGateway.new.gameinfo('2017-playoff', game_id)
              gameinfos = NBAStats::GameinfoRepresenter.new(OpenStruct.new)
                                                      .from_json game_info
              arr_gameinfo.push(gameinfos)
            #end
          end
          arr_gameinfo
        end
        arr_game_info = conc(json_result['schedules'])
        view 'index', locals: { gameinfos: arr_game_info }

=begin
        gameinfos_json = ApiGateway.new.gameinfo('2017-playoff','20170416-POR-GSW')
        gameinfos = NBAStats::GameinfoRepresenter.new(OpenStruct.new)
                                                .from_json gameinfos_json

        playerinfos_json = ApiGateway.new.playerinfo('2017-playoff','20170416-POR-GSW')
        playerinfos = NBAStats::PlayersRepresenter.new(OpenStruct.new)
                                                .from_json playerinfos_json

        schedules_json = ApiGateway.new.scheduleinfo('2017-playoff','20170416')
        schedulesinfos = NBAStats::SchedulesRepresenter.new(OpenStruct.new)
                                                .from_json schedules_json


        view 'index'
=end
=begin
        , locals: { gameinfos: gameinfos,
                               playerinfos: playerinfos.players,
                               schedulesinfos: schedulesinfos.schedules
                             }
=end
      end

      routing.on 'schedule' do
        routing.post do
           create_request = Forms::DateRequest.call(routing.params)
           result = AddGame.new.call(create_request)
           json_result = JSON.parse(result.success)

           def conc(schedule_hash)
             arr_gameinfo = []
             schedule_hash.each do |game|
               #Concurrent::Promise.execute do
                 #year = game['date'][0..3].to_i
                 #month = game['date'][4..5].to_i
                 season = ""
                 game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
=begin
                 if ( month >= 10 || month < 4 )
                   season = year.to_s + "-" + (year + 1).to_s + " Regular"
                 elsif ( month >= 4 && month <= 5)
                   season = year.to_s + "-" + "playoff"
                 else
                   season = ""
                 end
                 puts season
=end
                 game_info = ApiGateway.new.gameinfo('2017-playoff', game_id)
                 gameinfos = NBAStats::GameinfoRepresenter.new(OpenStruct.new)
                                                         .from_json game_info
                 arr_gameinfo.push(gameinfos)
                 #puts arr_gameinfo
               #end
             end
             arr_gameinfo
           end

           arr_game_info = conc(json_result['schedules'])

           if result.success?
             flash[:notice] = 'New Schedule added!'
             view 'index', locals: { gameinfos: arr_game_info }
           else
             flash[:error] = 'Cannot New Schedule!'
           end

           #routing.redirect '/'
        end
      end
    end
  end
end
