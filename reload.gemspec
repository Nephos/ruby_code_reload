require_relative "lib/reloader-version"

Gem::Specification.new do |s|
  s.name        = 'reloader'
  s.version     = Reloader::VERSION
  s.date        = Time.now.getgm.to_s.split.first
  s.summary     = "See Changelog"
  s.description = "reload the files when code changed"
  s.authors     = [
            	  "poulet_a"
		  ]
  s.email       = "poulet_a@epitech.eu",
  s.files       = [
               	  "lib/reloader.rb",
               	  "lib/reloader-version.rb",
		  "README.md",
		  "Rakefile",
		  "reloader.gemspec",
		  "test/test.rb",
		  ]
  s.homepage    = "https://gitlab.com/poulet_a/rubyhelper"
  s.license     = "GNU/GPLv3"
  s.cert_chain  = ['certs/poulet_a.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/
end
