require 'bunny'

module BunnyHop
  class Manager < Base
    def subscribe(name, routes, options = DEFAULT_MESSAGE_OPTIONS)
      routes.each do |route|
        @channel.queue(name, options).bind(@exchange, routing_key: route)
      end
    end

    def unsubscribe(queue, routes, options = DEFAULT_MESSAGE_OPTIONS)
      routes.each do |route|
        @channel.queue(queue, options).unbind(@exchange, routing_key: route)
      end
    end

    def delete(queue, options = DEFAULT_MESSAGE_OPTIONS)
      @channel.queue(queue, options).delete()
    end
  end
end
