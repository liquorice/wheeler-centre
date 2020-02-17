#= require lodash
#= require react
#= require jquery

#= require heracles/admin/lightboxes/lightbox

###* @jsx React.DOM ###

AssetDetailsMetaDataFieldLightbox = React.createClass

  render: ->

    props = @props

    if props.value
      `<p className="lightbox-asset__details__data-field">
        <b className="lightbox-asset__details__data-title">{props.title}</b>
        {props.value}
      </p>`
    else
      # Starting from React 0.11.0 you are free to return null.
      `<div/>`


AssetDetailsMetaDataLightbox = React.createClass

  render: ->

    props = @props
    asset = @props.asset
    style =
      display: (if props.visibility.data then 'block' else 'none')

    if asset.title || asset.description || asset.attribution || asset.tag_list.length > 0
      `<div style={style} className="lightbox-asset__details__data">
        <AssetDetailsMetaDataFieldLightbox title="Title" value={asset.title} />
        <AssetDetailsMetaDataFieldLightbox title="Description" value={asset.description} />
        <AssetDetailsMetaDataFieldLightbox title="Attribution" value={asset.attribution} />
        <AssetDetailsMetaDataFieldLightbox title="Tags" value={asset.tag_list.join(window.HeraclesAdmin.options.tagDelimiter)} />
      </div>`
    else
      `<div/>`



formatTagSelection = (tag) ->
  if tag.count > 0
    """<span class="field-mono">&nbsp;(#{tag.count})</span>"""
  else if tag.count is 0
    """<span class="field-mono">&nbsp;(new)</span>"""
  else
    ""

AssetDetailsMetaFormLightbox = React.createClass
  render: ->

    _this = @
    props = @props
    asset = @props.asset
    style =
      display: (if props.visibility.form then 'block' else 'none')

    `<form style={style} className="lightbox-asset__details__data" onSubmit={_this._onSubmit}>
      <p className="lightbox-asset__details__data-field">
        <b className="lightbox-asset__details__data-title">Title</b>
        <input type="text" defaultValue={asset.title} ref="formTitle" className="lightbox-asset__details__data-input" />
      </p>
      <p className="lightbox-asset__details__data-field">
        <b className="lightbox-asset__details__data-title">Description</b>
        <textarea defaultValue={asset.description} ref="formDescription" className="lightbox-asset__details__data-area" />
      </p>
      <p className="lightbox-asset__details__data-field">
        <b className="lightbox-asset__details__data-title">Attribution</b>
        <input type="text" defaultValue={asset.attribution} ref="formAttribution" className="lightbox-asset__details__data-input" />
      </p>
      <p className="lightbox-asset__details__data-field">
        <b className="lightbox-asset__details__data-title">Tags</b>
        <input type="hidden" defaultValue={asset.tag_list.join(window.HeraclesAdmin.options.tagDelimiter)} ref="formTags" className="field-select2 lightbox-asset__details__data-input" />
      </p>
      <p className="lightbox-asset__details__data-field">
        <button className="button button--soft button--small">Save metadata</button>
      </p>
    </form>`

  componentDidMount: ->

    $(@refs.formTags.getDOMNode()).select2
      tags: true
      multiple: true
      separator: window.HeraclesAdmin.options.tagDelimiter
      tokenSeparators: [window.HeraclesAdmin.options.tagDelimiter]
      # Dynamically create a choice even though we're loading AJAX data
      createSearchChoice: (term, data) ->
        matches = $(data).filter -> this.text?.localeCompare(term) is 0
        if (matches.length is 0)
          id: term,
          name: term
          count: 0
      ajax:
        transport: (params) ->
          callback = params.success
          params.success = (data, textStatus, jqXHR) ->
            callback {
              data: data,
              perPage: jqXHR.getResponseHeader('Per-Page')
              total: jqXHR.getResponseHeader('Total')
            }, textStatus, jqXHR
          $.ajax(params)
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/tags"
        dataType: "json"
        data: (term, page) ->
          q: term
          page: page
        results: (response, page, xhr) ->
          # We don't want to set actual IDs, just tag names
          results: _.map response.data.tags, (tag) ->
            tag.id = tag.name
            tag
          more: (page * response.perPage < response.total)
      initSelection: (element, callback) =>
        tags = _.map element.val().split(window.HeraclesAdmin.options.tagDelimiter), (tag) -> {id: tag, name: tag}
        callback tags
      # Format the dropdown
      formatResult: (tag) ->
        """
          <div class="select2-result__primary">
            #{tag.name}#{formatTagSelection(tag)}
          </div>
        """
      # Don't try to escape markup since we're returning HTML
      escapeMarkup: (m) -> m
      # Format the display value when selected
      formatSelection: (tag) ->
        """
          <div class="select2-result__primary">
            #{tag.name}
          </div>
        """

  _onSubmit: (e) ->

    e.preventDefault()

    props = @props
    props.asset.title = @refs.formTitle.getDOMNode().value
    props.asset.description = @refs.formDescription.getDOMNode().value
    props.asset.attribution = @refs.formAttribution.getDOMNode().value
    props.asset.tag_list = @refs.formTags.getDOMNode().value.split(window.HeraclesAdmin.options.tagDelimiter)

    $.ajax
      url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets/#{props.asset.id}"
      type: "patch"
      dataType: "json"
      contentType: "application/json"
      data: JSON.stringify(
        title: props.asset.title
        description: props.asset.description
        attribution: props.asset.attribution
        tag_list: props.asset.tag_list
      )
      success: () ->
        props.onEdit()

    false


