set :stages, %w(deploy-test staging)
set :default_stage, "deploy-test"
set :rvm_type, :system    # :user is the default
set :rvm_ruby_string, '1.9.3-p194@rubycas-server'

set :application, "rubycas-server"
set :repository, "git@github.com:opinionlab/ol-rubycas-server.git"
set :scm, :git

set :user, "rubycas"
set :group, "rubycas"

set :deploy_to, "/var/rubycas"
set :use_sudo, false

set :deploy_via, :copy
set :copy_strategy, :export
set :copy_exclude, [".git","spec"]


require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require "rvm/capistrano"  # Load RVM's capistrano plugin.


namespace :deploy do

  task :migrate do ; end

  desc "Copy Unicorn and Rubycas configs to proper locations."
  task :copy_configs do
    run "cp #{shared_path}/config/* #{current_release}/config"
    run "ln -sf #{current_release}/config/config.yml /etc/rubycas-server/config.yml"
  end

  task :start do
  	run "cd #{current_release} && bundle exec unicorn -c config/unicorn.rb -D"
  end

  task :stop do
  	run "kill -SIGKILL $( cat #{shared_path}/pids/rubycas.pid )"
  end

  task :restart do
  	run "kill -SIGHUP $( cat #{shared_path}/pids/rubycas.pid )"
  end
  
  before 'deploy:update_code', 'rvm:create_gemset' # only create gemset
  after "deploy:create_symlink", "deploy:copy_configs"
end


namespace :status do

  desc "Check status of Unicorn worker processes."
  task :unicorn do
    run "ps -ef |grep unicorn|grep -v -e 'grep'"
  end

  desc "Check status of nginx."
  task :nginx do
    run "ps -ef|grep nginx|grep -v -e 'grep'"
  end

  desc "Do a simple GET to demonstrate the stack is working."
  task :ping do
    run "curl localhost/login"
  end

  
  namespace :log do

    desc "Dump most recent 250 lines of Unicorn stdout log."
    task :stdout do
      run "tail -n 250 #{shared_path}/log/rubycas.stdout.log"
    end
  
    desc "Dump most recent 250 lines of Unicorn stderr log."
    task :stderr do
      run "tail -n 250 #{shared_path}/log/rubycas.stderr.log"
    end

  end

end

