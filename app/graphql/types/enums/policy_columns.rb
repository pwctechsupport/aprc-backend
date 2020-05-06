class Types::Enums::PolicyColumns < Types::BaseEnum
  Policy.column_names.each {|x| value x, x}
  
end