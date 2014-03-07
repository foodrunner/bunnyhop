require 'yaml'
require 'amqp'
require 'eventmachine'

Dir[File.join(File.dirname(__FILE__), '..', 'lib/*.rb')].each {|file| require file }

CONFIG = {
  host: '127.0.0.1',
  port: 5672,
  username: 'test',
  password: 'test',
  application: 'bunnyhop-test',
  exchange: 'bunnyhop-test'
}

begin
  config = YAML.load_file('spec/config.yml').inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  CONFIG.merge!(config)
rescue
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.mock_with :rspec
end

def read_message(route)
  EventMachine.run do
    connection = AMQP.connect({
      host: CONFIG[:host],
      port: CONFIG[:port],
      username: CONFIG[:username],
      password: CONFIG[:password]
    })
    queue = AMQP::Channel.new(connection).queue("", exclusive: true)
    queue.bind(CONFIG[:exchange], routing_key: route) do
      yield
    end
    queue.subscribe do |m|
      message = Oj.load(m, symbol_keys: true)
      connection.close { EventMachine.stop }
      return message
    end
  end
end

def assert_message(actual, expected_route, expected_id, expected_payload)
  parts = expected_route.split('.')
  actual[:version].should == parts[0]
  actual[:resource].should == parts[1]
  actual[:action].should == parts[2]
  actual[:id].should == expected_id
  actual[:client].should == CONFIG[:application]
  actual[:payload].should == expected_payload
end
