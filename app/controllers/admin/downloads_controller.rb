class Admin::DownloadsController < Admin::ResourceController
  
  def create                                      
    model.update_attributes!(params[model_symbol])
    announce_saved
    response_for :create
  end