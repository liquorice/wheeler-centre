#= require react
#= require jquery
#= require lodash
#= require momentjs

###* @jsx React.DOM ###

window.FieldContentInlineEditor = React.createClass
  getDefaultProps: ->
    withForm: true
    data: {}
  componentDidMount: ->
    @_initAssetSelector()
    @_initPageSelector()
  render: ->
    className = "field-content-editor__inline-editor field-content-editor__inline-editor--#{@props.type}"
    if @props.type is "link"
      editor = `<div className={className}>
        <div className="inline-editor-group">
          <div className="inline-editor-group__item">
            <input ref="href" onChange={this._onHrefChange} className="field-text-input field-mono field-small" defaultValue={this.props.data.href} placeholder="Enter a URL"/>
          </div>
        </div>
        <div className="inline-editor-group__divider"><span>or</span></div>
        <div className="inline-editor-group">
          <div className="inline-editor-group__item">
            <input ref="pageID" type="hidden" className="field-select2 field-select2--small" defaultValue={this.props.data.pageID}/>
          </div>
        </div>
        <div className="inline-editor-group__divider"><span>or</span></div>
        <div className="inline-editor-group inline-editor-group--asset">
          <div className="inline-editor-group__item">
            <input ref="assetID" type="hidden" className="field-select2 field-select2--small" defaultValue={this.props.data.assetID}/>
          </div>
        </div>
        <div className="inline-editor-group">
          <div className="inline-editor-group__item">
            <input ref="title" className="field-text-input field-small" onChange={this._onTitleChange} defaultValue={this.props.data.title} placeholder="Title or hint text"/>
          </div>
          <div className="inline-editor-group__item">
            <select ref="target" defaultValue={this.props.data.target} onChange={this._onTargetChange} className="field-select field-small">
              <option value="">Open in current tab</option>
              <option value="_blank">Open in new tab</option>
            </select>
          </div>
        </div>
      </div>`
    if @props.withForm == true
      `<form onSubmit={this._onSubmit}>
        {editor}
        <div className="inline-editor-actions">
          <button className="button button--small button--soft">Save link</button>
        </div>
      </form>`
    else
      return editor
  # Collate the data, fire the callback
  _onSubmit: (e) ->
    e?.preventDefault()

    data =
      href:   @refs.href.getDOMNode().value
      title:  @refs.title.getDOMNode().value
      target: @refs.target.getDOMNode().value

    assetID = @refs.assetID.getDOMNode().value
    unless _.isEmpty(assetID)
      data.assetID = assetID
    pageID = @refs.pageID.getDOMNode().value
    unless _.isEmpty(pageID)
      data.pageID = pageID
    @props.callback @props.type, data

  _onHrefChange: (e) ->
    @$assetInput.select2 "val", ""
    @$pageInput.select2  "val", ""
    unless @props.withForm then @_onSubmit(null)

  _onTitleChange: (e) ->
    unless @props.withForm then @_onSubmit(null)

  _onTargetChange: (e) ->
    unless @props.withForm then @_onSubmit(null)

  _initAssetSelector: ->
    @$assetInput = $(this.refs.assetID.getDOMNode())
    @$assetInput.select2
      allowClear: true
      placeholder: "Link to an asset"
      ajax:
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets"
        dataType: "json"
        data: (term, page) ->
          q: term
          page: page
        results: (data, page) ->
          results: data.assets
          more: data.more
      # Handle the initial selection
      initSelection: (element, callback) =>
        if @props.data.assetID?
          request = $.ajax
            url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets/#{@props.data.assetID}"
            dataType: "json"
          request.done (data) -> callback data.asset

      # Format the dropdown
      formatResult: (asset) ->
        formattedDate = moment(asset.created_at).fromNow()
        """
          <div class="select2-result__primary">
            #{asset.file_name}
            <div>#{formattedDate}</div>
          </div>
        """
      # Don't try to escape markup since we're returning HTML
      escapeMarkup: (m) -> m
      # Format the display value when selected
      formatSelection: (asset) ->
        """
          <div class="select2-selection__primary">
            #{asset.file_name}
          </div>
        """
    # Manually trigger change
    @$assetInput.on "change", @_onAssetSelection

  _onAssetSelection: (e) ->
    # Clear out the href
    @refs.href.getDOMNode().value = ""
    @$pageInput.select2 "val", ""
    unless @props.withForm then @_onSubmit(null)

  _initPageSelector: ->
    @$pageInput = $(this.refs.pageID.getDOMNode())
    @$pageInput.select2
      allowClear: true
      placeholder: "Link to a page"
      ajax:
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/pages"
        dataType: "json"
        data: (term, page) ->
          q: term
          page: page
        results: (data, page) ->
          results: data.pages
          more: data.more
      # Handle the initial selection
      initSelection: (element, callback) =>
        if @props.data.pageID?
          request = $.ajax
            url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/pages/#{@props.data.pageID}"
            dataType: "json"
          request.done (data) -> callback data.page

      # Format the dropdown
      formatResult: (page) ->
        """
          <div class="select2-result__primary">
            #{page.title} <span class="field-mono">/#{page.url}</span>
          </div>
        """
      # Don't try to escape markup since we're returning HTML
      escapeMarkup: (m) -> m
      # Format the display value when selected
      formatSelection: (page) ->
        """
          <div class="select2-selection__primary">
            #{page.title} <span class="field-mono">/#{page.url}</span>
          </div>
        """
    # Manually trigger change
    @$pageInput.on "change", @_onPageSelection

  _onPageSelection: (e) ->
    # Clear out the href
    @refs.href.getDOMNode().value = ""
    @$assetInput.select2 "val", ""
    unless @props.withForm then @_onSubmit(null)
