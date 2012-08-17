set :bundle_flags, "--no-deployment"

server "localhost", :web, :app, :db, :primary => true

ssh_options[:port] = 2222
ssh_options[:keys] = "~/.ssh/id_rubycas_deploy"



