module DownloadGroup
  def self.included(base)
    base.class_eval {
      has_and_belongs_to_many :downloads
    }
  end
end
