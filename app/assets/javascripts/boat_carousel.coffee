$.fn.extend
  boatCarousel: ->
    $(@).slick
      infinite: true
      adaptiveHeight: true
      lazyLoad: 'ondemand'
      slidesToShow: 2
      slidesToScroll: 1
      autoplay: true
      autoplaySpeed: 5000
      dots: true
      variableWidth: true
