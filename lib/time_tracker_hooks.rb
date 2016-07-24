# This class hooks into Redmine's View Listeners in order to add content to the page
class TimeTrackerHooks < Redmine::Hook::ViewListener

    #render_on :view_layouts_base_body_bottom, :partial => 'time_trackers/update_menu'
    #render_on :view_issues_context_menu_start, :partial => 'time_trackers/update_context'

    def view_layouts_base_html_head(context = {})
        css = stylesheet_link_tag 'time_tracker.css', :plugin => 'redmine_time_tracker'
    end

    def view_layouts_base_body_bottom(context = {})
        time_tracker = TimeTracker.where(:user_id => User.current.id).first
        context[:controller].send(:render_to_string,
            { :partial => "/time_trackers/update_menu" })
    end

    def view_issues_context_menu_start(context = {})
        time_tracker = TimeTracker.where({:user_id => User.current.id}).first
        context[:controller].send(:render_to_string,
            { :partial => "/time_trackers/update_context",
            :locals => { :time_tracker => time_tracker }})
    end
end
