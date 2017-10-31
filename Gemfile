source 'https://rubygems.org'
ruby '2.3.1'



# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# ============================
# View
# ============================
# Bootstrap & Bootswatch & font-awesome
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'font-awesome-rails'

# Fast Haml
gem 'faml'

# Form Builders
gem 'simple_form'

# Pagenation
gem 'kaminari'

# ============================
# Utils
# ============================
# Process Management
gem 'foreman'

# Presenter Layer Helper
gem 'cells'
gem 'cells-haml'

# Configuration using ENV
gem 'dotenv-rails'

# ============================
# Environment Group
# ============================
group :development do
  gem 'erb2haml'

  # help to kill N+1
  gem 'bullet'

  # To generate haml view by scaffold or other generate command
  gem 'haml-rails'

  # Syntax Checker
  # hook event pre-commit, pre-push
  gem 'overcommit', require: false

  # A static analysis security vulnerability scanner
  gem 'brakeman', require: false

  # Checks for vulnerable versions of gems
  gem 'bundler-audit', require: false

  # Style checker that helps keep CoffeeScript code clean and consistent
  gem 'coffeelint', require: false

  # Syntax checker for HAML
  gem 'haml-lint', require: false

  # Syntax checker for CSS
  gem 'ruby_css_lint', require: false

  # A Ruby static code analyzer
  gem 'rubocop', require: false
end

group :development, :test do
  # Pry & extensions
  gem 'pry-rails'
  gem 'pry-byebug'

  # Show SQL result in Pry console
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'awesome_print'

  # PG/MySQL Log Formatter
  gem 'rails-flog'

  # Rspec
  gem 'rspec-rails'

  # test fixture
  gem 'factory_girl_rails'

  # Handle events on file modifications
  gem 'guard-rspec',      require: false
  gem 'guard-rubocop',    require: false
  gem 'guard-livereload', require: false
end

group :test do
  # Mock for HTTP requests
  gem 'webmock'
  gem 'vcr'

  # Time Mock
  gem 'timecop'

  # Support to generate Test Data
  gem 'faker'

  # Cleaning test data
  gem 'database_rewinder'

  # This gem brings back assigns to your controller tests
  gem 'rails-controller-testing'
end

##############################################################################
# by yc
group :test do
  gem 'simplecov'
  gem 'psych'
end

gem 'rails_admin', '~> 1.0'
gem 'rails_admin-i18n'
gem 'rails_admin_import', git: 'https://github.com/stephskardal/rails_admin_import.git'

group :development, :test do
  gem 'guard-bundler', require: false
end

gem 'bh', '~> 1.3'
gem 'octokit'
gem 'omniauth'
gem 'omniauth-github'