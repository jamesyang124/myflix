require 'faker'

module UserSeeds
  def self.create_user
    2.times do 
      User.create(users_data)
    end
  end

private

  def self.users_data
    {
      email: Faker::Internet.email,
      full_name: Faker::Name.name,
      password: "123456789"
    }
  end

end