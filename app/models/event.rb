class Event < ActiveRecord::Base
  include Mobility
  scope :closing_days, -> { includes(:event_category).where('event_categories.name' => 'closed') }
  scope :on, lambda {|datetime| where('start_at >= ? AND start_at < ?', datetime.beginning_of_day, datetime.tomorrow.beginning_of_day + 1)}
  scope :past, lambda {|datetime| where('end_at <= ?', Time.zone.parse(datetime).beginning_of_day)}
  scope :upcoming, lambda {|datetime| where('start_at >= ?', Time.zone.parse(datetime).beginning_of_day)}
  scope :at, lambda {|library| where(library_id: library.id)}

  belongs_to :event_category, validate: true
  belongs_to :library, validate: true
  belongs_to :place, optional: true
  has_many :picture_files, as: :picture_attachable
  has_many :participates, dependent: :destroy
  has_many :agents, through: :participates
  has_one :event_import_result

  searchable do
    text :name, :note
    integer :library_id
    time :created_at
    time :updated_at
    time :start_at
    time :end_at
  end

  validates :name, :library, :event_category, :start_at, :end_at, presence: true
  validates_associated :library, :event_category
  validate :check_date
  before_validation :set_date
  before_validation :set_display_name, on: :create

  translates :display_name
  paginates_per 10

  def set_date
    if all_day
      set_all_day
    end
  end

  def set_all_day
    if start_at and end_at
      self.start_at = start_at.beginning_of_day
      self.end_at = end_at.end_of_day
    end
  end

  def check_date
    if start_at and end_at
      if start_at >= end_at
        errors.add(:start_at)
        errors.add(:end_at)
      end
    end
  end

  def set_display_name
    self.display_name = name if display_name.blank?
  end

  def self.export(options = {format: :txt})
    header = %w(
      name
      event_category
      library
      start_at
      end_at
      all_day
    )
    lines = []
    Event.find_each.map{|e|
      line = []
      line << e.name
      line << e.event_category.name
      line << e.library.name
      line << e.start_at
      line << e.end_at
      line << e.all_day
      lines << line
    }
    if options[:format] == :txt
      lines.map{|line| line.to_csv(col_sep: "\t")}.unshift(header.to_csv(col_sep: "\t")).join
    else
      event
    end
  end
end

# == Schema Information
#
# Table name: events
#
#  id                :uuid             not null, primary key
#  library_id        :bigint(8)        not null
#  event_category_id :bigint(8)        not null
#  name              :string           not null
#  note              :text
#  start_at          :datetime
#  end_at            :datetime
#  all_day           :boolean          default(FALSE), not null
#  display_name      :jsonb            not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  place_id          :bigint(8)
#
