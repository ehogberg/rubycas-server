set :bundle_flags, "--no-deployment"
set :stages, %w(deploy-test staging)
set :default_stage, "deploy-test"

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

#set :rvm_ruby_string, '1.9.3-p194@rubycas-server'
#require 'rvm/capistrano'

set :application, "rubycas-server"
set :scm, :git


set :user, "rubycas"
set :group, "rubycas"

set :deploy_to, "/var/rubycas"
set :use_sudo, false

set :deploy_via, :copy
set :copy_strategy, :export


namespace :deploy do

  task :migrate do ; end

  task :copy_configs do
    run "cp #{shared_path}/config/* #{current_release}/config"
    run "ln -sf #{current_release}/config/config.yml /etc/rubycas-server/config.yml"
  end

  #before "deploy:update", "rvm:create_gemset"

  task :start do
  	run "/etc/init.d/rubycas start"
  end

  task :stop do
  	run "/etc/init.d/rubycas stop"
  end

  task :restart do
  	run "/etc/init.d/rubycas restart"
  end
  
  after "deploy:create_symlink", "deploy:copy_configs"
end
