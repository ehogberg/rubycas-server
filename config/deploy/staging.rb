set :repository, "git@github.com:opinionlab/ol-rubycas-server.git"
set :bundle_flags, "--no-deployment"
set :branch, "develop"

set :rvm_type, :system    # :user is the default
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system

require "rvm/capistrano"  # Load RVM's capistrano plugin.

server "cas_vm-stage", :web, :app, :db, :primary => true

