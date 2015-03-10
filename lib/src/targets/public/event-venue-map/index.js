var GoogleMapsLoader = require('google-maps');

function EventVenueMap(el, props) {
  this.el = el;
  this.props = props;
  this.mapElement = el.querySelector("[data-map]");
  GoogleMapsLoader.load(this.onGmapsReady.bind(this));
}

EventVenueMap.prototype.onGmapsReady = function(google) {
  this.google = google;
  this.geocode();
};

EventVenueMap.prototype.geocode = function() {
  geocoder = new this.google.maps.Geocoder();
  geocoder.geocode({
    "address": this.props.address,
    "componentRestrictions": {
      "country": "AU"
    }
  }, this.onGeocode.bind(this));
};

EventVenueMap.prototype.onGeocode = function(results, status) {
  if (status === this.google.maps.GeocoderStatus.OK) {
    var result = results[0];
    var lat = result.geometry.location.lat();
    var lng = result.geometry.location.lng();

    // Adjust lng slightly
    var adjustment = 0.005 * (this.el.offsetWidth / 1200);
    lng = lng - adjustment;

    var mapOptions = {
      zoom: 16,
      center: new this.google.maps.LatLng(lat, lng),
      mapTypeId: this.google.maps.MapTypeId.ROADMAP,
      scrollwheel: false,
      styles: [
    {
        "featureType": "administrative",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "administrative.land_parcel",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "administrative.land_parcel",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#a3dbd2"
            }
        ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#d2ece9"
            }
        ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#a0e3db"
            }
        ]
    },
    {
        "featureType": "poi.attraction",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "poi.business",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
            {
                "lightness": 100
            },
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#80d7ff"
            }
        ]
    }
]
    };
    this.map = new this.google.maps.Map(this.mapElement, mapOptions);
    this.marker = new this.google.maps.Marker({
      map: this.map,
      position: result.geometry.location
    });
  }
};


module.exports = EventVenueMap;
