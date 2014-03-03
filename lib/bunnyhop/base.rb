require 'bunny'

module BunnyHop
  class Base
    DEFAULT_MESSAGE_OPTIONS = {durable: true}.freeze
    attr_reader :client, :connection

    def initialize(config)
      self.class.validate!(config)
      @client = config[:application]
      @config = config
      connect()
    end

    def close
      begin
        @connection.stop()
      rescue
      end
    end

    def reconnect(sleep = nil)
      sleep(sleep) unless sleep.nil?
      close()
      connect()
    end

    private
    def connect()
      @connection = Bunny.new({
        host: @config[:host],
        port: @config[:port],
        username: @config[:username],
        password: @config[:password],
        keepalive: true,
        threaded: false,
        socket_timeout: 0,
        connect_timeout: 0
      })
      @connection.start()
      @channel = @connection.create_channel()
      @exchange = @channel.topic(@config[:exchange], {durable: @config.fetch(:durable,  true)})
    end

    def self.validate!(config)
      [:application, :exchange].each do |key|
        raise "#{key} is required when creating a #{self.name}" if config[key].nil? || config[key] == ''
      end
    end

  end
end
