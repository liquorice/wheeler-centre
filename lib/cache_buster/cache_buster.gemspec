Gem::Specification.new do |s|
  s.name        = 'cache_buster'
  s.version     = '0.0.2'
  s.date        = '2014-02-05'
  s.summary     = 'Wheeler Centre Cache Buster'
  s.description = 'Reactive Cache Buster'
  s.authors     = ['Alex Timofeev']
  s.email       = 'alex.timofeev@icelab.com.au'
  s.files       = ['lib/cache_buster.rb']
  s.license       = 'MIT'

  s.add_runtime_dependency 'sinatra', '~> 1.4'
  s.add_runtime_dependency 'redis', '~> 3.2'
  s.add_runtime_dependency 'resque'
  s.add_runtime_dependency 'ohm', '~> 2.1'
  s.add_runtime_dependency 'varnisher', '~> 1.1'
  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_runtime_dependency 'dotenv', '~> 1.0'
end
