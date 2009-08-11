# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class DownloadsExtension < Radiant::Extension
  version "0.4"
  description "Controlled file access using nginx's local redirects"
  url "http://www.spanner.org/radiant/downloads"
  
  define_routes do |map|
    map.resources :downloads, :only => :show
    map.namespace :admin do |admin|
      admin.resources :downloads
    end
  end
  
  def activate
    Group.send :include, DownloadGroup
    Page.send :include, DownloadTags
    UserActionObserver.instance.send :add_observer!, Download 

    Radiant::AdminUI.send :include, DownloadUI unless defined? admin.download
    admin.download = Radiant::AdminUI.load_default_download_regions

    admin.tabs.add "Downloads", "/admin/downloads", :after => "Layouts", :visibility => [:admin]
  end
  
  def deactivate
    admin.tabs.remove "Downloads"
  end
  
end
