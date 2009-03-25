namespace :radiant do
  namespace :extensions do
    namespace :downloads do
      
      desc "Runs the migration of the Downloads extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          DownloadsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          DownloadsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Downloads to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from DownloadsExtension"
        Dir[DownloadsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(DownloadsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
