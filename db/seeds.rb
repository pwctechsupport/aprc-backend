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

are_roles = ["admin_reviewer", "admin_preparer", "user"]
are_categories = ["references", "sop", "template", "flowchart"]

are_roles.each do |are|
  Role.create(
    name:are
  )
end

are_categories.each do |x|
  if x == "sop"
    EnumList.create(name: x, category_type: "Category", code: x.upcase)
  else
    EnumList.create(name: x, category_type: "Category", code: x.capitalize)
  end
end

roles = Role.where(name:are_roles).map{|x| x.id}

are_roles.each_with_index do |role, k|
  current_role = roles[k]
  if role.include? "_"
    current_job = role.gsub("_", " ").titlecase
  else
    current_job = role.titlecase
  end
  current_phone = "081231284123#{k}" 
  User.create(
    email:"#{role}@pwc.com",
    name:current_job,
    password:"password", 
    password_confirmation:"password", 
    phone:current_phone,
    status: "release",
    job_position: current_job, 
    role_ids:current_role
  )
end

ConvertTable.run


