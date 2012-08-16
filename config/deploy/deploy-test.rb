set :repository, "git@github.com:ehogberg/rubycas-server.git"
set :bundle_flags, "--no-deployment"
set :branch, "feature-capify"


server "localhost", :web, :app, :db, :primary => true

ssh_options[:port] = 2222
ssh_options[:keys] = "~/.vagrant.d/insecure_private_key"


