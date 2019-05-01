class EventExportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ExportFile

  has_one_attached :event_export
  has_many :event_export_file_transitions, autosave: false

  def state_machine
    EventExportFileStateMachine.new(self, transition_class: EventExportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def export!
    transition_to!(:started)
    tempfile = Tempfile.new(['event_export_file_', '.txt'])
    file = Event.export(format: :txt)
    tempfile.puts(file)
    tempfile.close
    self.event_export = File.new(tempfile.path, "r")
    save!
    transition_to!(:completed)
    mailer = EventExportMailer.completed(self)
    send_message(mailer)
  rescue => e
    transition_to!(:failed)
    mailer = EventExportMailer.failed(self)
    send_message(mailer)
    raise e
  end

  private
  def self.transition_class
    EventExportFileTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: event_export_files
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  executed_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
