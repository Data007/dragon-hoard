class Manage::SalesController < ManageController
  before_filter :force_access_pin
end
