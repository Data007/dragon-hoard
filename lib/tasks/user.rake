def normalize_phone user
  puts "0.0\nReviewing phone number for #{user.full_name} (##{user.id})"
  begin
    user.phones
    puts '  - Phone numbers already ported ... Skipping'
  rescue
    new_phone_list = []
    user[:old_phones] = user[:phones]
    user[:phones].each do |phone_string|
      puts "  - Found old phone number #{phone_string}"
      print '  - Porting old phone number to new phone number ... '
      new_phone_list << Phone.new(number: phone_string)
      puts 'Done'
    end
    begin
      user[:phones] = []
    end
    new_phone_list.each do |phone|
      user.phones << phone
    end
    user.save(validate: false)
  end
end

def normalize_addresses user
  puts "0.0\nReviewing addresses for #{user.full_name} (##{user.id})"
  begin
    user.addresses
    puts '  - Phone numbers already ported ... Skipping'
  rescue
    new_address_list = []
    user[:old_address] = user[:addresses]
    unless user[:addresses]
      puts "No Addresses for the User"
      return true
    end
    user[:addresses].each do |address_string|
      address_1 = "#{address_string["address_1"]}"
      puts "  - Found old Address" + address_1
      print '  - porting old address to new address ... '
      new_address_list << Address.new(address_1: address_string["address_1"], address_2: address_string["address_2"], city: address_string["city"], province: address_string["province"], postal_code: address_string["postal_code"], country: address_string["country"])
      puts 'Done'
    end
    begin
      user[:addresses] = []
    end
    new_address_list.each do |address|
      binding.pry
      user.addresses << address
    end
    user.save(validate: false)
  end
end

namespace :user do
  namespace :normalize do
    desc 'Normalize and migrate old email format'
    task email: :environment do
      User.all.each do |user|
        puts '0.0'
        print "Reviewing phone normalization status for #{user.full_name} (##{user.id}) ... "
        begin
          user.phones
          puts 'Phones properly migrated'
        rescue
          puts 'MIGRATING PHONES'
          normalize_phone user
        end

        puts "Reviewing email for #{user.full_name} (##{user.id})"
        if user.email
          puts '  - Email already ported ... Skipping'
        elsif user[:emails].present?
          print "  - Porting first email (#{user[:emails].first}) to primary email ... "
          user.email = user[:emails].first
          user.save(validate: false)
          puts 'Done'
        else
          puts '  *NO EMAILS FOUND*'
        end
      end
    end

    desc 'Normalize and migrate old phone format'
    task phone: :environment do
      User.all.each do |user|
        normalize_phone user
      end
    end

    desc 'Normalize and migrate old address format'
    task address: :environment do
      User.all.each do |user|
        normalize_addresses user
      end
    end

    desc 'Normalize and migrate old name format'
    task name: :environment do
      User.all.each do |user|
        if user.name
          puts "#{user.id} splitting names"
          name = user.name.split
          user.first_name = name[0]
          user.last_name = name.length == 3 ? name[2] : name [1]
          user.save(validate: false)
        end
      end
    end
  end
end
