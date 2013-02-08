class Alliance
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ally_id
  field :relationship, default: 'other'

  belongs_to :user

  ALLIANCES = %w(spouse grandmother grandfather mother father son daughter aunt uncle cousin nephew niece friend fiance sister brother sibling other)

  scope :friends, where(relationship: 'friend')

  def ally
    User.find(self.ally_id)
  end
end
