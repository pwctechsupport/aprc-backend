class Types::Enums::Category < Types::BaseEnum
  EnumList&.where(category_type: "Category").each do |cat|
    value "#{cat.name}", "#{cat.code}"
  end
end