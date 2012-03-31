# -*- encoding: utf-8 -*-
require File.expand_path('../lib/platem/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Felipe Coury"]
  gem.email         = ["felipe.coury@gmail.com"]
  gem.description   = %q{ERB templates}
  gem.summary       = %q{Manages creation of files from ERB templates}
  gem.homepage      = "http://webbynode.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "platem"
  gem.require_paths = ["lib"]
  gem.version       = Platem::VERSION
end
