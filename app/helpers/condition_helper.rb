module ConditionHelper
	def array_for(things)
		things.to_a.map { |id| Template.find_by_id(id) }.compact
	end
end