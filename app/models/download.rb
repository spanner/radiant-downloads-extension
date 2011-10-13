class Download < ActiveRecord::Base
  
  has_groups
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  default_scope :order => 'updated_at DESC, created_at DESC'

  has_attached_file :document,
                    :url => "/secure_downloads/:id/:basename:no_original_style.:extension",
                    :path => ":rails_root/secure_downloads/:id/:basename:no_original_style.:extension"

  validates_attachment_presence :document

  def document_ok?
    self.document.exists?
  end
    
end
