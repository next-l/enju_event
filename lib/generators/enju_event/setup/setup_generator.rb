module EnjEvent
  class SetupGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_setup_files
      directory('db/fixtures', 'db/fixtures/enju_event')
      rake('enju_event_engine:install:migrations')
      inject_into_file 'app/controllers/application_controller.rb',
                       "  enju_event\n", after: "enju_library\n"
      inject_into_file 'app/assets/stylesheets/application.css',
                       " *= require enju_event/application\n", after: " *= require enju_leaf\n"
      inject_into_file 'app/assets/javascripts/application.js',
                       "//= require enju_event/application\n", after: "//= require enju_leaf\n"
    end
  end
end
