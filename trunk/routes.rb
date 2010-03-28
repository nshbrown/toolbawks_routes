# Add all routes for all plugins related to the Toolbawks Store and dependencies

module ActionController
  module Routing #:nodoc:
    class RouteSet #:nodoc:
      alias_method :draw_without_toolbawks_store_routes, :draw
      
      def draw
        draw_without_toolbawks_store_routes do |map|
          # 404 Handler
            map.connect '*unknown', :controller => 'toolbawks/routes', :action => 'unknown_route', :status => 500
          yield map
        end
      end
    end
  end
end