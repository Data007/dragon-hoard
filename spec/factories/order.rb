FactoryGirl.define do
  factory :order do
    refunded false
    ship false
    purchased false
    location 'website'
    notes 'testing order'
    shipping_option "UPS-03"
    factory :sale do
      staging_type 'sale'
      location 'store'
    end
  end
end
