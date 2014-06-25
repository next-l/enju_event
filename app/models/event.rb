# -*- encoding: utf-8 -*-
class Event < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  scope :closing_days, -> {includes(:event_category).where('event_categories.name = ?', 'closed').references(:event_categories)}
  scope :on, lambda {|datetime| where('start_at >= ? AND start_at < ?', datetime.beginning_of_day, datetime.tomorrow.beginning_of_day + 1)}
  scope :past, lambda {|datetime| where('end_at <= ?', Time.zone.parse(datetime).beginning_of_day)}
  scope :upcoming, lambda {|datetime| where('start_at >= ?', Time.zone.parse(datetime).beginning_of_day)}
  scope :at, lambda {|library| where(:library_id => library.id)}

  belongs_to :event_category, :validate => true
  belongs_to :library, :validate => true
  has_many :picture_files, :as => :picture_attachable
  has_many :participates, :dependent => :destroy
  has_many :agents, :through => :participates
  has_one :event_import_result

  index_name "#{name.downcase.pluralize}-#{Rails.env}"

  settings do
    mappings dynamic: 'false', _routing: {required: false} do
      indexes :name
      indexes :note
      indexes :library_id, type: 'integer'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'
      indexes :start_at, type: 'date'
      indexes :end_at, type: 'date'
    end
  end

  validates_presence_of :name, :library, :event_category
  validates_associated :library, :event_category
  validate :check_date
  before_validation :set_date
  before_validation :set_display_name, :on => :create

  paginates_per 10

  def set_date
    if self.start_at.blank?
      self.start_at = Time.zone.today.beginning_of_day
    end

    if all_day
      set_all_day
    else
      if self.end_at.blank?
        self.end_at = start_at.end_of_day
      end
    end
  end

  def set_all_day
    self.start_at = start_at.beginning_of_day
    if end_at
      self.end_at = end_at.end_of_day
    else
      self.end_at = start_at.end_of_day
    end
  end

  def check_date
    if self.start_at and self.end_at
      if self.start_at >= self.end_at
        errors.add(:start_at)
        errors.add(:end_at)
      end
    end
  end

  def set_display_name
    self.display_name = self.name if self.display_name.blank?
  end
end

# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  library_id        :integer          default(1), not null
#  event_category_id :integer          default(1), not null
#  name              :string(255)
#  note              :text
#  start_at          :datetime
#  end_at            :datetime
#  all_day           :boolean          default(FALSE), not null
#  deleted_at        :datetime
#  display_name      :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

