module BunnyHop
  module Tracker
    extend ActiveSupport::Concern

    included do
      after_save :track_after_create
      after_update :track_after_update
      after_destroy :track_after_destroy
      class_attribute :tracker_version, :tracker_resource, :tracker_writer
    end

    def track_after_create
      track_action(:create)
    end

    def track_after_update
      track_action(:update)
    end

    def track_after_destroy
      track_action(:delete)
    end

    def track_action(action)
      raise 'Unconfigured tracker' unless self.class.tracker_writer
      self.class.tracker_writer.send(action, self.class.tracker_version, self.class.tracker_resource, self.id, nil)
    end

    module ClassMethods
      def tracker(version, resource, writer)
        self.tracker_version = version
        self.tracker_resource = resource
        self.tracker_writer = writer
      end
    end
  end
end
