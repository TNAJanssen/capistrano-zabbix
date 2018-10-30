require 'zabbixapi'

# Communicates with Zabbix through API and performs actions on
# maintenance objects.
class ZabbixMaintenance
  attr_reader :id, :maint_title, :zbx

  def initialize(client, title: 'capistrano auto maintenance')
    @zbx = client
    @maint_title = "#{title} #{fetch(:stage)}"
    @id = nil
  end

  def maint_id
    params = {name: @maint_title}
    puts params
    ret = @zbx.maintenance.get(params)
    begin
      ret.first['maintenanceid'].to_i
    rescue NoMethodError
      nil
    end
  end

  def create_or_replace(*args)
    delete(id: maint_id) if exists?
    create(*args)
  end

  def create(groupids, period: 3600)
    maint_params = {
        name: @maint_title,
        active_since: Time.now.to_i - 300,
        active_till: Time.now.to_i + 1800,
        groupids: groupids,
        timeperiods: [{ period: period , start_date: 5.minutes.ago.to_i}]
    }
    ret = @zbx.maintenance.create(maint_params)
    @id = ret
  end

  def close(id: @id)
    ret = @zbx.maintenance.update({
      maintenanceid: id,
      active_till: Time.now.to_i,
    })
    unless ret == id
      fail "Maintenance id:#{id} has not been deleted"
    end
    true
  end


  def delete(id: @id)
    ret = @zbx.maintenance.delete(id)
    unless ret == id
      fail "Maintenance id:#{id} has not been deleted"
    end
    true
  end

  def exists?
     !maint_id.nil?
  end

  def authenticated?
    !(@zbx.nil? || @zbx.client.auth.nil?)
  end
end
