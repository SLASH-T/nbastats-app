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
        # season = '2017-playoff'
        date = input[:INPUT_DATETIME]
        date = date.tr_s('/', '')
        date_int = date.to_i
        case date_int
        when 1..20151027
          Left(input.errors.value.join('; '))
        when 20151028..20160417
          season = '2015-2016-regular'
        when 20160418..20160620
          season = '2016-playoff'
        when 20161024..20170414
          season = '2016-2017-regular'
        when 20170415..20170613
          season = '2017-playoff'
        else
          season = '2017-2018-regular'
        end
        puts season
        Right(season: season, date: date)
      else
        Left(input.errors.value.join('; '))
      end
    end

    def add_game(input)
      puts "step1"
      result = ApiGateway.new.scheduleinfo(input[:season],input[:date])
      puts "step2"
      Right(result: result.message)
    rescue StandardError => error
      Left(error.to_s)
    end

    def parse_game(input)
      puts "step3"
      result_json = JSON.parse(input[:result])
      # result_json.each_key {|key| puts key}
      if result_json.keys[0] == 'message'
        Left(result_json.values[0])
      elsif result_json.keys[0] == 'schedules'
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
