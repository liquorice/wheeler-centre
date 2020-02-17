#= require lodash
#= require react

###* @jsx React.DOM ###

Lightbox = React.createClass
  removeComponent: ->
    # Remove component
    React.unmountComponentAtNode @props.container
  componentDidMount: ->
    @$window = $(window)
    @$doc = $(document)
    @$body = $("body")
    speed = if @$window.scrollTop() > 600 then 300 else 150
    @$body.animate(
      scrollTop: 0
    , speed)
    $(@refs.lightbox.getDOMNode()).css(opacity: 0).fadeTo(300, 1)
    unless @props.closeOnEscape is false
      @$doc.on "keyup.lightbox", (e) =>
        if e.keyCode is 27 then @closeLightbox(e)

  closeLightbox: (e) ->
    e?.preventDefault()
    $(@refs.lightbox.getDOMNode()).fadeTo 200, 0, =>
      @removeComponent()
      @$doc.trigger("lightbox.closed").off "keyup.lightbox"

  handleClick: (e) ->
    $targ = $ e.target
    @closeLightbox() if $targ.parent().is '.lightbox-contents' or $targ.is '.lightbox-contents'

  render: ->
    # Pass through the close
    @props.obj.api =
      closeLightbox: @closeLightbox
    # Create a new pageType based off the passed string
    component = @props.component(@props.obj)
    className = "lightbox-container lightbox-container--#{@props.type}"
    `<div ref="lightbox" className={className} onClick={this.handleClick}>
      <div className="lightbox-contents">
        {component}
      </div>
      <a href="#" className="lightbox__close" onClick={this.closeLightbox}>&times;</a>
      <div className="lightbox-cover" />
    </div>`

# Singleton class for storing and accessing the React field components
# Each field needs to define a `formatProps` method
class AvailableLightboxes
  constructor: ->
    @lightboxes = []
  add: (lightbox) ->
    @lightboxes.push(lightbox)
  get: (lightboxType) ->
    for lightbox in @lightboxes
      if lightbox.type is lightboxType
        return lightbox
  helper: (type, obj) ->
    target = $('<div class="lightbox">').appendTo $('body')
    React.renderComponent Lightbox(
        container: target[0]
        component: @get(type).component
        type: type
        obj: obj
        closeOnEscape: @get(type).closeOnEscape
      ), target[0]

# Attach the instance to the app object
HeraclesAdmin.availableLightboxes = new AvailableLightboxes()
