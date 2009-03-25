class DownloadSitesDataset < Dataset::Base
  uses :pages
  
  def load
    create_record Site, :test, :name => 'Test Site', :domain => 'test', :base_domain => 'test.host', :position => 1, :mail_from_name => 'test sender', :mail_from_address => 'sender@spanner.org', :homepage_id => page_id(:home)
    Page.current_site = sites(:test)
  end
 
end