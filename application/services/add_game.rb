require 'dry/transaction'

module NBAStats
  class AddGame
    include Dry::Transaction

    step :validate_input
    step :add_game

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
      Right(result)
    rescue StandardError => error
      Left(error.to_s)
    end
  end
end
