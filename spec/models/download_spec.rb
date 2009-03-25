require File.dirname(__FILE__) + '/../spec_helper'

describe Download do
  dataset :download_groups
  
  before do
    @site = Page.current_site = sites(:test) if defined? Site
  end
  
  it "should have a groups association" do
    Download.reflect_on_association(:groups).should_not be_nil
    download = downloads(:grouped)
    download.groups.any?.should be_true
    download.groups.size.should == 2
  end

  it "should have a document attachment" do
    ["document", "document=", "document?"].each do |meth|
      Download.instance_methods.should include(meth)
    end
  end
  
  it "should validate file presence" do
    dl = downloads(:ungrouped)
    dl.should be_valid
    dl.document = nil
    dl.should_not be_valid
    dl.errors.on(:document).should_not be_nil
  end

  it "url should point to /secure_download " do
    dl = downloads(:grouped)
    dl.document.url.should =~ /^\/secure_download\/#{dl.id}/
  end

  it "path should be outside public site" do
    dl = downloads(:grouped)
    dl.document.path.should_not =~ /^#{RAILS_ROOT}\/public/
  end

end
