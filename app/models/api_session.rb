require 'digest/sha3'

class ApiSession
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token

  attr_accessor :pin

  validates :pin, presence: true

  belongs_to :user

  before_create :find_user
  after_create  :create_token

  def find_user
    self.user = User.where(pin: pin).first
    unless self.user
      errors.add(:pin, 'is not valid')
    end
  end

  def create_token
    update_attribute :token, Digest::SHA3.hexdigest("#{self.id}#{self.created_at}")
  end

  class << self
    def authorize pin
      new_session = ApiSession.create pin: pin
      return new_session
    end
  end
end
