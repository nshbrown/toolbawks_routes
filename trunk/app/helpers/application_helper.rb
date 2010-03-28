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

module ApplicationHelper
  mattr_accessor :toolbawks_routes_manager_count
  self.toolbawks_routes_manager_count = 0
  
  def toolbawks_routes_head
    <<-EOL
    #{ stylesheet_link_tag 'Routes', :plugin => 'toolbawks_routes' }
    #{ javascript_include_tag 'Routes', 'Filter', :plugin => 'toolbawks_routes' }
EOL
  end
  
  def toolbawks_routes_manager
    ApplicationHelper.toolbawks_routes_manager_count += 1
    <<-EOL
    <div id="toolbawks_routes_manager_#{ApplicationHelper.toolbawks_routes_manager_count}" class="toolbawks_routes_manager"></div>
EOL
  end
end