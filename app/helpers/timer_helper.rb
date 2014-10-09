# Helper that creates a JS timer and, when it's counted down, causes
# submission of the one and only form on this page

module TimerHelper
  # Produce a JavaScript timer that counts down from +seconds+ and submits the first (only)
  # form on the page when it expires.
  # The helper emits a +<span>+ with +id="_timer_"+;
  # its *presence on the page* causes a  
  # Timer to be started.  See +timer.js+ for the timer code.
  # Only one timer per view is allowed.
  #
  # ==== Options
  # * +:seconds+ - number of seconds to count down from.  If not given uses value of +@timer+ variable
  # * +:submit+ - a URL that will be fetched via GET (replacing the current page) when the timer expires.  If absent, the one and only form on the page will be submitted via POST.
  def timer(seconds=@timer, opts = {})
    if defined? __timer
      raise "Can only have a single timer per template"
    else
      __timer = true
    end

    if @offset and seconds
      seconds = seconds - @offset
    end

    attribs = {'id' => '_timer_',
      'class' => 'timer',
      'data-countfrom' => seconds.to_i,
      'data-submit' => opts[:submit]}
    # if only previewing a template, disable timer counting
    attribs['id'] = '_timer_test' if @preview
    content_tag 'span', '00:00', attribs
  end
end
