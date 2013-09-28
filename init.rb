# encoding: utf-8

require 'redmine'

require_dependency 'time_tracker_hooks'


Redmine::Plugin.register :redmine_time_tracker do
    name 'Redmine Time Tracker plugin'
    author 'Clemens Rabe, forked from Moritz Hamann, originally Jérémie Delaitre'
    description 'This is a plugin to track time in Redmine'
    version '0.5'

    requires_redmine :version_or_higher => '2.1.0'

    settings :default => { 'refresh_rate' => '60', 'redirect_to_issue' => 'true', 'status_transitions' => { '5' => '2', '1' => '2', '3' => '2' } }, :partial => 'settings/time_tracker'

    permission :view_others_time_trackers, :time_trackers => :index
    permission :delete_others_time_trackers, :time_trackers => :delete

    menu :account_menu, :time_tracker_menu, '',
        {
            :caption => '',
            :html => { :id => 'time-tracker-menu' },
            :first => true,
            :param => :project_id,
            :if => Proc.new { User.current.logged? }
        }
    
    
    require 'dispatcher' unless Rails::VERSION::MAJOR >= 3
    
    if Rails::VERSION::MAJOR >= 3
      ActionDispatch::Callbacks.to_prepare do
        # use require_dependency if you plan to utilize development mode
        require 'time_trackers_patches'
      end
    else
      Dispatcher.to_prepare BW_AssetHelpers::PLUGIN_NAME do
        # use require_dependency if you plan to utilize development mode
        require 'time_trackers_patches'
      end
    end        
    
end
