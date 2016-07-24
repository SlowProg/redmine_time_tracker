# use require_dependency if you plan to utilize development mode
require 'application_helper'

module TimeTrackers
  module Patches
    module ApplicationHelperPatch
      def self.included(base) # :nodoc:
        # sending instance methods to module
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          # aliasing methods if needed
          # alias_method_chain :render_page_hierarchy, :watchers
        end
      end

      # Instance methods are here
      module InstanceMethods

        def time_tracker_for(user)
          TimeTracker.where(:user_id => user.id).first
        end

        def status_from_id(status_id)
          IssueStatus.where(:id => status_id).first
        end

        def statuses_list()
          IssueStatus.all
        end

        def to_status_options(statuses)
          options_from_collection_for_select(statuses, 'id', 'name')
        end

        def new_transition_from_options(transitions)
          statuses = []

          for status in statuses_list()
            if !transitions.has_key?(status.id.to_s)
              statuses << status
            end
          end

          to_status_options(statuses)
        end

        def new_transition_to_options()
          to_status_options(statuses_list())
        end

        def global_allowed_to?(user, action)
          return false if user.nil?

          projects = Project.all

          for p in projects
            if user.allowed_to?(action, p)
              return true
            end
          end

          return false
        end

      end
    end
  end
end

module SettingsControllerPatch
  def self.included(base)
    base.class_eval do
      helper TimeTrackersHelper
    end
  end
end

# now we should include this module in ApplicationHelper module
unless ApplicationHelper.included_modules.include? TimeTrackers::Patches::ApplicationHelperPatch
  ApplicationHelper.send(:include, TimeTrackers::Patches::ApplicationHelperPatch)
end

unless SettingsController.included_modules.include? SettingsControllerPatch
  SettingsController.send(:include, SettingsControllerPatch)
end
