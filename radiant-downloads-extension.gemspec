# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-downloads-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-downloads-extension"
  s.version     = RadiantDownloadsExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantDownloadsExtension::AUTHORS
  s.email       = RadiantDownloadsExtension::EMAIL
  s.homepage    = RadiantDownloadsExtension::URL
  s.summary     = RadiantDownloadsExtension::SUMMARY
  s.description = RadiantDownloadsExtension::DESCRIPTION

  s.add_dependency "paperclip", "~> 2.3.16"

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]

  s.post_install_message = %{
  Add this to your radiant project with a line in your Gemfile:

    gem 'radiant-downloads-extension', '~> #{RadiantDownloadsExtension::VERSION}'

  }

end