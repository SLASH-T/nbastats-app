require 'dry/transaction'
require 'json'

module NBAStats
  class AddGame
    include Dry::Transaction

    step :validate_input
    step :add_game
    step :parse_game

    def validate_input(input)
      if input.success?
        season = '2017-playoff'
        date = input[:INPUT_DATETIME]
        date = date.tr_s("/", "")
        Right(season: season, date: date)
      else
        Left(input.errors.value.join('; '))
      end
    end

    def add_game(input)
      result = ApiGateway.new.scheduleinfo(input[:season],input[:date])
      Right(result: result.message)
    rescue StandardError => error
      Left(error.to_s)
    end

    def parse_game(input)
      result_json = JSON.parse(input[:result])
      #result_json.each_key {|key| puts key}
      if result_json.keys[0] == "message"
        Left(result_json.values[0])
      elsif result_json.keys[0] == "schedules"
        if !result_json['schedules'].empty?
          Right(result_json)
        else
          Left(result_json.values[0])
        end
      else
        Left(result_json.values[0])
      end
    end
  end
end
