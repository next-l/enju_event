require 'active_record/fixtures'
desc "create initial records for enju_event"
namespace :enju_event do
  task setup: :environment do
    Dir.glob(Rails.root.to_s + '/db/fixtures/enju_event/*.yml').each do |file|
      ActiveRecord::FixtureSet.create_fixtures('db/fixtures/enju_event', File.basename(file, '.*'))
    end
  end

  desc "import events from a TSV file"
  task event_import: :environment do
    EventImportFile.import
  end

  desc "upgrade enju_event to 1.3"
  task upgrade_to_13: :environment do
    Rake::Task['statesman:backfill_most_recent'].invoke('EventExportFile')
    Rake::Task['statesman:backfill_most_recent'].invoke('EventImportFile')
  end

  desc "upgrade enju_event to 2.0"
  task upgrade: :environment do
    class_names = [
      Event, EventCategory
    ]
    class_names.each do |klass|
      klass.find_each do |record|
        I18n.available_locales.each do |locale|
          next unless record.respond_to?("display_name_#{locale}")
          record.update("display_name_#{locale}": YAML.safe_load(record[:display_name])[locale.to_s])
        end
      end
    end
    puts 'enju_event: The upgrade completed successfully.'
  end
end
