class LiveSearch
  class << self
    def query params
      id = params.to_s.match(/^(ID|id|Id)?(\d*)$/)
      return Item.where(pretty_id: id.captures[1]) if id
      items_by_description = Item.where(description: Regexp.new(params))
      items_by_name        = Item.where(name: Regexp.new(params))
      items_by_description + items_by_name
    end
  end
end
