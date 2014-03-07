require 'oj'
require_relative 'bunnyhop/version'
require_relative 'bunnyhop/logger'
require_relative 'bunnyhop/base'
require_relative 'bunnyhop/writer'
require_relative 'bunnyhop/manager'
require_relative 'bunnyhop/reader'
require_relative 'bunnyhop/message'
require_relative 'bunnyhop/tracker'

module BunnyHop
  class << self
    def writer(config)
      BunnyHop::Writer.new(config)
    end

    def manager(config)
      BunnyHop::Manager.new(config)
    end

    def reader(config)
      BunnyHop::Reader.new(config)
    end
  end
end
