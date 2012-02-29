#
# Flipstone deployment recipes
#
require "flipstone-deployment/capistrano/rails"
load "deploy/assets"

set :noalert_events, []

#
# Application environment defaults
# These should be set by the (environment) task, run first
#
# set :rails_env, 'development'
set :instance, "localhost"
set :branch, "master"
set :deployment_safeword, "insanitysauce"

#
# environment settings (by task)
#
desc "Runs any following tasks to production environment"
task :production do
  sanity_check
  set :rails_env, "production"
  set :instance, "pktracker.flipstone.com"
  set :unicorn_port, 15099
  set :nginx_cfg, {
    ht_user: 'trackthing',
    ht_passwd: 'trackme',
    port: 80,
    ht_off: ['/pivotal_activity']
  }
  set_env
end


desc "Sets Capistrano environment variables after environment task runs"
task :set_env do
  role :web,      "#{instance}"
  role :app,      "#{instance}"
  role :db,       "#{instance}", :primary => true

  set :application, "pktracker-#{rails_env}"
  set :deploy_to, "/srv/#{application}"
  set :scm_command, "GIT_SSH=#{deploy_to}/git_ssh.sh git"
  set :scm_passphrase, ""
  set :deploy_via, :remote_cache
  set :repository, "git@github.com:unlikely/PKTracker"
  set :use_sudo, false
  set :user, "ubuntu"
  set :scm, "git"
  set :local_scm_command, "git"

  ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/fs-remote.pem"]
  ssh_options[:paranoid] = false
  ssh_options[:user] = "ubuntu"

  default_run_options[:pty] = true

  set :zbatery, {
    port: unicorn_port,
    worker_processes: 4,
    worker_connections: 100,
    worker_timeout: 15, #in seconds
  }

end

set :rds_cfg, {
  :host => "flipstone.ctf5dd2ocka6.us-east-1.rds.amazonaws.com",
  :master_user => "flipstone",
  :master_pwd => "flipstone",
  :port => "3306"
}

namespace :secrets do
  task :symlink do
    run "ln -sf #{shared_path}/system/tracker_token #{release_path}/config/tracker_token"
  end
end

before "deploy:assets:precompile", "secrets:symlink"
