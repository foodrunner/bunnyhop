require 'spec_helper'

describe 'writer' do
  describe '#update' do
    let(:writer) { BunnyHop.writer(CONFIG) }

    it "writes a update message" do
      message = read_message 'models.v5.items.update' do
        writer.update(:v5, :items, 33, {name: 'food'})
      end
      assert_message(message, 'v5.items.update', 33, {name: 'food'})
    end

    it "writes a update message with an explicit prefix" do
      message = read_message 'other.v1.users.update' do
        writer.update(:v1, :users, 9001, {name: 'leto'}, {prefix: 'other'})
      end
      assert_message(message, 'v1.users.update', 9001, {name: 'leto'})
    end
  end
end
