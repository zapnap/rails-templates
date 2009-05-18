# namaste.rb
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

###########
# PLUGINS
###########
plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'
plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'
plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git'
plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'

########
# GEMS
########
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'mocha'

rake('gems:install', :sudo => true)

##########
# CONFIG
##########
generate('session', 'user_session')
generate('rspec')
rake('db:migrate')

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

file 'app/views/layouts/_flashes.html.erb',
%q{<div id="flash">
  <% flash.each do |key, value| -%>
    <div id="flash_<%= key %>"><%=h value %></div>
  <% end -%>
</div>
}

file 'app/views/layouts/application.html.erb',
%q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <title>TITLE</title>
    <%= stylesheet_link_tag('application', :media => 'all', :cache => true) %>
    <%= javascript_include_tag('jquery-1.3.2.min.js', :cache => true) %>
  </head>
  <body>
    <%= render(:partial => 'layouts/flashes') -%>
    <%= yield %>
  </body>
</html>
}

run "touch public/stylesheets/application.css"

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

#########
# DONE!
#########
puts "NAMASTE!"
