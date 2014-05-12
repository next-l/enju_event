class EnjuEvent::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_event")
    rake("enju_event_engine:install:migrations")
    inject_into_file 'app/controllers/application_controller.rb',
      "  enju_event\n", :after => "enju_library\n"
  end
end
