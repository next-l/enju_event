require 'rails_helper'

describe EventCategory do
  #pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: event_categories
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
