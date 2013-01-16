class Sale < Order
  before_create -> {self.staging_type = 'sale'}
end
