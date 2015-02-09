var gmaps = require('eldargab/google-maps')({
  protocol: 'https',
  v: '3'
});

function EventVenueMap(el, props) {
  this.el = el;
  this.props = props;
  this.mapElement = el.querySelector("[data-map]");
  gmaps(this.onGmapsReady.bind(this));
}

EventVenueMap.prototype.onGmapsReady = function(err, api) {
  if (err) {
    console.error(err);
  } else {
    this.googleMaps = api;
    this.geocode();
  }
};

EventVenueMap.prototype.geocode = function() {
  geocoder = new this.googleMaps.Geocoder();
  geocoder.geocode({
    "address": this.props.address,
    "componentRestrictions": {
      "locality": "Melbourne",
      "country": "AU"
    }
  }, this.onGeocode.bind(this));
};

EventVenueMap.prototype.onGeocode = function(results, status) {
  if (status === this.googleMaps.GeocoderStatus.OK) {
    var result = results[0];
    var lat = result.geometry.location.lat();
    var lng = result.geometry.location.lng();

    // Adjust lng slightly
    var adjustment = 0.005 * (this.el.offsetWidth / 1200);
    lng = lng - adjustment;

    var mapOptions = {
      zoom: 16,
      center: new this.googleMaps.LatLng(lat, lng),
      mapTypeId: this.googleMaps.MapTypeId.ROADMAP,
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
    this.map = new this.googleMaps.Map(this.mapElement, mapOptions);
    this.marker = new this.googleMaps.Marker({
      map: this.map,
      position: result.geometry.location
    });
  }
};


module.exports = EventVenueMap;
