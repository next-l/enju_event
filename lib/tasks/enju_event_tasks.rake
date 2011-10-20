require 'active_record/fixtures'
desc "copy fixtures for enju_event"
task :enju_event => :environment do
  ActiveRecord::Fixtures.create_fixtures(File.expand_path(File.dirname(__FILE__)) + '/../../db/fixtures/', File.basename('event_categories', '.yml'))
end
