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

are_roles = ["admin_reviewer", "admin_preparer", "admin", "user", "staff", "supervisor", "manager", "high_level"]

8.times do 
  Role.create(
    name:are_roles.first
  )
  are_roles.shift
end

roles = Role.all.map{|x| x.id}

z = 0

10.times do
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