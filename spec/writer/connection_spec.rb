require 'spec_helper'

describe 'writer' do
  let(:writer) { BunnyHop.writer(CONFIG) }

  describe '#new' do
    it 'raises error on missing application' do
      expect { BunnyHop.writer({}) }.to raise_error 'application is required when creating a BunnyHop::Writer'
    end

    it 'raises error on missing exchange' do
      expect { BunnyHop.writer({application: 'test'}) }.to raise_error 'exchange is required when creating a BunnyHop::Writer'
    end
  end

  describe '#close' do
    it 'closes the connection' do
      writer.close()
      writer.connection.status.should == :closed
    end
  end

  describe '#reconnct' do
    it 'reconnects' do
      writer.close()
      writer.reconnect()
      writer.connection.status.should == :open
      writer.delete(:v1, :user, 33).should == true
    end
  end
end
