require 'active_support'

module BunnyHop
  module Tracker
    extend ActiveSupport::Concern

    included do
      after_create :track_after_create
      after_update :track_after_update
      after_destroy :track_after_destroy
      class_attribute :tracker_version, :tracker_resource, :tracker_writer, :tracker_block
    end

    def track_after_create
      track_action(:create)
    end

    def track_after_update
      if self.deleted_at?
        track_action(:delete)
      else
        track_action(:update)
      end
    end

    def track_after_destroy
      track_action(:delete)
    end

    def track_action(action, payload = nil)
      raise 'Unconfigured tracker' unless self.class.tracker_writer
      unless self.class.tracker_block.nil?
        payload = self.class.tracker_block.call(self)
      end
      self.class.tracker_writer.send(action, self.class.tracker_version, self.class.tracker_resource, self.id, payload)
    end

    module ClassMethods
      def tracker(version, resource, writer, &block)
        self.tracker_version = version
        self.tracker_resource = resource
        self.tracker_writer = writer
        self.tracker_block = block
      end
    end
  end
end
