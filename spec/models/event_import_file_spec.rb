# -*- encoding: utf-8 -*-
require 'spec_helper'

describe EventImportFile do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe "When it is written in utf-8" do
    before(:each) do
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_import_file_sample1.tsv")
    end

    it "should be imported" do
      closing_days_size = Event.closing_days.size
      old_events_count = Event.count
      old_import_results_count = EventImportResult.count
      @file.import_start.should eq({:imported => 3, :failed => 0})
      Event.count.should eq old_events_count + 3
      Event.closing_days.size.should eq closing_days_size + 1
      EventImportResult.count.should eq old_import_results_count + 4

      @file.event_import_fingerprint.should be_true
      @file.executed_at.should be_true
    end
  end

  describe "When it is written in shift_jis" do
    before(:each) do
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_import_file_sample2.tsv")
    end

    it "should be imported" do
      old_event_count = Event.count
      old_import_results_count = EventImportResult.count
      @file.import_start
      Event.order('id DESC').first.name.should eq '日本語の催し物2'
      Event.count.should eq old_event_count + 2
      EventImportResult.count.should eq old_import_results_count + 3
      Event.order('id DESC').first.start_at.should eq Time.zone.parse('2011-03-26').beginning_of_day
      Event.order('id DESC').first.end_at.to_s.should eq Time.zone.parse('2011-03-27').end_of_day.to_s
    end
  end

  describe "when its mode is 'update'" do
    it "should update events" do
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_update_file.tsv")
      @file.modify
      event1 = Event.find(1)
      event1.name.should eq '変更後のイベント名'
      event1.start_at.should eq Time.zone.parse('2012-04-01').beginning_of_day
      event1.end_at.to_s.should eq Time.zone.parse('2012-04-02').end_of_day.to_s

      event2 = Event.find(2)
      event2.end_at.to_s.should eq Time.zone.parse('2012-04-03').beginning_of_day.to_s
      event2.all_day.should be_false
      event2.library.name.should eq 'mita'

      event3 = Event.find(3)
      event3.name.should eq 'ミーティング'
    end
  end
    

  describe "when its mode is 'destroy'" do
    it "should destroy events" do
      old_event_count = Event.count
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_destroy_file.tsv")
      @file.remove
      Event.count.should eq old_event_count - 2
    end
  end
end

# == Schema Information
#
# Table name: event_import_files
#
#  id                        :integer         not null, primary key
#  parent_id                 :integer
#  content_type              :string(255)
#  size                      :integer
#  user_id                   :integer
#  note                      :text
#  executed_at               :datetime
#  state                     :string(255)
#  event_import_file_name    :string(255)
#  event_import_content_type :string(255)
#  event_import_file_size    :integer
#  event_import_updated_at   :datetime
#  edit_mode                 :string(255)
#  event_import_fingerprint  :string(255)
#  created_at                :datetime        not null
#  updated_at                :datetime        not null
#  event_fingerprint         :string(255)
#  error_message             :text
#

