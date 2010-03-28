class Toolbawks::RoutesController < Toolbawks::BaseController
  before_filter :login_required, :except => [:unknown_route]
	before_filter :check_authorization, :except => [:unknown_route]

  def index
    redirect_to :action => 'manager'
  end
  
  def manager
  end
  
  def unknown_route
    if params[:unknown] && /\.(css|js|gif|jpg|png)/.match(params[:unknown].to_s)
      toolbawks_routes_render_missing_asset
    else
      toolbawks_routes_render_unknown_route
    end
  end
  
private
  def toolbawks_routes_render_unknown_route
    render :action => 'unknown_route', :status => 404 and return
  end
  
  def toolbawks_routes_render_missing_asset
    render :text => 'File not found', :status => 404 and return
  end
end