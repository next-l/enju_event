require 'rails_helper'

describe EventImportResult do
  #pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: event_import_results
#
#  id                   :bigint(8)        not null, primary key
#  event_import_file_id :uuid
#  event_id             :uuid
#  body                 :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
