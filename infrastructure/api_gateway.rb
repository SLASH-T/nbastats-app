require 'http'
require 'json'

module NBAStats
  class ApiGateway
    class ApiResponse
      HTTP_STATUS = {
        200 => :ok,
        201 => :created,
        202 => :processing,
        204 => :no_content,

        403 => :forbidden,
        404 => :not_found,
        400 => :bad_request,
        409 => :conflict,
        422 => :cannot_process,

        500 => :internal_error
      }.freeze

      attr_reader :status, :message

      def initialize(code, message)
        @code = code
        @status = HTTP_STATUS[code]
        @message = message
      end

      def ok?
        HTTP_STATUS[@code] == :ok
      end

      def processing?
        HTTP_STATUS[@code] == :processing
      end
    end

    def initialize(config = NBAStats::App.config)
      @config = config
    end

    def gameinfo(season,gameid)
      call_api(:get,['game_info', season, gameid])
    end

    def playerinfo(season,gameid)
      call_api(:get,['player_info', season, gameid])
    end

    def scheduleinfo(season,date)
      call_api(:get,['schedule', season, date])
    end

    def create_gameinfo(season,gameid)
      call_api(:post,['game_info', season, gameid])
    end

    def create_playerinfo(season,gameid)
      call_api(:post,['player_info', season, gameid])
    end

    def create_scheduleinfo(season,date)
      call_api(:post,['schedule', season, date])
    end

    def call_api(method, resources)
      url_route = [@config.api_url, resources].flatten.join'/'

      #puts url_route
      result = HTTP.send(method, url_route)
      #puts "==|+=="
      #puts result.to_s
      #puts "==|-=="
      raise(result.to_s) if result.code >= 300
      ApiResponse.new(result.code, result.to_s)
    end
  end
end
