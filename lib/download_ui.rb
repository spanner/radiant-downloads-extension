module DownloadUI

 def self.included(base)
   base.class_eval do

      attr_accessor :download
      alias_method :downloads, :download

      def load_default_regions_with_download
        load_default_regions_without_download
        load_download_extension_regions
      end
      alias_method_chain :load_default_regions, :download
      
      def load_download_extension_regions
        @download = load_default_download_regions
      end

      protected

        def load_default_download_regions
          returning OpenStruct.new do |download|
            download.edit = Radiant::AdminUI::RegionSet.new do |edit|
              edit.main.concat %w{edit_header edit_form}
              edit.form.concat %w{edit_title edit_description edit_document edit_access}
              edit.form_bottom.concat %w{edit_timestamp edit_buttons}
            end
            download.index = Radiant::AdminUI::RegionSet.new do |index|
              index.thead.concat %w{name_header document_header access_header modify_header}
              index.tbody.concat %w{name_cell document_cell access_cell modify_cell}
              index.bottom.concat %w{new_button}
            end
            download.remove = download.index
            download.new = download.edit
          end
        end
      
    end
  end
end

