module NBAStats
  class GameinfoRepresenter < Roar::Decorator
    include Roar::JSON

    property :origin_id
    property :date
    property :location
    property :away_team
    property :home_team
    property :away_score
    property :home_score
    property :away_score_q1
    property :away_score_q2
    property :away_score_q3
    property :away_score_q4
    property :home_score_q1
    property :home_score_q2
    property :home_score_q3
    property :home_score_q4
  end
end
