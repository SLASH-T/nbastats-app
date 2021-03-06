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
        puts "step4"
        if result.success?
          flash[:notice] = 'New Schedule added!'
          $arr_game_info = LoadData.new.load_gameinfo(result.success['schedules'])
          $arr_player_info = LoadData.new.load_playerinfo(result.success['schedules'])

          temp = []
          final = []
          #puts $arr_player_info
          $arr_player_info.each do |players|
            players.players.each do |player|
                temp.push(player.RK.to_f)
            end
          end
          temp.sort!
          #puts "-----"
          $arr_player_info.each do |players|
            players.players.each do |player|
              if (temp[temp.length-1] == player.RK.to_f)
                final.push(player)
              end
              if (temp[temp.length-2] == player.RK.to_f)
                final.push(player)
              end
              if (temp[temp.length-3] == player.RK.to_f)
                final.push(player)
              end
              if (temp[temp.length-4] == player.RK.to_f)
                final.push(player)
              end
              if (temp[temp.length-5] == player.RK.to_f)
                final.push(player)
              end
            end
          end
          view 'index', locals: { gameinfos: $arr_game_info,
                                  topplayer_five: final}
        else
          flash[:error] = 'Cannot New Schedule!'
        end
      end

      $arr_player_info
      $arr_game_info

      routing.on 'schedule' do
        routing.post do
           #puts routing.params
           create_request = Forms::DateRequest.call(routing.params)
           result = AddGame.new.call(create_request)
           # puts result.value.class
           if result.success?
             flash[:notice] = 'New Schedule added!'
             $arr_game_info = LoadData.new.load_gameinfo(result.success['schedules'])
             $arr_player_info = LoadData.new.load_playerinfo(result.success['schedules'])
             temp = []
             final = []
             #puts $arr_player_info
             $arr_player_info.each do |players|
               players.players.each do |player|
                   temp.push(player.RK.to_f)
               end
             end
             temp.sort!
             #puts "-----"
             $arr_player_info.each do |players|
               players.players.each do |player|
                 if (temp[temp.length-1] == player.RK.to_f)
                   final.push(player)
                 end
                 if (temp[temp.length-2] == player.RK.to_f)
                   final.push(player)
                 end
                 if (temp[temp.length-3] == player.RK.to_f)
                   final.push(player)
                 end
                 if (temp[temp.length-4] == player.RK.to_f)
                   final.push(player)
                 end
                 if (temp[temp.length-5] == player.RK.to_f)
                   final.push(player)
                 end
               end
             end
             view 'index', locals: { gameinfos: $arr_game_info,
                                     topplayer_five: final}

           else
             if result.value[0] == "Processing the summary request"
               flash[:notice] = "Processing........."
               routing.redirect '/'
             else
               flash[:error] = 'No Game Today!!'
               routing.redirect '/'
             end
           end
        end
      end
      routing.on 'game_data' do
        routing.post do
          temp_home = []
          temp_away = []
          final_home = []
          final_away = []
          #puts $arr_player_info
          $arr_player_info.each do |players|
            players.players.each do |player|
              if (player.team_name == routing.params['home_team'])
                temp_home.push(player.RK.to_f)
              end
              if (player.team_name == routing.params['away_team'])
                temp_away.push(player.RK.to_f)
              end
            end
          end
          temp_home.sort!
          temp_away.sort!
          #puts "-----"
          $arr_player_info.each do |players|
            players.players.each do |player|
              if (temp_home[temp_home.length-1] == player.RK.to_f && player.team_name == routing.params['home_team'])
                final_home.push(player)
              end
              if (temp_home[temp_home.length-2] == player.RK.to_f && player.team_name == routing.params['home_team'])
                final_home.push(player)
              end
              if (temp_home[temp_home.length-3] == player.RK.to_f && player.team_name == routing.params['home_team'])
                final_home.push(player)
              end

              if (temp_away[temp_away.length-1] == player.RK.to_f && player.team_name == routing.params['away_team'])
                final_away.push(player)
              end
              if (temp_away[temp_away.length-2] == player.RK.to_f && player.team_name == routing.params['away_team'])
                final_away.push(player)
              end
              if (temp_away[temp_away.length-3] == player.RK.to_f && player.team_name == routing.params['away_team'])
                final_away.push(player)
              end
            end
          end
          $arr_game_info.each do |gameinfo|
            if gameinfo.home_team == routing.params["home_team"]
              $home_score = gameinfo.home_score
            end
            if gameinfo.away_team == routing.params["away_team"]
              $away_score = gameinfo.away_score
            end
          end
          view 'player_data',locals: { playerinfos: $arr_player_info ,
                                       teamname: routing.params,
                                       topplayer_home: final_home,
                                       topplayer_away: final_away,
                                       home_game_score: $home_score,
                                       away_game_score: $away_score
                                     }
        end
      end
    end
  end
end
