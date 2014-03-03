require 'bunny'

module BunnyHop
  class Writer < Base
    DEFAULT_SETTINGS = {}.freeze

    def create(version, resource, id, payload, settings = DEFAULT_SETTINGS)
      write(:create, version, resource, id, payload, settings)
    end

    def update(version, resource, id, payload, settings = DEFAULT_SETTINGS)
      write(:update, version, resource, id, payload, settings)
    end

    def delete(version, resource, id, settings = DEFAULT_SETTINGS)
      write(:delete, version, resource, id, nil, settings)
    end

    private
    def build_message!(action, version, resource, id, payload)
      message = {action: action, version: version, resource: resource, id: id, client: @client}
      message[:payload] = payload unless payload.nil?
      message
    end

    def write(action, version, resource, id, payload, settings)
      message = Oj.dump(build_message!(action, version, resource, id, payload), mode: :compat)
      route = "#{settings[:prefix] || 'models'}.#{version}.#{resource}.#{action}"
      options = {routing_key: route, timestamp: Time.now.to_i, persistent: true}

      return true if send(message, options)

      reconnect(1)
      return true if send(message, options)

      reconnect(2)
      return true if send(message, options)

      reconnect(3)
      send(message, options, FoodRunner::Queue::Logger)
    end

    def send(message, options, logger = nil)
      begin
        @exchange.publish(message, options)
        return true
      rescue Exception => e
        logger.log('Queue write failure: ', e) unless logger.nil?
        return false
      end
    end
  end
end
