def pin_login pin
  fill_in 'employee-id', with: pin
  click_button 'Enter'
end
