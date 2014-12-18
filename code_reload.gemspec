require_relative "lib/code_reload-version"

Gem::Specification.new do |s|
  s.name        = 'code_reload'
  s.version     = CodeReloader::VERSION
  s.date        = Time.now.getgm.to_s.split.first
  s.summary     = "See Changelog"
  s.description = "code_reload the files when code changed"
  s.authors     = [
            	  "poulet_a"
		  ]
  s.email       = "poulet_a@epitech.eu",
  s.files       = [
               	  "lib/code_reload-version.rb",
               	  "lib/code_reload.rb",
		  "README.md",
		  "Rakefile",
		  "reloader.gemspec",
		  "test/test.rb",
		  ]
  s.homepage    = "https://gitlab.com/poulet_a/ruby_code_reload"
  s.license     = "GNU/GPLv3"
  s.cert_chain  = ['certs/poulet_a.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/
end
