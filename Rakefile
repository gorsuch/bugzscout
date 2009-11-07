require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "bugzscout"
  s.version   =   "0.0.5"
  s.author    =   "Michael Gorsuch"
  s.email     =   "michael@styledbits.com"
  s.summary   =   "A package for using Fog Creek Software's FogBugz BugzScout bug reporting system."
  s.homepage  =   "http://github.com/mgorsuch/bugzscout"
  s.files     =   FileList['lib/*.rb', 'test/*'].to_a
  s.require_path  =   "lib"
  s.test_files = Dir.glob('tests/*.rb')
  s.has_rdoc  =   true
  s.add_dependency('httpclient')
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end
