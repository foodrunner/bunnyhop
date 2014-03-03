require 'spec_helper'

describe 'manager' do
  let(:manager) { BunnyHop.manager(CONFIG) }

  describe '#new' do
    it 'raises error on missing application' do
      expect { BunnyHop.manager({}) }.to raise_error 'application is required when creating a BunnyHop::Manager'
    end

    it 'raises error on missing exchange' do
      expect { BunnyHop.manager({application: 'test'}) }.to raise_error 'exchange is required when creating a BunnyHop::Manager'
    end
  end

  describe '#close' do
    it 'closes the connection' do
      manager.close()
      manager.connection.status.should == :closed
    end
  end

  describe '#reconnct' do
    it 'reconnects' do
      manager.close()
      manager.reconnect()
      manager.connection.status.should == :open
    end
  end
end
