module QuestionHelper
	def sanitize_str(elm)
	  elm.gsub(/ (?= )/, '&nbsp;').html_safe	
   end
   def arr_sanitize(elm)
   	elm.each do |val|
   		val.gsub(/ (?= )/, '&nbsp;').html_safe
   	end
   	elm
   end
end
