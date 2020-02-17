#= require jquery
#= require react
#= require heracles/admin/utils/jquery-ui

###* @jsx React.DOM ###

"use strict"

HeraclesAdmin.views.redirectsController = ($el, el) ->
  # Kick start the React component
  $list = $el.find(".redirects")
  React.renderComponent RedirectsList(), $list[0]

#
# RedirectsFetcher
# - Simple wrapper for handling the AJAX API actions for redirects
#
class RedirectsFetcher
  constructor: ->
    @baseUrl = "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/redirects"
  index: ->
    request = $.ajax
      url: @baseUrl
      dataType: "json"
  show: (id) ->
    request = $.ajax
      url: "#{@baseUrl}/#{id}"
      dataType: "json"
  destroy: (id) ->
    request = $.ajax
      url: "#{@baseUrl}/#{id}"
      type: "delete"
      dataType: "json"
      contentType: "application/json"
  update: (id, data) ->
    request = $.ajax
      url: "#{@baseUrl}/#{id}"
      type: "patch"
      dataType: "json"
      contentType: "application/json"
      data: JSON.stringify(data)
  create: (data) ->
    request = $.ajax
      url: "#{@baseUrl}"
      type: "post"
      dataType: "json"
      contentType: "application/json"
      data: JSON.stringify(data)

#
# RedirectsList React component
#
RedirectsList = React.createClass
  fetcher: new RedirectsFetcher()

  getInitialState: ->
    redirects: []

  componentWillMount: ->
    redirects = []
    request = @fetcher.index()
    request.done (data) =>
      @setState redirects: data.redirects

  componentDidMount: ->
    @el = @getDOMNode()
    @$el = $(@el)
    @$doc = $(@document)
    # Setup
    @setupSortable()
    # Events
    @$el.on "redirects.item.focus", @onItemFocus
    @$el.on "redirects.item.unfocus", @onItemUnfocus

  setupSortable: ->
    @$el.sortable
      axis: "y"
      handle: ".redirects-list-item__sort-handle"
      items: ".redirects-list__li"
      update: @onSortableUpdate

  onSortableUpdate: (e, $ui) ->
    originalPosition = $ui.item.data("original-position")
    newPosition = $ui.item.index()
    redirects = @state.redirects.slice(0)
    redirect = redirects.splice(originalPosition, 1)[0]
    @fetcher.update redirect.id,
      redirect_order_position: newPosition
    redirects.splice(newPosition, 0, redirect)
    @setState redirects: redirects

  onItemFocus: (e, index) ->
    @setState editingItemIndex: index

  onItemUnfocus: (e) ->
    @setState editingItemIndex: null

  addItemAtPosition: (index, e) ->
    e.preventDefault()
    redirects = @state.redirects.slice(0)
    redirects.splice index, 0,
      source_url: "/"
      target_url: "/"
    @setState
      editingItemIndex: index
      redirects: redirects

  requestDeleteItem: (id, index) ->
    redirects = @state.redirects.slice(0)
    index = if index? then index else _.findIndex redirects, (redirect) -> redirect.id is id
    redirects.splice(index, 1)
    # Unmount the component
    # React.unmountComponentAtNode @refs["item#{index}"].getDOMNode()
    @replaceState redirects: redirects

  # For passing data back here from the individual items
  requestUpdateItemData: (index, data) ->
    redirects = @state.redirects.slice(0)
    redirects[index] = data
    @setState redirects: redirects

  formatItems: ->
    requests =
      deleteItem: @requestDeleteItem
      updateItemData: @requestUpdateItemData
    output = if @state.redirects.length > 0
      _this = @
      items = _.map @state.redirects, (redirect, index) ->
        editing = _this.state.editingItemIndex is index
        ref = "item#{index}"
        key = "#{redirect.source_url}-#{redirect.target_url}-#{index}"
        initialAddButton = if index is 0
          `<a href="#add" className="redirects-list__add" onClick={_this.addItemAtPosition.bind(_this, index)}>
            <span className="button button--small button--soft">Add</span>
          </a>`
        else
          ""

        `<li ref={ref} key={key} className="redirects-list__li" data-original-position={index}>
          {initialAddButton}
          <RedirectsListItem fetcher={_this.fetcher} editing={editing} index={index} listElement={_this.$el} data={redirect} requests={requests}/>
          <a href="#add" className="redirects-list__add" onClick={_this.addItemAtPosition.bind(_this, index + 1)}>
            <span className="button button--small button--soft">Add</span>
          </a>
        </li>`
      `<ul>{items}</ul>`
    else
      `<p className="redirects-list__empty">
        No redirects yet — <span/>
        <a href="#add" onClick={this.addItemAtPosition.bind(_this, 0)}>add one now?</a></p>`
    `<div className="redirects-list">
      {output}
    </div>`

  render: ->
    `<div>
      {this.formatItems()}
    </div>`

