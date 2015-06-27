# -*- encoding: utf-8 -*-
require 'spec_helper'

describe EventImportFile do
  fixtures :all
  #pending "add some examples to (or delete) #{__FILE__}"

  describe "When it is written in utf-8" do
    before(:each) do
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_import_file_sample1.tsv"), :default_library_id => 3
      @file.default_library = Library.find(3)
      @file.default_event_category = EventCategory.find(3)
      @file.user = users(:admin)
    end

    it "should be imported" do
      closing_days_size = Event.closing_days.size
      old_events_count = Event.count
      old_import_results_count = EventImportResult.count
      @file.import_start.should eq({:imported => 2, :failed => 2})
      Event.count.should eq old_events_count + 2
      Event.closing_days.size.should eq closing_days_size + 1
      EventImportResult.count.should eq old_import_results_count + 5
      Event.order(:id).last.library.name.should eq 'hachioji'
      Event.order(:id).last.name.should eq 'event3'
      Event.where(name: 'event2').first.should be_nil
      event3 = Event.where(name: 'event3').first
      event3.display_name.should eq 'イベント3'
      event3.event_category.name.should eq 'book_talk'
      event4 = Event.where(name: '休館日1').first
      event4.event_category.name.should eq 'closed'

      @file.event_import_fingerprint.should be_truthy
      @file.executed_at.should be_truthy

      @file.reload
      @file.error_message.should eq "The following column(s) were ignored: invalid"
    end

    it "should send message when import is completed" do
      old_message_count = Message.count
      @file.user = User.where(username: 'librarian1').first
      @file.import_start
      Message.count.should eq old_message_count + 1
      Message.order(:id).last.subject.should eq 'インポートが完了しました'
    end
  end

  describe "When it is written in shift_jis" do
    before(:each) do
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_import_file_sample2.tsv")
      @file.default_library = Library.find(3)
      @file.default_event_category = EventCategory.find(3)
      @file.user = users(:admin)
    end

    it "should be imported" do
      old_event_count = Event.count
      old_import_results_count = EventImportResult.count
      @file.import_start
      Event.order('id DESC').first.name.should eq 'event3'
      Event.count.should eq old_event_count + 2
      EventImportResult.count.should eq old_import_results_count + 5
      Event.order('id DESC').first.start_at.should eq Time.zone.parse('2014-07-01').beginning_of_day
      Event.order('id DESC').first.end_at.should eq Time.zone.parse('2014-07-31 14:00')
    end
  end

  describe "When it is an invalid file" do
    before(:each) do
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/invalid_file.tsv")
    end

    it "should not be imported" do
      old_event_count = Event.count
      old_import_results_count = EventImportResult.count
      lambda{@file.import_start}.should raise_error(RuntimeError)
      Event.count.should eq Event.count
      EventImportResult.count.should eq EventImportResult.count
    end
  end

  describe "when its mode is 'update'" do
    it "should update events" do
      @file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_update_file.tsv")
      @file.modify
      event1 = Event.find(1)
      event1.name.should eq '変更後のイベント名'
      event1.start_at.should eq Time.zone.parse('2012-04-01').beginning_of_day
      event1.end_at.should eq Time.zone.parse('2012-04-02')

      event2 = Event.find(2)
      event2.end_at.should eq Time.zone.parse('2012-04-03')
      event2.all_day.should be_falsy
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

  it "should import in background" do
    file = EventImportFile.create :event_import => File.new("#{Rails.root.to_s}/../../examples/event_import_file_sample1.tsv")
    file.user = users(:admin)
    file.save
    EventImportFileQueue.perform(file.id).should be_truthy
  end
end

# == Schema Information
#
# Table name: event_import_files
#
#  id                        :integer          not null, primary key
#  parent_id                 :integer
#  content_type              :string(255)
#  size                      :integer
#  user_id                   :integer
#  note                      :text
#  executed_at               :datetime
#  event_import_file_name    :string(255)
#  event_import_content_type :string(255)
#  event_import_file_size    :integer
#  event_import_updated_at   :datetime
#  edit_mode                 :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  event_import_fingerprint  :string(255)
#  error_message             :text
#  user_encoding             :string(255)
#  default_library_id        :integer
#  default_event_category_id :integer
#
