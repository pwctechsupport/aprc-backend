# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create(
#   email: "bondan@rubyh.co",
#   password: "password",
#   password_confirmation: "password",
#   first_name: "Bondan",
#   last_name: "Herumurti"
# )


Role.create(
  name: "admin"
)

Role.create(
  name: "admin_preparer"
)

Role.create(
  name: "admin_reviewer"
)


roles = Role.all.map{|x| x.id}

z = 0

10.times do |t|
  roles.rotate!
  z+=1
  User.create(
    email:"pwc#{z}@rubyh.co",
    name:"PWC#{z}",
    password:"password", 
    password_confirmation:"password", 
    phone:"0812312841249", 
    job_position:"Head Master", 
    role_ids:[roles.first]
  )
end