#= require lodash
#= require react
#= require jquery

#= require heracles/admin/lightboxes/lightbox

###* @jsx React.DOM ###

PageTypeLightbox = React.createClass
  render: ->
    links = $('<div>').append(@props.links).html()
    `<div className="page-type-lightbox">
      <p className="lightbox-title">Select a page type</p>
      <span dangerouslySetInnerHTML={{__html: links}} />
    </div>`


# Register as available
HeraclesAdmin.availableLightboxes.add
  type: "PageTypeLightbox"
  component: PageTypeLightbox


class PageTypeSelector
  constructor: ($el) ->
    @$outer_link = @makeLink($el)
    @bindEvents()
  makeLink: ($el) ->
    @$links = $('a', $el).remove()
    $el.wrap('<a href="#">').parent()
  bindEvents: ->
    @$outer_link.on "click", (e) =>
      e.preventDefault()
      HeraclesAdmin.availableLightboxes.helper 'PageTypeLightbox', links: @$links

HeraclesAdmin.views.pageTypeSelector = ($el) -> new PageTypeSelector $el


