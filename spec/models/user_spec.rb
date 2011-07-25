require 'spec_helper'
require 'digest/sha2'

describe User do
  
  context 'Validation' do

    before do
      @user = Factory.build :user
    end

    it 'validates presence of name' do
      @user.errors.should_not include(:name)
      @user.name = nil
      @user.save
      @user.errors.should     include(:name)
    end

  end

  context 'Contact Information' do

    before do
      @user = Factory.create :user
    end

    it 'has emails' do
      @user.emails.should_not include('test@example.com')
      @user.emails << 'test@example.com'
      @user.emails.should include('test@example.com')
    end

    it 'has phones' do
      @user.phones.should_not include('2318843024')
      @user.phones << '2318843024'
      @user.phones.should include('2318843024')
    end

    it 'has addresses' do
      address_hash = {
        :address_1   => '1 Easy St.',
        :city        => 'Cadillac',
        :province    => 'MI',
        :postal_code => '49601',
        :country     => 'US'
      }

      @user.addresses.empty?.should be
      @user.addresses.create address_hash
      @user.addresses.where(address_hash).should be
    end

  end

  context '#hash_password' do
    
    it 'hashes password' do
      User.hash_password('password').should == Digest::SHA256.hexdigest('password')
    end

    it 'hashes password on save' do
      user = Factory.build :user
      user.password_hash.should_not be
      user.save
      user.reload.password_hash.should == User.hash_password('password')
    end

    it 'does not hash on save with a bad password confirmation match' do
      user = Factory.build :user, password_confirmation: 'passwor'
      user.errors.should_not include(:password_confirmation)
      user.save
      user.errors.should     include(:password_confirmation)
      user.reload.password_hash.should_not == User.hash_password('password')
    end

  end

  context '#authorize' do

    before do
      @user = Factory.create :user, is_active: true
    end

    it 'is not active' do
      @user.update_attribute :is_active, false
      User.authorize(@user.login, @user.password).should_not be
    end

    it 'is active' do
      User.authorize(@user.login, @user.password).should be
    end

    it 'is_admin' do
      @user.is_admin?.should_not be
      @user.role = 'admin'
      @user.is_admin?.should be
    end

    it 'does not find a user' do
      user = User.authorize('joe', 'crabshack')
      user.should_not be
    end

  end

  context '#full_search' do

    before do
      3.times {|i| Factory.create :customer, login: "customer_#{i}", name: "Customer User #{i}"}
    end

    it 'finds users by any_of' do
      User.count.should == 3
      User.any_of(login: 'customer_1').length.should == 1
    end

    it 'finds users by full login' do
      User.full_search({login: 'customer_1'}).length.should == 1
    end

    it 'finds users by login or name' do
      users = User.full_search({login: 'customer_1', name: 'Customer User 2'})
      users.length.should == 2
      users.should include(User.first(conditions: {login: 'customer_1'}))
      users.should include(User.first(conditions: {login: 'customer_2'}))
    end

    it 'finds users by partial name' do
      users = User.full_search({name: 'User 2'})
      users.length.should == 1
      users.should include(User.first(conditions: {name: 'Customer User 2'}))
    end

    it 'finds users by full phone' do
      User.all.each_with_index do |user, index|
        user.phones << "231-884-302#{index}"
        user.save
      end
      user_one = User.where(:phones.in => ['231-884-3020']).first
      user_two = User.where(:phones.in => ['231-884-3021']).first
      user_two.phones << '231-884-3020'
      user_two.save

      users = User.full_search({phone: '231-884-3020'})
      users.length.should == 2
      users.should include(user_one)
      users.should include(user_two)
      
      users = User.full_search({phone: '231-884-3021'})
      users.length.should == 1
      users.should include(user_two)
    end

    it 'finds users by partial phone' do
      user_1 = Factory.create :customer, phones: ['231-884-3024']
      user_2 = Factory.create :customer, phones: ['231-884-3306']

      users = User.full_search({phone: '3024'})
      users.length.should == 1
      users.should     include(user_1)
      users.should_not include(user_2)
    end
      

    it 'finds users by full email' do
      User.all.each_with_index do |user, index|
        user.emails << "email#{index}@example.net"
        user.save
      end
      user_one = User.where(:emails.in => ['email0@example.net']).first
      user_two = User.where(:emails.in => ['email1@example.net']).first
      user_two.emails << 'email0@example.net'
      user_two.save

      users = User.full_search({email: 'email0@example.net'})
      users.length.should == 2
      users.should include(user_one)
      users.should include(user_two)
      
      users = User.full_search({email: 'email1@example.net'})
      users.length.should == 1
      users.should include(user_two)
    end

    it 'finds users by partial email' do
      user_1 = Factory.create :customer, emails: ['email1@example.net']
      user_2 = Factory.create :customer, emails: ['email2@example.net']

      users = User.full_search({email: 'mail1'})
      users.length.should == 1
      users.should     include(user_1)
      users.should_not include(user_2)
    end

    it 'finds users by full address' do
      user = Factory.create :customer
      user.addresses.create!({
        address_1:   '1 CIRCLE DR.',
        city:        'CIRCULAR LOGIC',
        province:    'MI',
        postal_code: '49601'
      })
      user.addresses.exists?.should be

      users = User.full_search( { address: {
        address_1:   '1 CIRCLE DR.',
        city:        'CIRCULAR LOGIC',
        province:    'MI',
        postal_code: '49601'
      } } )
      users.length.should == 1
      users.should     include(user)
      users.should_not include(@admin)
    end

    it 'finds users by partial address' do
      user = Factory.create :customer
      user.addresses.create!({
        address_1:   '1 CIRCLE DR.',
        city:        'CIRCULAR LOGIC',
        province:    'MI',
        postal_code: '49601'
      })
      user.addresses.exists?.should be

      users = User.full_search( { address: {
        city:        'CIRcu',
      } } )
      users.length.should == 1
      users.should     include(user)
      users.should_not include(@admin)
    end

  end

  context '#create_from_search_params' do

    it 'creates a new user' do
      user = User.create_from_search_params(name: 'new user')
      user.errors.blank?.should be
      user.new_record?.should_not be
      User.count.should == 1
    end

    it 'does not create a user if one exists' do
      user_1 = Factory.create :customer, name: 'customer user'
      user_2 = User.create_from_search_params(name: 'customer user')
      user_2.should == user_1
      User.count.should == 1
    end

  end

  context 'Financials' do

    before do
    pending 'Need to recalculate expectations'
      @customer = Factory.create :customer

      @item_1 = Factory.create :item
      @item_1.variations << Factory.create(:variation, price: 50.00)

      @item_2 = Factory.create :item
      @item_2.variations << Factory.create(:variation, price: 60.00)

      @order_1  = Factory.create(:order, user: @customer)
      @order_1.line_items << Factory.create(:line_item, variation: @item_1.variations.first, quantity: 1)

      @order_2  = Factory.create(:order, user: @customer)
      @order_2.line_items << Factory.create(:line_item, variation: @item_2.variations.first, quantity: 1)
    end

    context 'Spent Money' do

      it 'spent $50 USD' do
    pending 'Need to recalculate expectations'
        @order_1.purchase
        @customer.total_spent.should == 50.0
      end

      it 'spent $0 USD' do
    pending 'Need to recalculate expectations'
        @customer.total_spent.should == 0.0
      end

    end

    context 'Recieved Credit' do

      before do
    pending 'Need to recalculate expectations'
        @order_1.purchase
        @order_1.add_payment(50)
      end

      it 'recieved no credit' do
    pending 'Need to recalculate expectations'
        @customer.total_credits.should  == 0.0
      end

      it 'recieved a partial credit' do
    pending 'Need to recalculate expectations'
        @order_1.add_payment(-20, 'credit')
        @customer.total_credits.should  == 20.0
        @customer.total_payments.should == 50.0
        @customer.total_balance.should  == -20.0
      end

      it 'recieved a full credit' do
    pending 'Need to recalculate expectations'
        @order_1.add_payment(-50, 'credit')
        @customer.total_credits.should  == 50.0
        @customer.total_payments.should == 50.0
        @customer.total_balance.should  == -50.0
      end
        
      it 'recieved a full credit plus' do
    pending 'Need to recalculate expectations'
        @order_1.add_payment(-150, 'credit')
        @customer.total_credits.should  == 150.0
        @customer.total_payments.should == 50.0
        @customer.total_balance.should  == -150.0
      end

    end

    context 'Paid Off a Debt' do

      it 'paid nothing on an order' do
    pending 'Need to recalculate expectations'
        @order_1.purchase
        @customer.total_payments.should == 0.0
        @customer.total_balance.should  == 50.0
      end

      it 'paid the first half of an order' do
    pending 'Need to recalculate expectations'
        @order_1.purchase
        @order_1.add_payment(25)
        @customer.total_payments.should == 25.0
        @customer.total_balance.should  == 25.0
      end

      it 'paid the second half of an order' do
    pending 'Need to recalculate expectations'
        @order_1.purchase
        @order_1.add_payment(25)
        @customer.total_payments.should == 25.0
        @customer.total_balance.should  == 25.0

        @order_1.add_payment(25)
        @customer.total_payments.should == 50.0
        @customer.total_balance.should  == 0.0
      end

      it 'applied a credit to a partially paid order' do
    pending 'Need to recalculate expectations'
        @order_2.purchase
        @order_2.add_payment(60)
        @order_2.add_payment(-25, 'credit')

        @customer.total_payments.should == 60.0
        @customer.total_credits.should  == 25.0
        @customer.total_balance.should  == -25.0

        @order_1.purchase
        @order_1.add_payment(25)
        @customer.total_payments.should == 85.0
        @customer.total_credits.should  == 25.0
        @customer.total_balance.should  == 0.0

        @order_1.add_payment(25, 'credit')
        @customer.total_payments.should == 110.0
        @customer.total_credits.should  == 25.0
        @customer.total_balance.should  == -25.0
      end

      # TODO: add a pool of credit to each user and test withdrawing from that
      # NOTE: total balance is off because the credits aren't pooled
    
    end

  end

end
