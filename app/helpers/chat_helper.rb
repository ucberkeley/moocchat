# Helper that creates a chat-text box

module ChatHelper
  # Produce a chat box widget which will eventually be what determines whether or not a websocket is instantiated
  # form on the page when it expires.
  # The helper emits a +<span>+ with +id="_chat_"+;
  # its *presence on the page* causes a  
  # websocket to be created.  See +chatpage.js.erb+ for the chat code.
  # Only one chat per view is allowed.
  #
  def chat()
    if defined? __chat
      raise "Can only have a single chat per page"
    else
      __chat = true
    end
    render :partial => "chat/chat"
  end
end