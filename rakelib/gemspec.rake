require 'rake/gempackagetask'
require './lib/rspec/given/version'

if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  PKG_FILES = FileList[
    '[A-Z]*',
    'lib/**/*.rb',
    'test/**/*.rb',
    'examples/**/*',
    'doc/**/*',
  ]
  PKG_FILES.exclude('TAGS')

  SPEC = Gem::Specification.new do |s|

    #### Basic information.

    s.name = 'rspec-given'
    s.version = RSpec::Given::VERSION
    s.summary = "Given/When/Then Specification Extensions for RSpec."
    s.description = <<EOF
Given is an RSpec extension that allows explicit definition of the
pre and post-conditions for code under test.
EOF
    s.files = PKG_FILES.to_a
    s.require_path = 'lib'                         # Use these for libraries.
    s.has_rdoc = true
#    s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
    s.rdoc_options = [
      '--line-numbers', '--inline-source',
      '--main' , 'README.md',
      '--title', 'RSpec Given Extensions'
    ]

    s.add_dependency("rspec", "~> 2.0")
    s.add_development_dependency("bluecloth")

    s.author = "Jim Weirich"
    s.email = "jim.weirich@gmail.com"
    s.homepage = "http://github.com/jimweirich/rspec-given"
    s.rubyforge_project = "given"
  end

  package_task = Rake::GemPackageTask.new(SPEC) do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
  end

  file "rspec-given.gemspec" => ["rakelib/gemspec.rake"] do |t|
    require 'yaml'
    open(t.name, "w") { |f| f.puts SPEC.to_yaml }
  end

  desc "Create a stand-alone gemspec"
  task :gemspec => "rspec-given.gemspec"
end
