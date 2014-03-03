require 'spec_helper'

describe 'reader' do
  let(:reader) { BunnyHop.reader(CONFIG) }
  let(:writer) { BunnyHop.writer(CONFIG) }
  let(:manager) { BunnyHop.manager(CONFIG) }

  before :each do
    manager.subscribe('test', ['models.v1.users.#'])
  end

  after :each do
    manager.delete('test')
  end

  describe '#run' do
    it "routes a message" do
      controller = Controller.new
      writer.create(:v1, :users, 9552, {name: 'leto'})
      reader.run('test', controller, {count: 1})
      controller.e.should be_nil
      controller.m.id.should == 9552
      controller.m.version.should == 'v1'
      controller.m.action.should == 'create'
      controller.m.resource.should == 'users'
    end

    it "routes a message to error handler" do
      controller = Controller.new
      writer.update(:v1, :users, 9552, {name: 'leto'})
      reader.run('test', controller, {count: 1})
      controller.e.to_s.should include 'undefined method `update_users\''
    end
  end
end


class Controller
  attr_reader :m, :e
  def create_users(m)
    @m = m
    true
  end

  def error(e)
    @e = e
    true
  end
end
