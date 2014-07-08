describe('clicking Continue button', function() {
  beforeEach(function() {
    setFixtures('<div id="interstitial">Foo</div><form id="form"><input id="submit" type="submit" value="Continue"></form>');
  });
  describe('on a template page', function() {
    beforeEach(function() { ContinueButton.setup(); });
    it('hides the interstitial initially', function() {
      expect($('#interstitial')).toBeHidden();
    });
    it('shows the interstitial on form submit', function() {
      $('#form').trigger('submit');
      expect($('#interstitial')).toBeVisible();
    });
    it('posts an event to be logged', function() {
      flunk('pending');
    });
  });
  describe('on a non-template page', function() {
    beforeEach(function() {
      $('body').addClass('admin');
      ContinueButton.setup();
    });
    it('does not touch the interstitial', function() {
      expect($('#interstitial')).toBeVisible();
    });
  });
});
