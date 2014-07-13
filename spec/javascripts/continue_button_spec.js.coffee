describe 'clicking Continue button', ->
  beforeEach ->
    setFixtures('<div id="interstitial">Foo</div><form id="form" data-log-url="/tasks/3/log" action="/tasks/3/next_page"><input id="submit" type="submit" value="Continue"></form>')
  describe 'on a template page', ->
    beforeEach ->
      @theForm = $('#form')
      ContinueButton.setup()
    it 'hides the interstitial initially', ->
      expect($('#interstitial')).toBeHidden()
    it 'shows the interstitial on form submit', ->
      @theForm.trigger 'submit'
      expect($('#interstitial')).toBeVisible()
    it 'inhibits form submission', ->
      spyOnEvent(@theForm, 'submit')
      @theForm.trigger('submit')
      expect('submit').toHaveBeenPreventedOn(@theForm)
    it 'posts the event via AJAX', ->
      spyOn($, 'ajax')
      @theForm.trigger('submit')
      expect($.ajax).toHaveBeenCalled
      ajax_props = $.ajax.calls.argsFor(0)[0]
      expect(ajax_props.url).toEqual '/tasks/3/log'
    it 'disables itself as the handler', ->
      spyOn($, 'ajax')
      @theForm.trigger('submit')
      @theForm.trigger('submit')
      expect($.ajax.calls.count()).toEqual(1)
  describe 'on a non-template page', ->
    beforeEach ->
      $('body').addClass('admin')
      ContinueButton.setup()
    it 'does not touch the interstitial', ->
      expect($('#interstitial')).toBeVisible()
