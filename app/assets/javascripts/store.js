$(document).ready(function() {
  var calculateTax = function(price) {
    var updatePrice = price * 0.09;
    return updatePrice
  }

  $('#checkout').click(function() {
    // route to update cart
    var subTotal = parseInt($('.cart-tab-price').text())
    var tax = calculateTax(subTotal);
    $('.cart-tab-tax').text(tax)
    var shipping = 5.00
    var total = subTotal + tax + shipping
    $('.cart-tab-total').text(total)

    var textProd = $('.product-details').text()

    // $('.stripe-button').attr('data-amount', total.toString())
    // $('.stripe-button').attr('data-description', textProd)
  })

  var kaey = $('.hidden.stripe-key').text()
  var handler = StripeCheckout.configure({
    key: kaey,
    token: function(token) {
      // Use the token to create the charge with a server-side script.
      // You can access the token ID with `token.id`
    }
  });

  $('#customButton').on('click', function(e) {
    // Open Checkout with further options
    var cartTotal = $('.cart-tab-total').text()
    var textProd = $('.product-details').text()

    handler.open({
      name: 'The Store',
      description: textProd,
      amount: parseInt(cartTotal)*100
    });
    e.preventDefault();
  });

  // Close Checkout on page navigation
  $(window).on('popstate', function() {
    handler.close();
  });


})