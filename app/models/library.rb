require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'library.rb').to_s

class Library < ApplicationRecord
  include EnjuEvent::EnjuLibrary
end

# == Schema Information
#
# Table name: libraries
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  short_display_name        :string           not null
#  zip_code                  :string
#  street                    :text
#  locality                  :text
#  region                    :text
#  telephone_number_1        :string
#  telephone_number_2        :string
#  fax_number                :string
#  note                      :text
#  call_number_rows          :integer          default(1), not null
#  call_number_delimiter     :string           default("|"), not null
#  library_group_id          :bigint           not null
#  users_count               :integer          default(0), not null
#  position                  :integer
#  country_id                :bigint
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  opening_hour              :text
#  isil                      :string
#  latitude                  :float
#  longitude                 :float
#  display_name_translations :jsonb            not null
#
