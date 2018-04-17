namespace :load do
  task :defaults do
    set :zabbix_username,               ENV['CAPISTRANO_ZABBIX_USERNAME']
    set :zabbix_password,               ENV['CAPISTRANO_ZABBIX_PASSWORD']
    set :zabbix_url,                    ENV['CAPISTRANO_ZABBIX_URL']
    set :zabbix_period,                 nil
    set :zabbix_groupid,                nil
    set :zabbix_auto_trigger,           true
  end
end

namespace :zabbix do
  desc 'Find and transit possible JIRA issues'
  task :find_and_transit do |_t|
    on :all do |_host|
      if fetch(:zabbix_validate_commit_messages)
        info 'Finding commit messages'
        commits = Capistrano::Zabbix::CommitFinder.new.find
      end

      info 'Looking for issues'
      begin
        issues = Capistrano::Zabbix::IssueFinder.new.find

        issues.each do |issue|
          begin
            if fetch(:zabbix_validate_commit_messages)
              commit = commits.find { |c| c.message.include?(issue.key)}
              if commit
                Capistrano::Zabbix::IssueTransiter.new(issue).transit
                info "#{issue.key}\t\u{2713} Transited\tCommit: #{commit.hash}"
              else
                info "#{issue.key}\t\u{21B7} Skipped"
              end
            else
              Capistrano::Zabbix::IssueTransiter.new(issue).transit
              info "#{issue.key}\t\u{2713} Transited"
            end
          rescue Capistrano::Zabbix::TransitionError => e
            warn "#{issue.key}\t\u{2717} #{e.message}"
          end
        end
      rescue Capistrano::Zabbix::FinderError => e
        error "#{e.class} #{e.message}"
      end
    end
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
    hostgroups = ::Capistrano::Zabbix.client.hostgroup.get
    puts '<= OK'

    puts '=> Checking for given project key'
    exist = hostgroups.any? { |hostgroup| hostgroup.groupid == fetch(:zabbix_groupid) }
    unless exist
      raise StandardError, "Host group #{fetch(:zabbix_groupid)} not found"
    end
    puts '<= OK'
  end

  # after 'deploy:finished', 'zabbix:find_and_transit'
end
