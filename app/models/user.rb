class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :events, dependent: :destroy
  has_one_attached :photo
  acts_as_taggable_on :hobbies

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:first_name, :nickname], using: { tsearch: { prefix: true } }

  def name_initials
    return "#{first_name[O, 1]}" << "#{last_name[0, 1]}"
  end

  def days_before_next_event
    next_event = []
    self.events.each do |event|
      next_event << ((event.starts_at - Time.now)/86400).to_i
    end
    return next_event.min
  end
end
