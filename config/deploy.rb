# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'menuadhocbot'
set :repo_url, 'git@github.com:YeasterEgg/menuadhocbot.git'
set :deploy_to, '/var/www/menuadhocbot'
set :log_level, :info
set :keep_releases, 2

role :app, "root@46.101.114.92"
role :web, "root@46.101.114.92"

set :branch, ENV["BRANCH"] || 'master'

set :scm, :git

namespace :deploy do

  after :"deploy:finished", :change_ownership do
    on roles(:web) do
      execute "sudo chown -R www-data:www-data #{release_path}/"
    end
  end

  after :"deploy:change_ownership", :copy_dotenv do
    on roles(:web) do
      execute "ln -ns #{shared_path}/.env #{current_path}/."
    end
  end

  after :"deploy:copy_dotenv", :restart_server do
    on roles(:web) do
      execute "sudo systemctl restart menuadhocbot"
    end
  end

end
