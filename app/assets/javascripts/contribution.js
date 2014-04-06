jQuery(function($) { Stripe.setPublishableKey('pk_test_qnKw7rAklne0KZmRMicBgZEH');})

var stripeResponseHandler = function(status, response) {
	var $form = $('#new_contribution');
	if (response.error) {
	  $form.find('.payment-errors').text(response.error.message);
	  $form.find('button').prop('disabled', false);
	} else {
	  var token = response.id;
	  var currency = response.currency || 'USD';
	  $form.append($('<input type="hidden" name="contribution[stripe_token]" />').val(token));
	  $form.append($('<input type="hidden" name="contribution[stripe_currency]" />').val(currency));
	  // and re-submit
	  $form.get(0).submit();
	}
};

jQuery(function($) {
	$('#new_contribution').submit(function(e) {
	  var $form = $(this);
	  $form.find('button').prop('disabled', true);
	  Stripe.createToken($form, stripeResponseHandler);
	  return false;
	});
});