desc 'Take First Name and split it into first and last name'
task seperate_name_to_first_and_last_names: :environment do
  User.all.each do |user|
    if user.name
      puts "#{user.id} splitting names"
      name = user.name.split
      user.first_name = name[0]
      user.last_name = name[1]
      user.save!(validate: false)
    end
  end
end
