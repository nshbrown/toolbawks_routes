# Copyright (c) 2007 Nathaniel Brown
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module ToolbawksRoutes
  mattr_accessor :_info_email
  self._info_email = nil
  
  mattr_accessor :email_broken_routes
  self.email_broken_routes = { :unknown => false, :rescue => false }
  
  mattr_accessor :log_broken_routes
  self.log_broken_routes = { :unknown => false, :rescue => false }
  
  def self.info_email
    return self._info_email if !self._info_email.nil?
    'info@' + (Toolbawks.default_host ? Toolbawks.default_host : '')
  end
  
  def self.info_email=(email)
    self._info_email = email
  end
  
  def self.filter(string)
    string.gsub(/[^\s_a-zA-Z0-9]/, '').gsub(/\s+/, '_').downcase
  end
  
  # Run this on every action, we can add whatever we want here
  def self.perform_action(controller)
    begin
      if ToolbawksStats && ToolbawksStats.enabled
        # TODO: Implement statistics with reporting and logging functionality
      end
    rescue
      # ToolbawksStats not present
    end
    
    if ToolbawksRoutes.is_unknown_route?(controller)
      ToolbawksRoutes.perform_unknown_route(controller)
    end
  end

  def self.perform_unknown_route(controller)
    ToolbawksRoutes.record_action('unknown', controller)
  end

  def self.perform_rescue_action(controller)
    ToolbawksRoutes.record_action('rescue', controller)
  end
  
  def self.record_action(type, controller)
    if ToolbawksRoutes.email_broken_routes.include?(type)
      case type
        when 'unknown'
        when 'rescue'
          #TODO: Send an email to the administrator about the error. Provide a full log.
      end
    end
    if ToolbawksRoutes.log_broken_routes.include?(type)
      case type
        when 'unknown'
        when 'rescue'
      end
      
      #TODO: Send an email to the administrator about the error. Provide a full log.
      logger.info 'ToolbawksRoutes.record_action -> log_broken_routes -> ' + controller.inspect
    end
  end
  
  def self.is_unknown_route?(controller)
    return controller.parameters[:controller] == 'toolbawks/routes' && controller.parameters[:action] == 'unknown_route'
  end
end

# Include all our core rails extensions
require 'toolbawks_routes/rails_extensions'