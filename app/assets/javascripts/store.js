$(document).ready(function() {
  var calculateTax = function(price) {
    var updatePrice = price * 0.09;
    return updatePrice
  }

  var calculateSale = function(price) {
    var salePrice = price * 0.66;
    return salePrice
  }

  var rainbowText = function(item) {
    var angle = 0;
    var p = item[0];
    var text = p.textContent.split('');
    var len = text.length;
    var phaseJump = 360 / len;
    var spans;

    p.innerHTML = text.map(function (char) {
      return '<span>' + char + '</span>';
    }).join('');

    spans = p.children;

    (function wheee () {
      for (var i = 0; i < len; i++) {
        spans[i].style.color = 'hsl(' + (angle + Math.floor(i * phaseJump)) + ', 55%, 70%)';
      }
      angle++;
      requestAnimationFrame(wheee);
    })();
  }

  $('.modal-image-small').click(function() {
    var thisImage = $(this).find('img').attr('src')
    $('.current-modal-image').attr('src', thisImage)
  })

  $('#checkout, #cart-checkout').click(function() {
    // route to update cart
    
    var subTotal = parseInt($('.cart-price').text())
    var tax = calculateTax(subTotal);
    var saleMinus = calculateSale(subTotal);
    $('.cart-tab-tax').text(tax)

    $('.cart-tab-sale').text(saleMinus)
    rainbowText($('.cart-tab-sale').parent())
    var shipping = 5.00
    var total = tax + shipping + saleMinus
    $('.cart-tab-total').text(total)

    var textProd = $('.product-details').text()
    // e.preventDefault();

    // $('.stripe-button').attr('data-amount', total.toString())
    // $('.stripe-button').attr('data-description', textProd)
  })
  
  if( $('#sale-happening').length ) {
    var sale = []
    sale.push(document.getElementById('sale-happening'))
    rainbowText(sale)

    var oldPrices = $('.new-price')

    $.each(oldPrices, function(index, value) {
      var oldPrice = $(value).text()
      var newPrice = calculateSale(oldPrice)
      $(value).text(newPrice)

      rainbowText([value])
    })
  }


  var kaey = $('.stripe-key').data('key')

  var handler = StripeCheckout.configure({
    key: kaey,
    token: function(token, args) {

      var totalPrice = $('.cart-tab-total').text()
      var email = token['email']
      var token = token['id']
      var billing_address_city = args['billing_address_city']
      var billing_address_country = args['billing_address_country']
      var billing_address_country_code = args['billing_address_country_code']
      var billing_address_line1 = args['billing_address_line1']
      var billing_address_zip = args['billing_address_zip']
      var billing_name = args['billing_name']

      var shipping_address_city = args['shipping_address_city']
      var shipping_address_country = args['shipping_address_country']
      var shipping_address_country_code = args['shipping_address_country_code']
      var shipping_address_line1 = args['shipping_address_line1']
      var shipping_address_zip = args['shipping_address_zip']
      var shipping_name = args['shipping_name']

      $.ajax({
        url: "/payment.json",
        type: "GET",
        dataType: "json",
        data: { email: email,
                token: token,
                price: totalPrice,
                billing_address_city: billing_address_city,
                billing_address_country: billing_address_country,
                billing_address_country_code: billing_address_country_code,
                billing_address_line1: billing_address_line1,
                billing_address_zip: billing_address_zip,
                billing_name: billing_name,
                shipping_address_city: shipping_address_city,
                shipping_address_country: shipping_address_country,
                shipping_address_country_code: shipping_address_country_code,
                shipping_address_line1: shipping_address_line1,
                shipping_address_zip: shipping_address_zip,
                shipping_name: shipping_name
                 },
        success: function(data) {
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
          $('.note-text').text("Something didn't work. Try again because we need money.")
          $('.flag.note.notice').slideDown();
            setTimeout(function() {
              $('.flag.note.notice').slideUp();
            }, 5000);
        }
      })
    }
  });


  $('#customButton').on('click', function(e) {
    // Open Checkout with further options
    var cartTotal = $('.cart-tab-total').text()
    var textProd = $('.product-details').text()

    handler.open({
      name: 'The Store',
      description: textProd,
      amount: parseInt(cartTotal)*100,
      shippingAddress: true,
      billingAddress: true
    });
    e.preventDefault();
  });

  $('.add-to-cart').on('click', function () {
    var cart = $('.shopping-cart');
    var imgtodrag = $(this).parent().parent().find('img').eq(0);

    var newCartPrice = $('.cart-price').text()

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

  $('.product-container').hover(function() {
    $(this).find('.hidden-dets').css({opacity: 0.0, visibility: "visible"}).animate({opacity: 1.0});
  }, function() {
    $(this).find('.hidden-dets').css({opacity: 1.0, visibility: "hidden"}).animate({opacity: 0.0});
  })

  // Close Checkout on page navigation
  $(window).on('popstate', function() {
    handler.close();
  });

})