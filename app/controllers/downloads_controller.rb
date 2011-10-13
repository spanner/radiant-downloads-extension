class DownloadsController < ReaderActionController
  
  before_filter :require_reader, :only => [:show]
  
  def show
    @download = Download.find(params[:id])
    raise ReaderError::AccessDenied, t("downloads_extension.permission_denied") unless @download.visible_to?(current_reader)
    response.headers['X-Accel-Redirect'] = @download.document.url
    response.headers["Content-Type"] = @download.document_content_type
    response.headers['Content-Disposition'] = "attachment; filename=#{@download.document_file_name}" 
    response.headers['Content-Length'] = @download.document_file_size
    render :nothing => true
  end
  
end


