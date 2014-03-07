require 'spec_helper'

describe 'writer' do
  describe '#delete' do
    let(:writer) { BunnyHop.writer(CONFIG) }

    it "writes a delete message" do
      message = read_message 'models.v2.users.delete' do
        writer.delete(:v2, :users, 32, nil)
      end
      assert_message(message, 'v2.users.delete', 32, nil)
    end

    it "writes a delete message with an explicit prefix" do
      message = read_message 'x.v1.items.delete' do
        writer.delete(:v1, :items, 44, nil, {prefix: 'x'})
      end
      assert_message(message, 'v1.items.delete', 44, nil)
    end
  end
end
