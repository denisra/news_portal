set :application, 'portal'
set :stage, :production
set :rails_env, 'production'

set :deploy_to, '/home/rails/portal'
set :tmp_dir, "#{deploy_to}/tmp"
set :use_sudo, true
 
 
set :default_env, {
        "PATH"      =>  "/home/rails/bin:$PATH",
        "rvm_bin_path" => "~/.rvm/bin",
#        "GEM_HOME"  =>  "#{deploy_to}/gems",
        "RAILS_ENV" =>  "production"
}

# bundler settings:
 set :bundle_without, %w{development test}.join(' ')

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, "162.243.218.136"
role :web, "162.243.218.136"
role :db,  "162.243.218.136"

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
  server '162.243.218.136', user: 'root', roles: %w{web app db} #, my_property: :my_value

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :production)
