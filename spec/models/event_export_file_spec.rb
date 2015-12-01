# -*- encoding: utf-8 -*-
require 'spec_helper'
  
describe EventExportFile do
  fixtures :all
  
  it "should export in background" do
    message_count = Message.count
    file = EventExportFile.new
    file.user = users(:admin)
    file.save
    EventExportFileJob.perform_later(file).should be_truthy
    Message.count.should eq message_count + 1
    Message.order(:id).last.subject.should eq 'エクスポートが完了しました'
  end
end

# == Schema Information
#
# Table name: event_export_files
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  event_export_file_name    :string
#  event_export_content_type :string
#  event_export_file_size    :integer
#  event_export_updated_at   :datetime
#  executed_at               :datetime
#  created_at                :datetime
#  updated_at                :datetime
#
