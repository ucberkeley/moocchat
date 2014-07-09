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
   def array_for(things)
		things.to_a.map { |id| Question.find_by_id(id) }.compact
	end
end