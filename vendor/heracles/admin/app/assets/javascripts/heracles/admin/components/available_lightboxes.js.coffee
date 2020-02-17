# Singleton class for storing and accessing the React field components
# Each field needs to define a `formatProps` method
class AvailableLightboxes
  constructor: ->
    @lightboxes = []
  add: (lightbox) ->
    @lightboxes.push(lightbox)
  get: (lightboxName) ->
    for lightbox in @lightboxes
      if lightbox.name is lightboxName
        return lightbox.component

# Attach the instance to the app object
HeraclesAdmin.availableLightboxes = new AvailableLightboxes()
