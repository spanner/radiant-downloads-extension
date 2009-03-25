module DownloadTags
  include Radiant::Taggable

  class TagError < StandardError; end
  
  desc %{
    Cycles through all downloads for the specified group.
  
    *Usage:* 
    <pre><code><r:group:downloads:each>...</r:group:downloads:each></code></pre>
  }
  tag 'group:downloads' do |tag|
    raise TagError, "can't have group:downloads without a group" unless tag.locals.group
  end
  tag 'group:downloads:each' do |tag|
    result = []
    tag.locals.group.assets.each do |asset|
      tag.locals.asset = asset
      result << tag.expand
    end 
    result
  end
 
end
