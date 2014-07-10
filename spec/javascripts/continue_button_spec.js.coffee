describe 'clicking Continue button', ->
  beforeEach ->
    setFixtures('<div id="interstitial">Foo</div><form id="form"><input id="submit" type="submit" value="Continue"></form>')
  describe 'on a template page', ->
    beforeEach ->
      ContinueButton.setup()
    it 'hides the interstitial initially', ->
      expect($('#interstitial')).toBeHidden()
    it 'shows the interstitial on form submit', ->
      $('#form').trigger('submit')
      expect($('#interstitial')).toBeVisible()
    it 'posts an event to be logged', ->
      spyOn($, 'ajax').andReturn(true)
      $('#form').trigger('submit')
      expect($.ajax).toHaveBeenCalled()
  describe 'on a non-template page', ->
    beforeEach ->
      $('body').addClass('admin')
      ContinueButton.setup()
    it 'does not touch the interstitial', ->
      expect($('#interstitial')).toBeVisible()
