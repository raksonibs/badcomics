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

  var kaey = $('.stripe-key').data('key')
  console.log('4242 4242 4242 4242')

  var handler = StripeCheckout.configure({
    key: kaey,
    token: function(token) {

      var totalPrice = $('.cart-tab-total').text()
      console.log('test-token')
      console.log(token)
      var email = token['email']
      var token = token['id']
      $.ajax({
        url: "/payment.json",
        type: "GET",
        dataType: "json",
        data: { email: email,
                token: token,
                price: totalPrice },
        success: function(data) {
          console.log('success')
          // $('#checkout-tab').foundation('reveal', 'close');
          var audioMoney = new Audio('/assets/money.mp3')
          audioMoney.play();
          $('.conf-cont').css('z-index', '10000')
          $('.container-notifications').css('z-index', '10000')
          $('.conf-cont').fadeIn().next().delay(5000).fadeOut();
          $('.success-text').text("We all love money in da bank. Tanx.")

          $('.flag.note.success').slideDown();

          setTimeout(function() {
            $('.flag.note.success').slideUp();
            $('.conf-cont').fadeOut();
            audioMoney.pause()
          }, 10000);
        },
        error: function(data) {
          console.log('error')
          $('.note-text').text("Something didn't work. Try again because we need money.")
          $('.flag.note.notice').slideDown();
            setTimeout(function() {
              $('.flag.note.notice').slideUp();
            }, 5000);
        }
      })
    }
  });

console.log('test-store')

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

  $('.add-to-cart').on('click', function () {
    var cart = $('.shopping-cart');
    var imgtodrag = $(this).parent().find('img').eq(0);
    if (imgtodrag) {
      var imgclone = imgtodrag.clone()
      .offset({
        top: imgtodrag.offset().top,
        left: imgtodrag.offset().left
      })
      .css({
        'opacity': '0.5',
        'position': 'absolute',
        'height': '150px',
        'width': '150px',
        'z-index': '100'
      })
      .appendTo($('body'))
      .animate({
        'top': cart.offset().top + 10,
        'left': cart.offset().left + 10,
        'width': 75,
        'height': 75
      }, 1000);

      setTimeout(function () {
        cart.addClass('shake')
      }, 1500);

      cart.removeClass('shake')

      imgclone.animate({
        'width': 0,
        'height': 0
      }, function () {
        $(this).detach()
      });
    }
  });

  $('.product-container img').hover(function() {
    $(this).parent().parent().find('.hidden-dets').css('visibility','visible').hide().fadeIn('slow');
  }, function() {
    $(this).parent().parent().find('.hidden-dets').css('visibility','hidden')
  })

  // Close Checkout on page navigation
  $(window).on('popstate', function() {
    handler.close();
  });

})