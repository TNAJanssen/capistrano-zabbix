# -*- encoding: utf-8 -*-
# stub: capistrano-zabbix 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-zabbix".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alexander Janssen".freeze]
  s.date = "2018-04-17"
  s.email = ["a.janssen@tnajanssen.nl".freeze]
  s.files = [".gitignore".freeze, "Gemfile".freeze, "Gemfile.lock".freeze, "LICENSE".freeze, "README.md".freeze, "VERSION".freeze, "capistrano2-zabbix.gemspec".freeze, "lib/capistrano-zabbix.rb".freeze, "lib/capistrano/tasks/zabbix.rake".freeze, "lib/capistrano/zabbix.rb".freeze, "lib/capistrano/zabbix/version.rb".freeze]
  s.homepage = "https://github.com/TNAjanssen/capistrano-zabbix".freeze
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Automatically put Zabbix into maintenance mode".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>.freeze, ["~> 3.7"])
      s.add_runtime_dependency(%q<zabbixapi>.freeze, ["~> 3.2"])
      s.add_runtime_dependency(%q<activesupport>.freeze, ["~> 5.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.12"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    else
      s.add_dependency(%q<capistrano>.freeze, ["~> 3.7"])
      s.add_dependency(%q<zabbixapi>.freeze, ["~> 3.2"])
      s.add_dependency(%q<activesupport>.freeze, ["~> 5.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.12"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<capistrano>.freeze, ["~> 3.7"])
    s.add_dependency(%q<zabbixapi>.freeze, ["~> 3.2"])
    s.add_dependency(%q<activesupport>.freeze, ["~> 5.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.12"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
  end
end
