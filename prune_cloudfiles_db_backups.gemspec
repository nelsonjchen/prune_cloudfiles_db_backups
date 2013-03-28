# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prune_cloudfiles_db_backups/version'

Gem::Specification.new do |spec|
  spec.name          = "prune_cloudfiles_db_backups"
  spec.version       = PruneCloudfilesDbBackups::VERSION
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

  spec.add_dependency 'openstack', '~> 1.0.9'
  spec.add_dependency "slop", "~> 3.4.4"
  spec.add_dependency "activesupport", "~> 3.2.13"
end
