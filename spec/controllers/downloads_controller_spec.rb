require File.dirname(__FILE__) + '/../spec_helper'

describe DownloadsController do
  dataset :download_groups
  
  before do
    controller.stub!(:request).and_return(request)
    Page.current_site = sites(:test) if defined? Site
    request.env["HTTP_REFERER"] = 'http://test.host/referer!'
  end
  
  describe "with a protected download" do
    describe "and no reader" do
      before do
        logout_reader
        get :show, :id => download_id(:grouped)
      end
    
      it "should redirect to login" do
        response.should be_redirect
        response.should redirect_to(reader_login_url)
      end
    
      it "should set the right return_to url" do
        session[:return_to].should == request.request_uri
      end
    end

    describe "and a logged-in reader" do
      describe "who is not in a permitted group" do
        before do
          login_as_reader(:ungrouped)
          get :show, :id => download_id(:grouped)
        end
    
        it "should redirect to the permission denied page" do
          response.should be_success
          response.should render_template('site/not_allowed')
        end
      end

      describe "who is in a permitted group" do
        before do
          login_as_reader(:normal)
          get :show, :id => download_id(:grouped)
        end
    
        it "should return an internal redirect" do
          dl = downloads(:grouped)
          response.should be_success
          response.headers.should include('X-Accel-Redirect');
          response.headers['X-Accel-Redirect'].should == dl.document.path
          response.headers['Content-Disposition'].should =~ /^attachment/
        end
      end
    end
  end
  
  describe "with an ungrouped download" do
    describe "and no reader" do
      before do
        logout_reader
        get :show, :id => download_id(:grouped)
      end

      it "should refuse access" do
        response.should be_redirect
        response.should redirect_to(reader_login_url)
      end
    end
  end
  
end
