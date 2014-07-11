class ChatController < ApplicationController
	def chatpage
		@chat_session = getSession
	end

end