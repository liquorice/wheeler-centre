#= require lodash
#= require react
#= require jquery

#= require heracles/admin/lightboxes/lightbox
#= require heracles/admin/components/asset_search
#= require heracles/admin/components/asset_uploader

###* @jsx React.DOM ###

AssetSearch = HeraclesAdmin.AssetSearch
S3UploadComponent = HeraclesAdmin.S3UploadComponent

AssetSelectorLightbox = React.createClass
  getDefaultProps: ->
    allowMultiple: @props.allowMultiple || false
    selectedAssets: []

  getInitialState: ->
    selectedAssets: @props.selectedAssets

  onItemClick: (asset, e) ->
    e.preventDefault()
    selectedIndex = @getSelectedIndex asset
    if selectedIndex is -1
      @addAssetToSelected asset
    else
      @removeAssetFromSelected selectedIndex
    $(document).trigger "AssetSelector:updateSelected", [@state.selectedAssets]

  getSelectedIndex: (asset) ->
    _.findIndex @state.selectedAssets, (a) ->
      a.id is asset.id

  removeAssetFromSelected: (index) ->
    @state.selectedAssets.splice(index, 1)
    @setState selectedAssets: @state.selectedAssets

  addAssetToSelected: (asset) ->
    if @props.allowMultiple
      @state.selectedAssets.push asset
    else
      @state.selectedAssets = [asset]
    @setState selectedAssets: @state.selectedAssets

  # Send the data back to the FieldAsset and close the lightbox
  confirmSelection: (e) ->
    @props.callback @state.selectedAssets
    @props.api.closeLightbox(e)

  # Format the @props.selectedAssets array.
  # Newly selected results gets pushed straight in.
  # Assumes it gets the entire asset object
  formatSelectedAssets: ->
    _this = @
    if @state.selectedAssets.length > 0
      items = _.map @state.selectedAssets, (asset) ->
        thumbnail = if asset.content_type.match("image.*") then asset.thumbnail_url
        assetLabel = if asset.title
          "#{asset.title} — #{asset.file_name}"
        else
          asset.file_name
        preview = if thumbnail?
          aspect = if (asset.corrected_width / asset.corrected_height) > 1.4 then "width" else "height"
          `<img className={"asset-selector-selected__preview-image asset-selector-selected__preview-image--" + aspect} src={thumbnail}/>`
        else
          `<span className={"asset-selector-selected__preview-proxy asset-selector-selected__preview-proxy--"+HeraclesAdmin.helpers.slugify(asset.content_type)}/>`
        `<div key={asset.id} className="asset-selector-selected">
          <a href="#" onClick={_this.onItemClick.bind(this, asset)}>
            <div className="asset-selector-selected__preview">
              <div className="asset-selector-selected__preview-inner">
                {preview}
              </div>
            </div>
            <p className="asset-selector-selected__file-name" title={assetLabel}>{assetLabel}</p>
          </a>
        </div>`
    else
      items = `
      <div className="asset-selector-selected">
        <div className="asset-selector-selected__preview">
          <div className="asset-selector-selected__preview-inner asset-selector-selected__preview-inner--empty">
            <i className="fa fa-question-circle"/>
          </div>
        </div>
        <p className="asset-selector-selected__file-name">Nothing selected</p>
      </div>
      `

    return `<div className="asset-selector-selecteds">
      <h2 className="asset-selector-selecteds__heading">Selected items</h2>
      <div className="asset-selector-selecteds__controls">
        <button onClick={_this.confirmSelection} className="button button--dark">Confirm selection</button>
      </div>
      <div className="asset-selector-selecteds__list">
        {items}
      </div>
    </div>`


  render: ->
    selected = @formatSelectedAssets()
    `<div className="asset-selector">
      {selected}
      <S3UploadComponent site_slug={HeraclesAdmin.siteSlug} asset_create_url={HeraclesAdmin.asset_create_url}/>
      <p className="lightbox-title">Select an asset</p>
      <AssetSearch fileType={this.props.fileType} search="" clickHandler={this.onItemClick} />
    </div>`

# Register as available
HeraclesAdmin.availableLightboxes.add
  type: "AssetSelectorLightbox"
  component: AssetSelectorLightbox
