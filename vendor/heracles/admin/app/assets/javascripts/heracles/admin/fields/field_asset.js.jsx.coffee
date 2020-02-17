#= require lodash
#= require react
#= require momentjs

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors
#= require heracles/admin/lightboxes/lightbox
#= require heracles/admin/lightboxes/lightbox__asset_selector

###* @jsx React.DOM ###

FieldAsset = React.createClass
  mixins: [FieldMixin]
  propTypes:
    asset_ids: React.PropTypes.array
  getInitialState: ->
    @getAssetData(@props.asset_ids)
    field: @props.field
    asset_ids: @props.asset_ids
    assetData: false # Set dummy object
  getAssetData: (assetID) ->
    unless _.isEmpty(assetID)
      request = $.ajax
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets/#{assetID}"
        dataType: "json"
      request.done @setAssetData

  setAssetData: (data) ->
    @setState assetData: data.asset

  clearAssetData: ->
    # Override only the field data that changes
    newField = _.extend {}, @state.field
    delete newField.asset_ids
    @props.updateField @state.field.field_name, newField
    @setState assetData: false

  # Open the asset selector in a lightbox
  openAssetSelector: (e) ->
    e.preventDefault()
    # Call the lightbox, passing it a callback reference in this component,
    # the fileType limitation, and the currently selected asset
    HeraclesAdmin.availableLightboxes.helper 'AssetSelectorLightbox',
      callback: @onAssetSelection
      fileType: @props.field.field_config.field_asset_file_type
      selectedAssets: if @state.assetData then [@state.assetData] else []

  # Callback, passed to the selector
  # Expects an array of assets to come back
  onAssetSelection: (selectedAssets) ->
    if selectedAssets.length > 0
      selection = selectedAssets[0]
      @setAssetData {asset: selection}
      @handleChange selection.id
    else
      @clearAssetData()

  # Display format when asset is selected
  formatSelection: ->
    thumbnail = @state.assetData.thumbnail_url
    preview = if thumbnail?
      aspect = if (@state.assetData.corrected_width / @state.assetData.corrected_height) > 1.4 then "width" else "height"
      `<img className={"field-asset__preview-image field-asset__preview-image--" + aspect} src={thumbnail}/>`
    else
      `<span className={"asset-selector-result__preview-proxy asset-selector-result__preview-proxy--"+HeraclesAdmin.helpers.slugify(this.state.assetData.content_type)}/>`
    dimensions = if @state.assetData.corrected_width and @state.assetData.corrected_height
      `<div>
        <dt>Dimensions</dt>
        <dd>{this.state.assetData.corrected_width} × {this.state.assetData.corrected_height}</dd>
      </div>`
    else
      ""
    `<div className="field-asset__display">
      <div className="field-asset__display-controls field-asset__display-controls--right">
        <div className="button-group">
          <button className="button insertable-display__edit button button--soft" onClick={this.openAssetSelector}>
            Change
          </button>
          <button className="button insertable-display__remove button button--soft" onClick={this.clearAssetData}>
            <i className="fa fa-times"/>
          </button>
        </div>
      </div>
      <div className="field-asset__preview">
        {preview}
      </div>
      <div className="field-asset__details">
        <dl className="field-details-list">
          <dt>Filename</dt>
          <dd>{this.state.assetData.file_name}</dd>
          <dt>Uploaded on</dt>
          <dd>{moment(this.state.assetData.updated_at).format("D/M/YYYY")}</dd>
          {dimensions}
          <dt>Filesize</dt>
          <dd>{HeraclesAdmin.helpers.number.number_to_human_size(this.state.assetData.size)}</dd>
        </dl>
      </div>
        <FieldErrors errors={this.state.field.errors}/>
    </div>`

  formatSelector: ->
    assetLabel = if @props.field.field_config.field_asset_file_type is "image"
      "an #{@props.field.field_config.field_asset_file_type}"
    if @props.field.field_config.field_asset_file_type is "video" or @props.field.field_config.field_asset_file_type is "document"
      "a #{@props.field.field_config.field_asset_file_type}"
    else
      "an asset"
    `<a className="field-empty__select" onClick={this.openAssetSelector} href="#">
      <span className="field-empty__select-label button button--dark">Select {assetLabel}</span>
    </a>`

  handleChange: (assetID) ->
    # Override only the field data that changes
    newField = _.extend {}, @state.field, asset_ids: [assetID]
    @props.updateField @state.field.field_name, newField
    @setState
      field: newField
      asset_ids: [assetID]
  formatFallback: ->
    if @state.field.field_config.field_fallback?.asset_ids?
      "Asset IDs: #{@state.field.field_config.field_fallback?.asset_ids.join(", ")}"
  render: ->
    if @state.assetData
      template = @formatSelection()
    else
      template = @formatSelector()
    displayClassName = "field-asset field-asset--#{if @props.field.field_config.field_asset_file_type then @props.field.field_config.field_asset_file_type else 'all'}"
    return `<div className={this.displayClassName(displayClassName)}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          {template}
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
      </div>`

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "assets__singular"
  formatProps: (data) ->
    key: data.key
    newRow: data.newRow
    updateField: data.updateField
    field: data.field
    asset_ids: data.field.asset_ids
  component: FieldAsset
