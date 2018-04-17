namespace :load do
  task :defaults do
    set :zabbix_username,               ENV['CAPISTRANO_ZABBIX_USERNAME']
    set :zabbix_password,               ENV['CAPISTRANO_ZABBIX_PASSWORD']
    set :zabbix_url,                    ENV['CAPISTRANO_ZABBIX_URL']
    set :zabbix_period,                 900
    set :zabbix_groupid,                nil
  end
end

namespace :zabbix do
  desc 'Create maintenance'
  task :create_maintenance do |_t|
    ZabbixMaintenance.client.maintenance.create(
        :name => 'capistrano auto maintenance',
        :period => fetch(:zabbix_period),
        :groupids => [ fetch(:zabbix_groupid) ]
    )
  end

  desc 'Check Zabbix setup'
  task :check do
    errored = false
    required_params =
        %i[zabbix_username zabbix_password zabbix_url zabbix_period zabbix_groupid zabbix_auto_trigger]

    puts '=> Required params'
    required_params.each do |param|
      print "#{param} = "
      if fetch(param).nil? || fetch(param) == ''
        puts '!!!!!! EMPTY !!!!!!'
        errored = true
      else
        puts param == :zabbix_password ? '**********' : fetch(param)
      end
    end
    raise StandardError, 'Not all required parameters are set' if errored
    puts '<= OK'

    puts '=> Checking connection'
    hostgroups = ::Capistrano::Zabbix.client.hostgroups.get(groupids: fetch(:zabbix_groupid))
    puts '<= OK'

    puts '=> Checking for given host group'
    exist = hostgroups.any? { |hostgroup| Integer(hostgroup["groupid"]) == Integer(fetch(:zabbix_groupid)) }
    unless exist
      raise StandardError, "Host group #{fetch(:zabbix_groupid)} not found"
    end
    puts '<= OK'
  end

  desc 'Create maintenance in Zabbix'
  task :create do
    zm_api.create_or_replace [fetch(:zabbix_groupid)], period: fetch(:zabbix_period)
    puts 'Maintenance created'
  end

  desc 'Delete maintenance in Zabbix'
  task :delete do
    zm_api.delete(id: zm_api.maint_id)
    puts 'Maintenance deleted'
  end
end

before 'deploy:started',         'zabbix:create'
after 'deploy:published',        'zabbix:delete'
after 'deploy:failed',           'zabbix:delete'

def zm_api
  zbx = ZabbixMaintenance.new(::Capistrano::Zabbix.client)
  set(:zbx_handle, zbx)
end
