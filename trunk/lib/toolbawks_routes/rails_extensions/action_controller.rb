require 'action_controller'

module Toolbawks::RailsExtensions::ToolbawksRoutes::ActionController #:nodoc:
  # Actions that fail to perform as expected throw exceptions. These exceptions can either be rescued for the public view 
  # (with a nice user-friendly explanation) or for the developers view (with tons of debugging information). The developers view
  # is already implemented by the Action Controller, but the public view should be tailored to your specific application. So too
  # could the decision on whether something is a public or a developer request.
  #
  # You can tailor the rescuing behavior and appearance by overwriting the following two stub methods.
  def self.included(base) #:nodoc:
    base.extend(ClassMethods)

    base.class_eval do
      [:perform_action, :rescue_action, :rescues_path].each do |m|
        alias_method_chain m, :toolbawks
      end
    end
  end
  
  module ClassMethods #:nodoc:
  end

protected

private

  def perform_action_with_toolbawks
    ToolbawksRoutes.perform_action(request)
    
    uri_params = request.parameters.dup
    uri_params.delete(:status)
    @uri = url_for(uri_params)
    
    @template.instance_variable_set("@uri", @uri)
    
    perform_action_without_toolbawks
    
    @template.send(:assign_variables_from_controller)    
  end

  def rescue_action_with_toolbawks(exception) #:nodoc:
    log_error(exception) if logger
    erase_results if performed?

    add_variables_to_assigns
    
    @template.instance_variable_set("@exception", exception)
    @template.instance_variable_set("@rescues_path", File.dirname(rescues_path("stub")))    
    @template.send(:assign_variables_from_controller)

    @template.instance_variable_set("@contents", @template.render_file(template_path_for_local_rescue(exception), false))

    response.content_type = Mime::HTML    
    
    if local_request?
      render :file => rescues_path("layout"), :status => response_code_for_rescue(exception)
    else
      logger.info 'exception : ' + exception.inspect
=begin
      case exception
        when RoutingError, UnknownAction
          render_file(rescues_path("404"), "404 Not Found")
        else
          render_file(rescues_path("500"), "500 Internal Error")
      end
=end
    end

    ToolbawksRoutes.perform_rescue_action(request)
  end

  def rescues_path_with_toolbawks(template_name)
    RAILS_ROOT + "/vendor/plugins/toolbawks_routes/app/views/toolbawks/routes/rescues/#{template_name}.rhtml"
  end
end