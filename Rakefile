require 'rubygems'
require 'rubygems/package_task'
require 'rake/clean'
CLEAN.include("pkg/*.gem")


ATTO_VERSION = "0.9.1"

def apply_spec_defaults(s)
end

spec = Gem::Specification.new do |s|
    s.name          = "atto"
    s.summary       = "An ultra-tiny self-contained testing framework."
    s.description   = s.summary + " "
    s.version       = ATTO_VERSION
    s.author        = "Beoran"
    s.email         = 'beoran@rubyforge.org'
    s.date          = Time.now.strftime '%Y-%m-%d'
    s.require_path  = 'lib'
    s.homepage      = "https://github.com/beoran/atto"
    # s.platform    = Gem::Platform::CURRENT
    s.files         = ["Rakefile"   , "README" ] +
                       FileList["lib/atto.rb", "lib/atto/*.rb",
                       "test/*.rb"  , "test/atto/*.rb" ].to_a
    s.bindir        = "bin"
    s.executables   = "atto"
end

Gem::PackageTask.new(spec) do |pkg|
        pkg.need_zip = false
        pkg.need_tar = false
end


task :test do
  for file in FileList["test/*.rb"  , "test/atto/*.rb" ] do
    puts("Running tests for #{file}:")
    res = system("ruby -I lib #{file}")
    puts res ? "OK!" : "Failed!"
  end
end

task :default => :test

