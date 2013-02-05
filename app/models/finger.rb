class Finger
  include Mongoid::Document

  belongs_to :user

  field :name
  field :size
end
