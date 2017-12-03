require 'dry-validation'

module NBAStats
  module Forms
    DateRequest = Dry::Validation.Form do
      DATE_REGEX = %r{.*\/.*\/.*$}
      required(:INPUT_DATETIME).filled(format?: DATE_REGEX)

      configure do
        config.messages_file = File.join(__dir__, 'errors/url_request.yml')
      end
    end
  end
end
