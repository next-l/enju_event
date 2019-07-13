class EnjuEvent::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_event")
    rake("enju_event_engine:install:migrations")
    inject_into_file 'app/controllers/application_controller.rb',
      "  enju_event\n", after: "enju_library\n"
    inject_into_file 'app/assets/stylesheets/enju_leaf/application.css',
      " *= require enju_event/application\n", after: " *= require enju_leaf/application\n"
    inject_into_file 'app/assets/javascripts/enju_leaf/application.js',
      "//= require enju_event/application\n", after: "//= require enju_leaf/application\n"
  end
end
