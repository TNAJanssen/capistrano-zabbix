require 'active_support'
# require 'capistrano/jira/version'
require 'zabbixapi'

module Capistrano
  module Zabbix
    def self.client
      ZabbixApi.connect(user: fetch(:zabbix_username),
                         password: fetch(:zabbix_password),
                         url: fetch(:zabbix_url))
    end
  end
end

load File.expand_path('../tasks/zabbix.rake', __FILE__)
