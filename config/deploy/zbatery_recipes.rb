set(:upstart_conf_file) { File.join(File.dirname(__FILE__), "upstartjob.conf.erb") }

# override unicorn tasks to say zbatery instead
# before/after hooks set up by flipstone-deployment
# unicorn_recipes are left in place, so task names
# have not been changed.
#
# If we decide to continue using zbatery, we should
# officially support it in flipstone-deployment
set(:zbatery_pidfile) { "#{shared_path}/pids/zbatery.pid" }
set(:zbatery_stderr_path) { "#{shared_path}/log/zbatery.err.log" }
set(:zbatery_stdout_path) { "#{shared_path}/log/zbatery.log" }

namespace :deploy do
  desc "Create wrapper for executing the app"
  task :unicorn_wrapper do
    sudo "rvm wrapper 1.9.2 #{application} #{current_path}/bin/zbatery"
  end

  #
  # Unicorn signals per: http://unicorn.bogomips.org/SIGNALS.html
  #
  desc "Create unicorn configuration file"
  task :unicorn_config, :roles => :app do
    template = File.read(File.join(File.dirname(__FILE__), "zbatery.conf.erb"))
    buffer   = ERB.new(template).result(binding)
    put buffer, "#{shared_path}/system/zbatery.conf"
  end

  task :start, :roles => :app do
    sudo "start #{application}"
  end

  task :stop, :roles => :app do
    # returning true on stop in the event this app isn't actually running 
    # todo figure out how to test results of `status #{application}`
    run "test -f /etc/init.d/#{application} && sudo stop #{application}; true"
    run "test -f #{shared_path}/pids/zbatery.pid && kill -TERM `cat #{shared_path}/pids/zbatery.pid`; true"
  end

  task :restart, :roles => :app do
    stop
    start
  end

  task :reload, :roles => :app do
    run "test -f #{shared_path}/pids/zbatery.pid && kill -HUP `cat #{shared_path}/pids/zbatery.pid`"
  end
end


