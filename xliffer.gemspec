$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'xliffer/version'

Gem::Specification.new do |s|
  s.name        = 'xliffer'
  s.version     = XLIFFer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses = ['MIT']
  s.date        = '2012-01-01'
  s.summary     = 'A XLIFF parser'
  s.description = 'A parser for XLIFF files'
  s.authors     = ['Felipe Tanus']
  s.email       = 'fotanus@gmail.com'
  s.homepage    = 'http://github.com/fotanus/xliff'

  s.add_dependency 'oga', '~> 3.4'

  s.add_development_dependency 'rspec', '~> 2'
  s.add_development_dependency 'simplecov', '~> 0.10'

  s.rubyforge_project = 'xliffer'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ['lib']
end
