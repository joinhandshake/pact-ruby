source 'https://rubygems.org'

if ENV['X_PACT_DEVELOPMENT']
  gem "pact-support", path: '../pact-support'
  gem "pact-mock_service", path: '../pact-mock_service'
  gem "pry-byebug"
end

group :local_development do
  gem "pry-byebug"
end

gem 'hs-pact-support', "~> 1.17.1"
gem "hs-pact-mock_service", "~> 3.9.2"


# Specify your gem's dependencies in pact.gemspec
gemspec