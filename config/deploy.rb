# frozen_string_literal: true

# config valid only for current version of Capistrano
lock "~> 3.14.1"

set :application, "hackershare"
set :repo_url, "https://github.com/hackershare/hackershare.git"

set :assets_roles, [:app]

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# set :branch, fetch(:stage)

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/hackershare"
set :rvm_ruby_version, File.read(".ruby-version").strip
set :rvm_custom_path, "/usr/share/rvm"  # only needed if not detected

set :puma_init_active_record, true

# Default value for :format is :airbrussh.
# set :format, :airbrussh
Rake::Task["deploy:assets:backup_manifest"].clear_actions
# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/uploads", "storage", "public/sitemap"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5
