# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prune_cf_db_backups/version'

Gem::Specification.new do |spec|
  spec.name          = "prune_cf_db_backups"
  spec.version       = PruneCfDbBackups::VERSION
  spec.authors       = ["Nelson Chen"]
  spec.email         = ["crazysim@gmail.com"]
  spec.description   = "Prunes SmartReceipts DB Backups"
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "All Rights Reserved"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "cloudfiles", "~> 1.5.0.1"
end
