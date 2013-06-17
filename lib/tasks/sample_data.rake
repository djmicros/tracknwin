namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
				 gender: "M",
				 birthdate: "1991-04-27",
				 country: "Poland",
				 team: "Mbike Agang Team")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
	  gender = "M"
	  birthdate = "1991-04-27"
	  country = "Poland"
	  team = "Mbike Agang Team"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
				   gender: gender,
				   birthdate: birthdate,
				   country: country,
				   team: team)
    end
  end
end