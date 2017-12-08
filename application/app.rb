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
        routing.redirect '/schedule'
      end

      routing.on 'schedule' do
        create_request = Forms::DateRequest.call(INPUT_DATETIME:"2017/04/16")
        result = AddGame.new.call(create_request)
        json_result = JSON.parse(result.success)
        arr_game_info = LoadData.new.load_gameinfo(json_result['schedules'])

        routing.post do
           create_request = Forms::DateRequest.call(routing.params)
           result = AddGame.new.call(create_request)
           json_result = JSON.parse(result.success)

           arr_game_info = LoadData.new.load_gameinfo(json_result['schedules'])

           if result.success?
             flash[:notice] = 'New Schedule added!'
             view 'index', locals: { gameinfos: arr_game_info }
           else
             flash[:error] = 'Cannot New Schedule!'
           end
        end
        view 'index', locals: { gameinfos: arr_game_info }
      end
    end
  end
end
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
