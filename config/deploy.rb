set :user,                        ENV["PRODUCTION_USER"]
set :repo_url,                    ENV["PRODUCTION_REPO"]
set :application,                 ENV["APP_NAME"]
set :puma_threads,                [4, 16]
set :puma_workers,                0
set :pty,                         true
set :use_sudo,                    false
set :deploy_via,                  :remote_cache
set :deploy_to,                   "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,                   "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,                  "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,                    "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log,             "#{release_path}/log/puma.error.log"
set :puma_error_log,              "#{release_path}/log/puma.access.log"
set :ssh_options,                 forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa_deploy.pub)
set :puma_preload_app,            true
set :bundle_flags,                "--quiet"
set :puma_worker_timeout,         nil
set :puma_init_active_record,     true
set :bundle_check_before_install, false
set :linked_files,                %w{config/master.key config/database.yml config/application.yml config/credentials.yml.enc}
set :branch,                      ENV["BRANCH"] || "master"
set :bundle_path,                 "#{ENV["HOME"]}/bundle"

namespace :puma do
  desc "Create Directories for Puma Pids and Socket"
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "create database"
  task :create_database do
    on roles(:app) do
      within release_path.to_s do
        with rails_env: ENV["RAILS_ENV"] do
          execute :rake, "db:create --trace"
        end
      end
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/develop_capistrano`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc "Initial Deploy"
  task :initial do
    on roles(:app) do
      before "deploy:restart", "puma:start"
      before "deploy:migrate", "deploy:create_database"
      invoke "deploy"
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "puma:restart"
    end
  end

  after :finishing, :cleanup
end
