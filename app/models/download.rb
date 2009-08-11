class Download < ActiveRecord::Base

  is_site_scoped if defined? ActiveRecord::SiteNotFound
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  has_and_belongs_to_many :groups

  has_attached_file :document,
                    :url => "/secure_download/:id/:basename:no_original_style.:extension",
                    :path => ":rails_root/secure_downloads/:id/:basename:no_original_style.:extension"

  validates_attachment_presence :document
  
  def has_group?(group=nil)
    return true if groups and group.nil?
    return false if group.nil?
    return groups.include?(group)
  end
  
  def available_to?(reader=nil)
    permitted_groups = self.groups  
    return true if permitted_groups.empty?
    return false if reader.nil?
    return true if reader.is_admin?
    return reader.in_any_of_these_groups?(permitted_groups)
  end
  
  def document_ok?
    self.document.exists?
  end
    
end
