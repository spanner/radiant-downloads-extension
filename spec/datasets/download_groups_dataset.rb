require 'digest/sha1'
class DownloadGroupsDataset < Dataset::Base
  datasets = [:downloads, :download_readers]
  datasets << :download_sites if defined? Site
  uses *datasets

  def load
    create_group "Normal"
    create_group "Busy"
    create_group "Idle"
    add_downloads_to_group :normal, [:grouped]
    add_downloads_to_group :busy, [:grouped, :alsogrouped]
    add_readers_to_group :busy, [:normal, :another]
  end
  
  helpers do
    def create_group(name, att={})
      group = create_record Group, name.symbolize, group_attributes(att.update(:name => name))
    end
    
    def group_attributes(att={})
      name = att[:name] || "A group"
      attributes = { 
        :name => name,
        :description => "Test group"
      }.merge(att)
      attributes[:site_id] ||= site_id(:test) if defined? Site
      attributes
    end
  end
    
  def add_readers_to_group(g, rr)
    g = g.is_a?(Group) ? g : groups(g)
    g.readers <<  rr.map{|r| readers(r)}
  end
  
  def add_downloads_to_group(g, dd)
    g = g.is_a?(Group) ? g : groups(g)
    g.downloads <<  dd.map{|d| downloads(d)}
  end
  
end