class Finger
  include Mongoid::Document

  field :name
  field :size

  belongs_to :user
end
