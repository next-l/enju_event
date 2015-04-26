# -*- encoding: utf-8 -*-
require 'spec_helper'
  
describe EventExportFile do
  fixtures :all
  
  it "should export in background" do
    message_count = Message.count
    file = EventExportFile.new
    file.user = users(:admin)
    file.save
    EventExportFileQueue.perform(file.id).should be_truthy
    Message.count.should eq message_count + 1
    Message.order(:id).last.subject.should eq 'エクスポートが完了しました'
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
