class Alliance
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ally_id
  field :relationship, default: 'other'

  belongs_to :user

  ALLIANCES = %w(spouse grandmother grandfather grandson granddaughter mother father son daughter aunt uncle cousin nephew niece friend fiance sister brother sibling other)

  ALLIANCE_OPPOSITES = {
    spouse:        {male: 'spouse',      female: 'spouse'}, 
    grandmother:   {male: 'grandson',    female: 'granddaughter'}, 
    grandfather:   {male: 'grandson',    female: 'granddaughter'}, 
    grandson:      {male: 'grandfather', female: 'grandmother'}, 
    granddaughter: {male: 'grandfather', female: 'grandmother'}, 
    mother:        {male: 'son',         female: 'daughter'}, 
    father:        {male: 'son',         female: 'daughter'}, 
    son:           {male: 'father',      female: 'mother'}, 
    daughter:      {male: 'father',      female: 'mother'}, 
    aunt:          {male: 'nephew',      female: 'niece'}, 
    uncle:         {male: 'nephew',      female: 'niece'}, 
    cousin:        {male: 'cousin',      female: 'cousin'}, 
    nephew:        {male: 'uncle',       female: 'aunt'}, 
    niece:         {male: 'uncle',       female: 'aunt'}, 
    friend:        {male: 'friend',      female: 'friend'}, 
    fiance:        {male: 'fiance',      female: 'fiance'}, 
    sister:        {male: 'brother',     female: 'sister'}, 
    brother:       {male: 'brother',     female: 'sister'}, 
    sibling:       {male: 'brother',     female: 'sister'}, 
    other:         {male: 'other',       female: 'other'}, 
  }

  scope :friends, where(relationship: 'friend')

  class << self
    def find_opposite_relationship relationship, gender
      ALLIANCE_OPPOSITES[relationship.to_sym][gender.to_sym]
    end
  end

  def ally
    User.find(self.ally_id)
  end
end
