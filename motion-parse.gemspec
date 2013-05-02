# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion-parse/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "motion-parse"
  s.version     = MotionParse::VERSION
  s.authors     = ["Thomas Kadauke"]
  s.email       = ["thomas.kadauke@googlemail.com"]
  s.homepage    = "https://github.com/tkadauke/motion-parse"
  s.summary     = "Access Parse.com data from your iOS app"
  s.description = "Access Parse.com data from your iOS app"

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'motion-support', ">= 0.2.0"
  s.add_development_dependency 'rake'
end
