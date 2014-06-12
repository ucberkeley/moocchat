class EventLog < ActiveRecord::Base
	belongs_to :task
    serialize :value, JSON
   	attr_accessible  :value

   	#takes the incoming key, converts to string, and sets the value accordingly to the huge "value" JSON object
   	def log(key,value)
   		self.value[key.to_s]=value 
   	end

end
