# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class DownloadsExtension < Radiant::Extension
  version "0.5"
  description "Controlled file access using nginx's local redirects. Requires reader and reader_group extensions."
  url "http://www.spanner.org/radiant/downloads"
  
  define_routes do |map|
    map.resources :downloads, :only => :show
    map.namespace :admin, :path_prefix => 'admin/readers' do |admin|
      admin.resources :downloads
    end
  end
  
  extension_config do |config|
    config.gem 'paperclip'
    config.extension 'reader'
    config.extension 'reader_group'
  end
  
  def activate
    Group.send :include, DownloadGroup
    Page.send :include, DownloadTags
    UserActionObserver.instance.send :add_observer!, Download 

    unless defined? admin.download
      Radiant::AdminUI.send :include, DownloadUI
      admin.download = Radiant::AdminUI.load_default_download_regions
    end

    admin.tabs['Readers'].add_link('downloads', '/admin/readers/downloads')
  end
  
  def deactivate
  end
  
end
