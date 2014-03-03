require 'bunny'
require 'amqp'
require 'eventmachine'

module BunnyHop
  class Reader
    def initialize(config)
      @config = config
    end

    def run(name, controller, settings = {})
      count = settings.fetch(:count, -1)
      EventMachine.run do
        conn = AMQP.connect(@config)
        conn.on_tcp_connection_loss {|c,s| c.reconnect()}
        channel = AMQP::Channel.new(conn, auto_recovery: true, prefetch: 1)
        queue = channel.queue(name, BunnyHop::Base::DEFAULT_MESSAGE_OPTIONS)
        queue.subscribe(:ack => true) do |meta, raw|
          handled = false
          for i in 0..3 do
            sleep(i) unless i == 0
            begin
              message = BunnyHop::Message.new(meta, Oj.load(raw, symbol_keys: true))
              meta.ack() && handled = true if controller.send(message.handler, message)
            rescue => e
              meta.ack() && handled = true if controller.error(e)
            end
            break if handled
          end
          count -= 1
          conn.close { EventMachine.stop } if count == 0 || handled == false
        end
      end
    end
  end
end
