require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  dataset :download_groups
  
  before do
    @site = Page.current_site = sites(:test) if defined? Site
  end
  
  it "should have a downloads association" do
    Group.reflect_on_association(:downloads).should_not be_nil
  end

  it "should have a group of downloads" do
    group = groups(:busy)
    group.downloads.any?.should be_true
    group.downloads.size.should == 2
  end

end
