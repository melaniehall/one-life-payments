jQuery(function($) { Stripe.setPublishableKey('pk_test_qnKw7rAklne0KZmRMicBgZEH');})

var stripeResponseHandler = function(status, response) {
	var $form = $('#new_contribution');
	if (response.error) {
	  $form.find('.payment-errors').text(response.error.message);
	  $form.find('button').prop('disabled', false);
	} else {
	  var token = response.id;
  	// var currency = response.currency || 'USD';
	  $form.append($('<input type="hidden" name="contribution[stripe_token]" />').val(token));
	  clearInfo();
	  $form.get(0).submit();
	}
};

function clearInfo(){
	  $('#new_contribution input').each(function(){
	  	if ($(this).data('stripe')){
	  		$(this).val('');
	  	}
	  });
};

jQuery(function($) {
	$('#new_contribution').submit(function(e) {
		var firstName = $('#contribution_first_name').val()
		var lastName = $('#contribution_last_name').val()
		var emailAddress = $('#contribution_email').val()
		if (!firstName || !lastName || !emailAddress){
			$('.validation-errors').html('*All fields are required')
			clearInfo()
			return false
		}else{
		  var $form = $(this);
		  $form.find('button').prop('disabled', true);
		  Stripe.createToken($form, stripeResponseHandler);
		  return false;
		}
	});
});