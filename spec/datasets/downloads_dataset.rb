class DownloadsDataset < Dataset::Base
  uses :download_sites if defined? Site
  
  def load
    create_download "grouped"
    create_download "alsogrouped"
    create_download "ungrouped"
  end

  helpers do
    def create_download(name, attributes={})
      attributes[:site] ||= sites(:test) if defined? Site
      create_model :download, name.symbolize, download_attributes(attributes.update(:name => name))
    end
    
    def download_attributes(att={})
      name = att[:name] || "A download"
      attributes = { 
        :name => name,
        :description => "Test download"
      }.merge(att)
      attributes[:site_id] ||= site_id(:test) if defined? Site
      attributes[:document] ||= File.new(File.dirname(__FILE__) + "/../files/test.pdf")
      attributes
    end
    
  end
end
