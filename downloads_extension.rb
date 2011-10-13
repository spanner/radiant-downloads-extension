# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'
require 'paperclip'

class DownloadsExtension < Radiant::Extension
  version RadiantDownloadsExtension::VERSION
  description RadiantDownloadsExtension::DESCRIPTION
  url RadiantDownloadsExtension::URL
    
  def activate
    Page.send :include, DownloadTags
    UserActionObserver.instance.send :add_observer!, Download 

    unless defined? admin.downloads
      Radiant::AdminUI.send :include, DownloadUI
      Radiant::AdminUI.load_download_extension_regions
    end

    tab("Readers") do
      add_item("Downloads", "/admin/readers/downloads", :before => 'Settings')
    end
  end  
  
end
