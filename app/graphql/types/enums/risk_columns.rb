class Types::Enums::RiskColumns < Types::BaseEnum
  Risk.column_names.each {|x| value x, x}
end