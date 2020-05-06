class Types::Enums::ControlColumns < Types::BaseEnum
  Control.column_names.each {|x| value x, x}
end