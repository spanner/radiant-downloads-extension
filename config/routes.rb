ActionController::Routing::Routes.draw do |map|
  map.resources :downloads, :only => :show
  map.namespace :admin, :path_prefix => 'admin/readers' do |admin|
    admin.resources :downloads
  end
end