#
# RedirectsListItem React component
#
RedirectsListItem = React.createClass
  baseClassName: "redirects-list-item"
  cachedData: {}

  componentWillMount: ->
    @cacheData @props.data

  componentDidMount: ->
    @el = @getDOMNode()
    @$el = $(@el)
    @$doc = $(document)
    @$el.on "keyup.redirects.item", (e) => if e.keyCode is 27 then @cancelEditing(e)
    # FIXME this doesn't resolve correctly sometimes, so need the timeout wrapper
    setTimeout(=>
      unless @state.persisted
        $(@refs.sourceUrl.getDOMNode()).trigger "focus"
    , 100)


  componentWillReceiveProps: (nextProps) ->
    @cacheData nextProps.data
    @setState
      data: nextProps.data
      persisted: nextProps.data.id? || false
      saving: false
      editing: nextProps.editing

  getInitialState: ->
    data: @props.data
    editing: false
    saving:  false
    persisted: @props.data.id? || false

  cacheData: (data) ->
    @cachedData =
      source_url: data.source_url
      target_url: data.target_url

  onFocus: (e) ->
    @props.listElement.trigger "redirects.item.focus", @props.index

  onSubmit: (e) ->
    e.preventDefault();
    @save()

  save: (e) ->
    @unfocus()
    @state.data.source_url = @refs.sourceUrl.getDOMNode().value
    @state.data.target_url = @refs.targetUrl.getDOMNode().value
    request = if @state.persisted
      @props.fetcher.update @state.data.id, @state.data
    else
      @props.fetcher.create _.extend {}, @state.data,
        redirect_order_position: @props.index
    request.done(@onSaveDone).fail(@onSaveFail)
    @setState
      data: @state.data
      saving: true
      persisted: true

  onSaveDone: (data) ->
    @props.requests.updateItemData @props.index, data.redirect

  onSaveFail: (error) ->
    @setState saving: false
    # TODO handle errors properly
    for error, message of error.responseJSON.errors
      console?.log "#{error} #{message}"

  delete: (e) ->
    e.preventDefault()
    if confirm("Are you sure?")
      @setState saving: true
      request = @props.fetcher.destroy @state.data.id
      request.done(@onDeleteDone.bind(this, @state.data.id)).fail(@onDeleteFail)

  onDeleteDone: (id) ->
    @props.requests.deleteItem id

  onDeleteFail: (error) ->
    @setState saving: false
    # TODO handle errors properly
    for error, message of error.responseJSON.errors
      console?.log "#{error} #{message}"

  cancelEditing: (e) ->
    e.preventDefault()
    if @state.persisted
      @setState
        editing: false
        data:
          source_url: @cachedData.source_url
          target_url: @cachedData.target_url
      # We need to update input values manually
      @refs.sourceUrl.getDOMNode().value = @cachedData.source_url
      @refs.targetUrl.getDOMNode().value = @cachedData.target_url
      @unfocus()
    else
      @props.requests.deleteItem null, @props.index

  unfocus: ->
    @$el.find("input").trigger "blur"
    @props.listElement.trigger "redirects.item.unfocus"

  formatSourceUrlInput: ->
    className = "#{@baseClassName}__source-url"
    id = "#{className}--#{@props.index}"
    `<div className={className}>
      <label htmlFor={id} className="field-label">Redirect source</label>
      <input className="field-text-input field-mono" onFocus={this.onFocus} ref="sourceUrl" defaultValue={this.props.data.source_url} id={id}/>
    </div>`
  formatTargetUrlInput: ->
    className = "#{@baseClassName}__target-url"
    id = "#{className}--#{@props.index}"
    `<div className={className}>
      <label htmlFor={id} className="field-label">Target</label>
      <input className="field-text-input field-mono" onFocus={this.onFocus} ref="targetUrl" defaultValue={this.props.data.target_url} id={id}/>
    </div>`
  formatControls: ->
    className = "#{@baseClassName}__controls"
    `<div className={className}>
      <button className={"button button--bright " + this.baseClassName + "__save"}>Save redirect</button>
      or
      <a className={this.baseClassName + "__cancel"} href="#cancel" onClick={this.cancelEditing}>discard your changes</a>.
      <button className={"button button--soft button--small " + this.baseClassName + "__delete"} onClick={this.delete}>Delete</button>
    </div>`

  render: ->
    className = @baseClassName
    className += if @state.editing then " #{@baseClassName}--editing" else " #{@baseClassName}--closed"
    className += if @state.saving then " #{@baseClassName}--saving" else ""
    handleClassName = "button button--small #{@baseClassName}__sort-handle"
    `<form className={className} onSubmit={this.onSubmit}>
      <div className={this.baseClassName + "__saving"}>
        <i className="fa fa-refresh"/>
        <span>Saving redirect</span>
      </div>
      <div className={this.baseClassName + "__inputs"}>
        <a className={handleClassName} href="#sort" onMouseDown={this.cancelEditing}><i className="fa fa-arrows"/></a>
        {this.formatSourceUrlInput()}
        {this.formatTargetUrlInput()}
      </div>
      {this.formatControls()}
    </form>`
