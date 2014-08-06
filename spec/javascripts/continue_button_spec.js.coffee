describe 'main form', ->
  beforeEach ->
    setFixtures('<div id="interstitial"></div>' +
      '<form id="_main" data-log-url="/tasks/3/collect_response" action="/tasks/3/next_page">' +
      '<input type="text" id="test" name="u[my_answer]">' +
      '<input id="submit" type="submit" value="Continue">' +
      '</form>')
  describe 'on template page', ->
    beforeEach -> ContinueButton.setup()
    it 'hides the interstitial initially', ->
      ContinueButton.setup()
      expect($('#interstitial')).toBeHidden()
    describe 'when Submit is pressed', ->
      beforeEach ->
        spyOn($, 'ajax').and.callFake(ContinueButton.serverNotified)
        $('#test').val('MyAnswer') # fill in fake user answer
        $(':submit').trigger 'click'
      it 'shows the interstitial', ->
        expect($('#interstitial')).toBeVisible()
      describe 'posts the event via AJAX', ->
        beforeEach ->
          expect($.ajax).toHaveBeenCalled
          @ajax_props = $.ajax.calls.argsFor(0)[0]
        it 'to correct URL', ->
          expect(@ajax_props.url).toEqual '/tasks/3/collect_response'
        it 'with correct form data', ->
          expect(@ajax_props.data).toEqual('u%5Bmy_answer%5D=MyAnswer')
      it 'disables the submit button', ->
        expect($('form#_main :submit')).toBeDisabled()
      
  describe 'on a non-template page', ->
    beforeEach ->
      $('body').addClass('admin')
      ContinueButton.setup()
    it 'does not touch the interstitial', ->
      expect($('#interstitial')).toBeVisible()
