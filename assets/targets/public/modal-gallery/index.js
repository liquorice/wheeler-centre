var arrival = require("arrival");
var domify = require("domify");
var viewloader = require("viewloader");
var Flickity = require("flickity");
var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function modalGallery(slides) {
  // Create holding element
  var gallery;
  var wrapper;
  var closeButton;
  var initialised = false;

  function init() {
    wrapper = domify(
      '<div tabindex="0" class="gallery-slider gallery-slider--closed"></div>'
    );
    closeButton = domify('<button class="gallery-slider__close"><svg viewBox="0 0 100 100"><path d="M50 60l-40 40-10-10 40-40-40-40 10-10 40 40 40-40 10 10-40 40 40 40-10 10-40-40z" fill="none"/></svg></button>');
    wrapper.appendChild(closeButton);

    // Create each individual slide
    slides.forEach(function(slide) {
      wrapper.appendChild(createSlide(slide));
    });

    // Append to the body
    document.body.appendChild(wrapper);

    // Enact Flickity
    gallery = new Flickity(wrapper, {
      cellSelector: ".gallery-slide",
      lazyLoad: 2,
      wrapAround: true
    });

    // Apply views
    viewloader.execute(
      {
        // responsiveEmbed: responsiveEmbed
      },
      wrapper
    );

    initialised = true;
    wrapper.focus();
  }

  /**
   * Destroy the gallery
   */
  function destroy() {
    gallery.destroy();
  }

  function open(index, instant) {
    if (!initialised) {
      init();
    } else {
      document.body.appendChild(wrapper);
    }
    // Remove the hidden class
    window.requestAnimationFrame(function() {
      removeClass(wrapper, "gallery-slider--closed");
    });

    // Bind listeners
    wrapper.addEventListener("keydown", onKeyDown);
    closeButton.addEventListener("click", onCloseClick);

    // Go to slide index
    if (index != null) {
      gallery.select(index, true, instant);
    }
  }

  /**
   * Close the gallery and then destroy it
   */
  function close(destroyOnClose) {
    destroyOnClose = destroyOnClose != null ? destroyOnClose : false;
    wrapper.removeEventListener("keydown", onKeyDown);
    closeButton.removeEventListener("click", onCloseClick);
    addClass(wrapper, "gallery-slider--closed");
    arrival(wrapper, function() {
      wrapper.parentNode.removeChild(wrapper);
      if (destroyOnClose) {
        destroy();
      }
    });
  }

  /**
   * Handle the keydown event
   */
  function onKeyDown(e) {
    if (e.keyCode === 27) {
      close();
    }
  }

  /**
   * Handle the close click
   */
  function onCloseClick(e) {
    e.preventDefault();
    close();
  }

  /**
   * Expose public API
   */
  return {
    open: open,
    close: close,
    destroy: destroy
  };
}

module.exports = modalGallery;

function createSlide(slide) {
  return slide.image ? createImageSlide(slide) : createHTMLSlide(slide);
}

function createImageSlide(slide) {
  return wrapped(
    slide,
    domify(
      '<img class="gallery-slide__content gallery-slide__content--image" data-flickity-lazyload="' + slide.image + '"/>'
    )
  );
}

function createHTMLSlide(slide) {
  var responsiveWrapper = domify(
    '<div class="gallery-slide__content gallery-slide__content--html"></div>'
  );
  responsiveWrapper.appendChild(domify(slide.html));
  return wrapped(slide, responsiveWrapper);
}

function wrapped(slide, content) {
  var wrapper = domify('<div class="gallery-slide"></div>');
  var inner = domify('<div class="gallery-slide__inner"></div>');
  inner.appendChild(content);
  if (slide.caption) {
    var caption = domify(
      '<p class="gallery-slide__caption">' + slide.caption + '</p>'
    );
    inner.appendChild(caption);
  }
  wrapper.appendChild(inner);
  return wrapper;
}