AssetDetailsMetaLightbox = React.createClass

  getInitialState: ->
    visibility:
      data: true
      form: false

  render: ->

    _this = @
    asset = @props.asset

    `<p className="lightbox-asset__details__title lightbox-asset__details__outer-title lightbox-asset__details__border-title">
      <a className="lightbox-asset__details__title-edit" href="#" onClick={_this._onEdit.bind(this, asset)}>{(_this.state.visibility.form) ? 'Cancel edit' : 'Edit metadata'}</a>
      Metadata
      <AssetDetailsMetaDataLightbox asset={asset} visibility={_this.state.visibility} />
      <AssetDetailsMetaFormLightbox asset={asset} visibility={_this.state.visibility} onEdit={_this._onEdit} />
    </p>`

  _onEdit: (asset, e) ->

    @setState
      visibility:
        data: !@state.visibility.data
        form: !@state.visibility.form

    return false


AssetDetailsLightbox = React.createClass

  render: ->

    asset = @props.asset
    formattedDate = moment(asset.created_at).fromNow()
    thumbnail = if asset.content_type.match("image.*") then asset.preview_url
    preview = if thumbnail?
      `<img className="lightbox-asset__preview-image" src={thumbnail}/>`
    else
      `<span className={"lightbox-asset__preview-proxy lightbox-asset__preview-proxy--"+HeraclesAdmin.helpers.slugify(asset.content_type)}/>`
    `<div className="asset-details-lightbox">
      <div className="lightbox-asset">
        <div className="lightbox-asset__file-name">{asset.file_name}</div>
        <div className="lightbox-asset__date">{formattedDate}</div>
        <div className={"lightbox-asset__preview lightbox-asset__preview--"+HeraclesAdmin.helpers.slugify(asset.content_type)}>
          {preview}
        </div>
        <div className="lightbox-asset__details">
          <AssetDetailsMetaLightbox asset={asset} />
          {this._formatDetails()}
        </div>
      </div>
    </div>`

  _formatDetails: ->
    dimensions = if this.props.asset.corrected_width
      `<span>{this.props.asset.corrected_width}&times;{this.props.asset.corrected_height}, </span>`
    else
      ""
    `<div className="lightbox-asset__details__wrapper">
       <dl className="lightbox-asset__details-list">
         <dd>
           {dimensions} <em>{HeraclesAdmin.helpers.number.number_to_human_size(this.props.asset.size)}</em>
           &nbsp;—&nbsp;<a href={this.props.asset.original_url}>View original file</a>
         </dd>
       </dl>
     </div>`


# Register as available
HeraclesAdmin.availableLightboxes.add
  type: "AssetDetailsLightbox"
  component: AssetDetailsLightbox
