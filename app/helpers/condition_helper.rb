module ConditionHelper
	def array_for(obj)
		arr = Array.new
		if obj != nil
			obj.each do |val|
		        if val.empty?
		        else
		          arr.push(Template.find_by_id(val))
		        end
	      	end
	     end
      	return arr
	end
end