require 'spec_helper'

describe 'writer' do
  describe '#create' do
    let(:writer) { BunnyHop.writer(CONFIG) }

    it "writes a create message" do
      message = read_message 'models.v1.users.create' do
        writer.create(:v1, :users, 9001, {name: 'leto'})
      end
      assert_message(message, 'v1.users.create', 9001, {name: 'leto'})
    end

    it "writes a create message with an explicit prefix" do
      message = read_message 'other.v1.users.create' do
        writer.create(:v1, :users, 9001, {name: 'leto'}, {prefix: 'other'})
      end
      assert_message(message, 'v1.users.create', 9001, {name: 'leto'})
    end
  end
end
