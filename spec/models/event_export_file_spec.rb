require 'rails_helper'

describe EventExportFile do
  fixtures :all

  it 'should export' do
    message_count = Message.count
    file = EventExportFile.new
    file.user = users(:admin)
    file.save
    file.export!
    Message.count.should eq message_count + 1
    Message.order(:id).last.subject.should eq 'エクスポートが完了しました'
  end
end

# == Schema Information
#
# Table name: event_export_files
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  executed_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  attachment_data :jsonb
#
