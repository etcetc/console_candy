# -*- encoding: utf-8 -*-
require File.expand_path('../lib/console_candy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Farhad Farzaneh"]
  gem.email         = ["ff@onebeat.com"]
  gem.description   = %q{This patches some rails classes to provide syntactic sugar for playing in the console}
  gem.summary       = %q{ActiveRecord is patched so that you can use syntax like User[14] to retrieve user with id 14.  It also adds a "show" method to retrieved activerecord objects so you can print out certain attributes of the returned array, for example, User.active.show(:id,:name).  Finally, it adds a 'pp' method to print out the ActiveRecord object in a "nicer" way.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "console_candy"
  gem.require_paths = ["lib"]
  gem.version       = ConsoleCandy::VERSION
end
