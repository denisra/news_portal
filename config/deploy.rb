set :application, 'portal'
set :repo_url, 'git@bitbucket.org:denisra/news_portal.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

 set :deploy_to, '/home/denisra/webapps/portal'
 set :scm, :git
 set :verbose_command_log, true
 set :use_sudo, false


# bundler settings:
set :bundle_without, %w{production test}.join(' ')


# set :format, :pretty
# set :log_level, :debug
 set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :tmp_dir, "#{deploy_to}/tmp"

#set :default_stage, "development"
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, {
    "PATH"      =>  "#{deploy_to}/bin:$PATH",
    "GEM_HOME"  =>  "#{deploy_to}/gems",
    "RAILS_ENV" =>  "development"
}
set :keep_releases, 5



namespace :deploy do

  puts "===================================================\n"
  puts "         (  )   (   )  )"
  puts "      ) (   )  (  (         GO GRAB SOME COFFEE"
  puts "      ( )  (    ) )\n"
  puts "     <_____________> ___    CAPISTRANO IS ROCKING!"
  puts "     |             |/ _ \\"
  puts "     |               | | |"
  puts "     |               |_| |"
  puts "  ___|             |\\___/"
  puts " /    \\___________/    \\"
  puts " \\_____________________/ \n"
  puts "==================================================="

#  desc "Remake database"
#  task :remakedb do
#    run "cd #{deploy_to}/current; bundle exec rake db:migrate RAILS_ENV=#{default_stage}"
#    run "cd #{deploy_to}/current; bundle exec rake db:seed RAILS_ENV=#{default_stage}"
#  end

#  desc "Seed database"
#  task :seed do
#    run "cd #{deploy_to}/current; bundle exec rake db:seed RAILS_ENV=#{default_stage}"
#  end

  desc "Migrate database"
  task :migrate do
    on roles(:app) do
      execute "cd #{deploy_to}/current; bundle exec rake db:migrate RAILS_ENV=#{default_stage}"
    end
  end

#  desc "Bundle install gems"
#  task :bundle do
#    on roles(:app), in: :sequence, wait: 5 do
#      execute "cd #{deploy_to}/current; bundle install --deployment"
#    end
#  end

  desc "Restart nginx"
  task :restart do
    on roles(:app) do
      execute "#{deploy_to}/bin/restart"
    end
  end

  desc "Start nginx"
  task :start do
    on roles(:app) do
      execute "#{deploy_to}/bin/start"
    end
  end

  desc "Stop nginx"
  task :stop do
    on roles(:app) do
      execute "#{deploy_to}/bin/stop"
    end
  end

  namespace :assets do
    desc "Run the precompile task remotely"
    task :precompile do
      on roles(:app) do
        execute "cd #{deploy_to}/current; bundle exec rake assets:precompile RAILS_ENV=#{default_stage}"
    end
    end
  end

end



#after "deploy", "deploy:bundle"
after "deploy", "deploy:assets:precompile"
after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:restart"






#namespace :deploy do

#  desc 'Restart application'
#  task :restart do
#    on roles(:app), in: :sequence, wait: 5 do
#      run "#{deploy_to}/bin/restart"
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
#    end
#  end

#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
#    end
#  end

#  after :finishing, 'deploy:cleanup'

#end
