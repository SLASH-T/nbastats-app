# frozen_string_literal: true

module NBAStats
  class PlayerRepresenter < Roar::Decorator
    include Roar::JSON

    property :origin_id
    property :gameinfo_id
    property :game_id
    property :team_name
    property :player_name
    property :FGM
    property :FGA
    property :FGP
    property :TPM
    property :TPP
    property :TPA
    property :FTM
    property :FTA
    property :FTP
    property :OREB
    property :DREB
    property :REB
    property :AST
    property :TOV
    property :STL
    property :BLK
    property :PF
    property :PTS
    property :PM
    property :RK
  end
end
