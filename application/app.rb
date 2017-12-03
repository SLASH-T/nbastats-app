# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
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
=end

        view 'index'
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
           puts "---"
           puts result.success
           puts result.success['schedules']
           puts "---"

           def sync(schedule_hash)
             # schedule_hash = result.success['schedules']
             schedule_hash.each do |game|
               game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
               # puts game_id
               game_info = ApiGateway.new.gameinfo('2017-playoff', game_id)
               # puts game_info
               player_info = ApiGateway.new.playerinfo('2017-playoff', game_id)
               # puts player_info
             end

           end

           def conc(schedule_hash)
             # schedule_hash = result.success['schedules']
             schedule_hash.each do |game|
               Concurrent::Promise.execute do
                 game_id = game['date'] + '-' + game['away_abbreviation'] + '-' + game['home_abbreviation']
                 # puts game_id
                 game_info = ApiGateway.new.gameinfo('2017-playoff', game_id)
                 # puts game_info
                 player_info = ApiGateway.new.playerinfo('2017-playoff', game_id)
               end
               # puts player_info
             end
           end

           Benchmark.bm do |x|
             x.report('sync') { sync(result.success['schedules']) }
             # x.report('conc') { conc(result.success['schedules']) }
           end

           if result.success?
             flash[:notice] = 'New Schedule added!'
           else
             flash[:error] = 'Cannot New Schedule!'
           end

           routing.redirect '/'


        end
      end
=begin

      routing.on 'gameinfo' do
        routing.post do
          gameinfo_url = routing.params['github_url'].downcase
          halt 400 unless (gh_url.include? 'github.com') &&
                          (gh_url.split('/').count > 2)
          season, gameid = gh_url.split('/')[-2..-1]
          ApiGateway.new.create_gameinfo(season, gameid)
        end
      end
=end
    end
  end
end
