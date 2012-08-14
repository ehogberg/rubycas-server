set :repository, "git@github.com:opinionlab/ol-rubycas-server.git"
set :branch, "development"


server "cas_vm-stage", :web, :app, :db, :primary => true

