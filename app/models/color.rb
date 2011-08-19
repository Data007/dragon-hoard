class Color
  include Mongoid::Document

  field :position, type: Integer
  field :names

  default_scope asc(:position)
end