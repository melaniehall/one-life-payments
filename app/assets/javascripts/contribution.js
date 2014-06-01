jQuery(function($) { Stripe.setPublishableKey('pk_test_qnKw7rAklne0KZmRMicBgZEH');})

var stripeResponseHandler = function(status, response) {
	var $form = $('#new_contribution');
	if (response.error) {
	  $form.find('.payment-errors').text(response.error.message);
  	  $form.find('button').prop('disabled', false).removeClass('disabled');
  	  hideLoading();
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

function revealLoading(){
 	$('.loading').fadeIn();
  var elem = $('.loading .inner-content');
  var count = 0;
   myCounter = setInterval(function () {
    count++;
    if (count < 3){
      elem.append('.');
    }else{
    	elem.html('Processing');
      count = 0;
    }
  }, 600);
}

function hideLoading(){
 	$('.loading').fadeOut();
}

jQuery(function($) {
	$('#new_contribution').submit(function(e) {
		$('#errorExplanation').html("");
		var firstName = $('#contribution_first_name').val()
		var lastName = $('#contribution_last_name').val()
		var emailAddress = $('#contribution_email').val()
		var giftAmount = $('#contribution_amount').val()
		if (!firstName || !lastName || !emailAddress || !giftAmount){
			$('.validation-errors').html('*All fields are required')
			clearInfo()
			return false
		}else{
		  var $form = $(this);
		  $form.find('button').prop('disabled', true).addClass('disabled');
			revealLoading();
		  Stripe.createToken($form, stripeResponseHandler);
		  return false;
		}
	});
});