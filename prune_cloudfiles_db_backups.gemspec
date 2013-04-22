# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prune_cloudfiles_db_backups/version'

Gem::Specification.new do |spec|
  spec.name          = 'prune_cloudfiles_db_backups'
  spec.version       = PruneCloudfilesDbBackups::VERSION
  spec.authors       = ['Nelson Chen']
  spec.email         = %w(nelson.chen@receipt.com)
  spec.description   = 'Prunes SmartReceipts DB Backups from Cloudfiles'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/SmartReceipt/prune_cloudfiles_db_backups'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'openstack'
  spec.add_dependency 'slop'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'ruby-progressbar'
end
