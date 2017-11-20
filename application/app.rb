# frozen_string_literal: true

require 'roda'
require 'slim'

module NBAStats
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets'

    route do |routing|
      routing.assets
      app = App

      # GET / request
      routing.root do
        gameinfos_json = ApiGateway.new.gameinfo('2017-playoff','20170416-POR-GSW')
        gameinfos = NBAStats::GameinfoRepresenter.new(OpenStruct.new)
                                                .from_json gameinfos_json


        playerinfos_json = ApiGateway.new.playerinfo('2017-playoff','20170416-POR-GSW')
        playerinfos = NBAStats::PlayersRepresenter.new(OpenStruct.new)
                                                .from_json playerinfos_json
        #puts playerinfos.players
        #puts playerinfos_json
        #puts playerinfos.team_name
        view 'home', locals: { gameinfos: gameinfos,
                               playerinfos: playerinfos.players}
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
