# Helper that creates a chat-text box

module TaskHelper
  # Produce a chat box widget which will eventually be what determines whether or not a websocket is instantiated
  # form on the page when it expires.
  # The helper emits a +<span>+ with +id="_chat_"+;
  # its *presence on the page* causes a  
  # websocket to be created.  See +chatpage.js.erb+ for the chat code.
  # Only one chat per view is allowed.
  #
  def vote
    if defined? __vote
      raise "Can only have a single vote per page"
    else
      __vote = true
    end
    render :partial => "tasks/vote"
  end

  def time_filler(condition)
    if defined? __time_filler
      raise "Can only have a single timer_filler per page"
    elsif condition.time_filler == nil or condition.time_filler.questions.length < 1
      return #raise "pass in proper questions"
    else
      __time_filler = true
      @questions = condition.time_filler.questions
    end
    render :partial => "tasks/time_filler"
  end

end
