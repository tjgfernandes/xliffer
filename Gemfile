source 'http://rubygems.org'

gem 'oga', '~> 3.4'
gem 'equivalent-xml'

group :test do
  unless RUBY_VERSION.match(/\A1\.8/)
    gem 'codeclimate-test-reporter', :require => false
  end
end

group :development do
  gem 'rspec', '~> 3'
  gem 'simplecov', '>= 0.9.0'
end
