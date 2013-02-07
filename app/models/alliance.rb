class Alliance
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ally_id
  field :relationship, default: 'friend'

  belongs_to :user

  ALLIANCES = %w(spouse grandparent parent child aunt uncle cousin nephew niece friend fiance sister brother sibling)

  scope :friends, where(relationship: 'friend')

  def ally
    User.find(self.ally_id)
  end
end
