# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules, Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # note that this include statement comes AFTER the devise block above
  include DeviseTokenAuth::Concerns::User

  has_many :interests, dependent: :destroy
  has_many :activities, through: :interests

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, on: :create

  # Needed to add these in to avoid PG::UniqueViolation Error
  before_save :sync_uid
  before_create :sync_uid

  protected
    def sync_uid
      self.uid = email
    end
end
