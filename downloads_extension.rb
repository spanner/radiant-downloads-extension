# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'
require 'paperclip'

class DownloadsExtension < Radiant::Extension
  version "0.5.1"
  description "Controlled file access using nginx's local redirects. Requires reader and reader_group extensions."
  url "http://www.spanner.org/radiant/downloads"
    
  def activate
    Group.send :include, DownloadGroup
    Page.send :include, DownloadTags
    UserActionObserver.instance.send :add_observer!, Download 

    if respond_to?(:tab)
      tab("Content") do
        add_item("Downloads", "/admin/readers/downloads")
      end
    else
      admin.tabs.add "Downloads", "/admin/readers/downloads", :visibility => [:all]
    end
  end  
  
  def deactivate
  end
  
end
