# namaste.rb Rails 2.3.x Template
# from Nick Plante (zapnap) for Nth Metal Interactive

##############
# EDGE RAILS
##############
# inside('vendor') { run 'ln -s ~/dev/rails/rails rails' }

###########
# CLEANUP
###########
run "rm README"
run "rm public/index.html"
run "rm -f public/javascripts/*"
run "cp config/database.yml config/database.yml.example"

##########
# JQUERY
##########
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js > public/javascripts/jquery.form.js"
  
#############
# GITIGNORE
#############
file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

########
# GEMS
########
gem 'haml'
gem 'authlogic'
gem 'will_paginate'
gem 'factory_girl'
gem 'mocha', :env => :test
gem 'rspec', :lib => false, :env => :test
gem 'rspec-rails', :lib => false, :env => :test
gem 'cucumber', :lib => false, :env => :test
gem 'webrat', :lib => false, :env => :test

rake('gems:install', :sudo => true)

###########
# PLUGINS
###########
plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git'
plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'
plugin 'authlogic_generator', :git => 'git://github.com/zapnap/authlogic_generator.git'

##########
# CONFIG
##########
run 'haml --rails .'

generate 'rspec'
generate 'cucumber'

run "touch public/stylesheets/application.css"
run 'touch spec/factories.rb'

##############
# INITIALIZERS
##############
initializer 'hoptoad.rb',
%q{HoptoadNotifier.configure do |config|
  config.api_key = 'HOPTOAD-KEY'
end
}

#######
# FILES
#######
file 'app/controllers/application_controller.rb',
%q{class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password
end
}

file 'app/views/layouts/_flashes.html.haml',
%q{#flash
  - flash.each do |key, value|
    %div{:id => "flash_#{key}"}= h(value)
}

file 'app/views/layouts/application.html.haml',
%q{!!!
%html{:xmlns => "http://www.w3.org/1999/xhtml", :lang => "en", "xml:lang" => "en"}
  %head
    %meta{'http-equiv' => 'Content-type', :content => 'text/html; charset=utf-8'}
    %title NAMASTE!
    = stylesheet_link_tag('application', :media => 'all')
    = javascript_include_tag('jquery-1.3.2.min.js')
  %body
    = render(:partial => 'layouts/flashes')
    = yield
}

##############
# CAPISTRANO
##############
capify!

############
# FINALIZE
############
git :init
git :add => '.'
git :commit => "-a -m 'Initial commit'"

generate 'authlogic', '--haml'
rake 'db:migrate'

#########
# DONE!
#########
puts "NAMASTE!"
