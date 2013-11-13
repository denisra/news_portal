set :application, 'portal'
set :repo_url, 'git@bitbucket.org:denisra/news_portal.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

 set :deploy_to, '/home/denisra/webapps/portal'
 set :scm, :git

 set :format, :pretty
 set :log_level, :debug
 set :pty, true

# bundler settings:
 set :bundle_without, %w{production test}.join(' ')



# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :tmp_dir, "#{deploy_to}/tmp"

# set :default_env, { path: "/opt/ruby/bin:$PATH" }

 set :default_env, {
        "PATH"      =>  "#{deploy_to}/bin:$PATH",
        "GEM_HOME"  =>  "#{deploy_to}/gems",
        "RAILS_ENV" =>  "development"
}

 set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute "#{deploy_to}/bin/restart"
    end
  end

#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
       #within release_path do
         #execute :rake, 'cache:clear'
#       end
#    end
#  end

  after :finishing, 'deploy:cleanup'

end
