module BunnyHop
  class Message
    attr_reader :version, :resource, :action, :id, :payload, :time, :client

    def initialize(meta, hash)
      @version = hash[:version]
      @resource = hash[:resource]
      @action = hash[:action]
      @id = hash[:id]
      @time = meta.timestamp
      @client = hash[:client]
      @payload = hash[:payload]
    end

    def handler
      "#{@action}_#{@resource}"
    end
  end
end
