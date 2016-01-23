class EventExportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ExportFile

  attachment :event_export
  has_many :event_export_file_transitions

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
    if save
      send_message
    end
    transition_to!(:completed)
  rescue => e
    transition_to!(:failed)
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
#  id                    :integer          not null, primary key
#  user_id               :integer
#  executed_at           :datetime
#  created_at            :datetime
#  updated_at            :datetime
#  event_export_id       :string
#  event_export_size     :integer
#  event_export_filename :string
#
