describe 'clicking Continue button', ->
  beforeEach ->
    setFixtures('<div id="interstitial">Foo</div><form id="form" data-log-url="/tasks/3/log"><input id="submit" type="submit" value="Continue"></form>')
  describe 'on a template page', ->
    beforeEach ->
      ContinueButton.setup()
    it 'hides the interstitial initially', ->
      expect($('#interstitial')).toBeHidden()
    it 'shows the interstitial on form submit', ->
      $('#form').trigger('submit')
      expect($('#interstitial')).toBeVisible()
    it 'posts the event via AJAX', ->
      spyOn($, 'ajax')
      $('#form').trigger('submit')
      expect($.ajax).toHaveBeenCalled
      ajax_props = $.ajax.calls.argsFor(0)[0]
      expect(ajax_props.url).toEqual '/tasks/3/log'
  describe 'on a non-template page', ->
    beforeEach ->
      $('body').addClass('admin')
      ContinueButton.setup()
    it 'does not touch the interstitial', ->
      expect($('#interstitial')).toBeVisible()
