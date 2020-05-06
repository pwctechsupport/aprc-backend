class Types::Enums::PolicyCategoryColumns < Types::BaseEnum
  PolicyCategory.column_names.each {|x| value x, x}
  
end