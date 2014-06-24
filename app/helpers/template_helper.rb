# Helper that creates a JS timer and, when it's counted down, causes
# submission of the one and only form on this page

module TemplateHelper
  # Produce a JavaScript timer that counts down from +seconds+ and submits the first (only)
  # form on the page when it expires.
  # The helper emits a <span> with id="_timer_"; its *presence on the page* causes a 
  # Timer to be started.  See +timer.js+ for the timer code.
  # Only one timer per view is allowed.
   def timer(seconds)
    if defined? timer
      raise "Can only have a single timer per template"
    else
      timer = true
    end
    %Q{<span id="_timer_" data-countfrom="<%= seconds.to_i %>"></span>}
  end
end
