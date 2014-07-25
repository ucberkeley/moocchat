describe 'main form', ->
  beforeEach ->
    setFixtures('<div id="interstitial"></div>' +
      '<form id="_main" data-log-url="/tasks/3/log" action="/tasks/3/next_page">' +
      '<input id="submit" type="submit" value="Continue">' +
      '</form>')
  describe 'on template page', ->
    it 'hides the interstitial initially', ->
      ContinueButton.setup()
      expect($('#interstitial')).toBeHidden()
    describe 'when Submit is pressed', ->
      beforeEach ->
        ContinueButton.setup()
        spyOn($, 'ajax').and.callFake(ContinueButton.serverNotified)
        $(':submit').trigger 'click'
      it 'shows the interstitial', ->
        expect($('#interstitial')).toBeVisible()
      it 'posts the event via AJAX', ->
        expect($.ajax).toHaveBeenCalled
        ajax_props = $.ajax.calls.argsFor(0)[0]
        expect(ajax_props.url).toEqual '/tasks/3/log'
      it 'disables the submit button', ->
        expect($('form#_main :submit')).toBeDisabled()
      
  describe 'on a non-template page', ->
    beforeEach ->
      $('body').addClass('admin')
      ContinueButton.setup()
    it 'does not touch the interstitial', ->
      expect($('#interstitial')).toBeVisible()
