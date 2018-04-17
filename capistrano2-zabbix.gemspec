lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/zabbix/version'

Gem::Specification.new do |spec|
  spec.name     = 'capistrano-zabbix'
  spec.version  = Capistrano::Zabbix::VERSION
  spec.authors  = ['Alexander Janssen']
  spec.email    = ['a.janssen@tnajanssen.nl']

  spec.summary  =
      'Automatically put Zabbix into maintenance mode'
  spec.homepage = 'https://github.com/TNAjanssen/capistrano-zabbix'

  spec.files = `git ls-files -z`
                   .split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano'   , '~> 3.7'
  spec.add_dependency 'zabbixapi'    , '~> 3.2'
  spec.add_dependency 'activesupport', '~> 5.1'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake'   , '~> 10.0'
end
