class ConvertName
  
  def self.raw(stringish)
    stringish.to_s.html_safe
  end

  def self.safe_join(array, sep = $,)
    sep = ERB::Util.unwrapped_html_escape(sep)
  
    array.flatten.map! { |i| ERB::Util.unwrapped_html_escape(i) }.join(sep).html_safe
  end
end