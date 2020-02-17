//=require lodash
//=require jquery
//=require react

//=require heracles/admin/components/available_insertables
//=require heracles/admin/lightboxes/lightbox
//=require heracles/admin/lightboxes/lightbox__asset_selector

/** @jsx React.DOM */

/**
 * Override 'InsertableDisplayMixin' in
 * `components/available_insertables.js.coffee`
 */

var displayMixinOverride = {

  /**
   * getInitialState
   * define the initial state
   * if this is a gallery child asset (this.props.isGalleryAsset),
   * we will pass `isGalleryAsset` to true
   * @return {Object}
   */

  getInitialState: function () {
    return {
      size: this.props.size || "30",
      value: this.props.value || {},
      link: false,
      isGalleryAsset: this.props.isGalleryAsset,
      onValueUpdate: this.props.onValueUpdate
    };
  },

  /**
   * componentWillMount
   * If this is a standalone image_insertable, fetch asset data.
   * If this is a isGalleryAsset, the asset data is already on this.state.value
   */

  componentWillMount: function () {
    if (this.props.isGalleryAsset) return;
    this.getAssetData(this.props.value.asset_id);
  },

  /**
   * componentWillReceiveProps
   * Save any new props to state.
   * This became a problem with gallery assets.
   * Adding 2 gallery assets, then removing 1 - didn't render the correct data
   * for the remaining asset
   * @param  {Object} nextProps
   */

  componentWillReceiveProps: function(nextProps) {
    var rawValue = nextProps.value || {}
    this.setState({
      size: nextProps.size || '30',
      value: _.extend({}, rawValue, this.state.value),
      link: nextProps.link || false
    });
  },

  /**
   * componentDidMount
   * add listeners to 'close' & 'closed' events and
   * check if we need to destroy this insertable.
   * On mount, open the asset selector
   */

  componentDidMount: function () {
    this.$doc = $(document);
    this.$doc.on("cover:close, lightbox.closed", (function (_this) {
      return function () {
        return setTimeout(_this.removeIfEmpty, 0);
      };
    })(this));

    if (this.isEmpty(this.props.value)) {
      this.openAssetSelector();
    }
  },

  /**
   * isEmpty
   * is the value empty?
   * @return {Boolean}
   */

  isEmpty: function (value) {
    return _.isEmpty(value)
  },

  /**
   * editValue
   * trigger 'insertable:edit' when clicking the 'edit' button of an image display
   * block, and pass an array of params to 'openEditor()'
   * see: ./components/available_insertables.js.coffee
   *
   * This allows us to share these params between the 'display' and 'edit'
   * react component blocks
   */

  editValue: function () {
    return this.$doc.trigger("insertable:edit", [
      this.props.type,
      this.state.value,
      this.state.size,
      this.handleValueChange,
      this.props.isGalleryAsset,
      this.props.onValueUpdate
    ]);
  },

  /**
   * remove
   * if this is a gallery asset, delegate the `remove` method to `this.props.onRemove`
   * otherwise use jQuery to remove it
   * @param  {Event} e: click
   */

  remove: function (e) {
    if (this.props.isGalleryAsset) {
      this.props.onRemove(this.props.value.id);
    } else {
      $(this.props.container).remove()
    }
  }
};

/**
 * InsertableImageDisplay
 * An insertable image display block for the editor
 */

var InsertableImageDisplay = React.createClass({

  // consume mixins
  mixins: [_.extend({}, InsertableDisplayMixin, displayMixinOverride)],

  /**
   * getAssetData
   * on `componentWillMount` we check if we need to fetch the asset data.
   * A gallery asset should not reach this method.
   * Request an asset and then call this.setAssetData()
   * @param  {String} assetID
   * @return {Object}  asset
   */

  getAssetData: function (assetID) {
    if (!_.isEmpty(assetID)) {
      var request = $.ajax({
        url: HeraclesAdmin.baseURL + "api/sites/" + HeraclesAdmin.siteSlug + "/assets/" + assetID,
        dataType: "json"
      });
      request.done(this.setAssetData);
    }
  },

  /**
   * openAssetSelector
   * Opens the asset selector
   * NOTE: Currently a gallery asset should not access this method
   * @param  {Event} e : click
   * @return {Function} Opens the lightbox
   */

   // NOTE standalone images will break here.

  openAssetSelector: function (e) {
    if (this.props.isGalleryAsset) return;
    if (e != null) {
      e.preventDefault();
    }
    return HeraclesAdmin.availableLightboxes.helper('AssetSelectorLightbox', {
      callback: this.onAssetSelection,
      fileType: "image",
      selectedAssets: this.state.assetData ? [this.state.assetData] : []
    });
  },

  /**
   * onAssetSelection
   * On asset selection build an asset object to pass to this.setAssetData()
   * otherwise call this.clearAssetData()
   * NOTE: Currently a gallery asset should not access this method
   * @param {Array} selectedAssets
   */

  onAssetSelection: function (selectedAssets) {
    if (this.props.isGalleryAsset) return;

    if (selectedAssets.length > 0) {
      var selection = selectedAssets[0];
      this.setAssetData({
        asset: selection
      });
    } else {
      this.clearAssetData();
    }
  },

  /**
   * setAssetData
   * set the `data` on this.state.value
   * @param  {Object} data [description]
   * @return {Function} call this.handleValueChange()
   */

  setAssetData: function (data) {
    if (this.props.isGalleryAsset) return;

    var newValue = _.extend({}, this.state.value, data.asset);
    newValue.asset_id = data.asset.id;
    this.setState({
      value: newValue
    });
    this.handleValueChange(newValue);
  },

  /**
   * clearAssetData
   * reset state
   * @return {Function} call this.handleValueChange()
   */

  clearAssetData: function () {
    if (this.props.isGalleryAsset) return;

    var newValue = _.extend({}, this.state.value);
    delete newValue.asset_id;
    this.setState({
      value: newValue
    });
    this.handleValueChange(newValue);
  },

  /**
   * hasLinkData
   * Check if `this.state.value.link` is not empty
   * @return Boolean ... I think
   */

  hasLinkData: function () {
    return !this.isEmpty(this.state.value.link);
  },

  /**
   * renderDisplayField
   * Only render the 'display' field if is NOT isGalleryAsset
   * @param  {String} display
   * @return {Node}
   */

  renderDisplayField: function (display) {
    return (
      <span>
        <dt>Display</dt>
        <dd>{ display || "—" }</dd>
      </span>
    );
  },

  /**
   * renderWidthField
   * Only render the 'width' field if is NOT isGalleryAsset
   * @param  {String} width
   * @return {Node}
   */

  renderWidthField: function (width) {
    return (
      <span>
        <dt>Width</dt>
        <dd>{ width }</dd>
      </span>
    )
  },

  /**
   * renderStandAloneAssetDetails
   * Return the original asset details list for a normal image insertable.
   * @param {Object} state
   * @return {Node}
   */

  renderStandAloneAssetDetails: function (state) {
    return (
      <dl className="field-details-list">
        <dt>Display</dt>
        <dd>{ state.display || "—" }</dd>
        <dt>Alternate text</dt>
        <dd>{ state.value.alt_text || "—" }</dd>
        <dt>Caption</dt>
        <dd>{ state.value.caption || "—" }</dd>
        <dt>Width</dt>
        <dd>{ state.width }</dd>
        <dt>Show attribution</dt>
        <dd>{ state.value.show_attribution === true ? "Yes" : "No" }</dd>
        <dt>Link</dt>
        <dd>{ this.hasLinkData() ? "Yes" : "No" }</dd>
      </dl>
    )
  },

  /**
   * renderGalleryAssetDetails
   * Custom layout of asset details for a gallery asset.
   * The details are split in 2 columns and alt_text / caption fields are
   * truncated to reduce overall height
   * @param {Object} state
   * @return {Node}
   */

  renderGalleryAssetDetails: function (state) {
    var maxChars = 60;
    var val = state.value;

    return (
      <div className="flex flex--align">
        <div className="field-details-list field-details-list--gallery-asset flex__item-1">
          <span>Alt text</span>
          <div className="flush">{ val.alt_text != null ? "Yes" : "No" }</div>
        </div>
        <div className="field-details-list field-details-list--gallery-asset flex__item-1">
          <span>Caption</span>
          <div className="flush">{ val.caption != null ? "Yes" : "No" }</div>
        </div>
        <div className="field-details-list field-details-list--gallery-asset flex__item-1">
          <span>Link</span>
          <div className="flush">{ this.hasLinkData() ? "Yes" : "No" }</div>
        </div>
        <div className="field-details-list field-details-list--gallery-asset flex__item-6">
          <span>Show attribution</span>
          <div className="flush">{ val.show_attribution === true ? "Yes" : "No" }</div>
        </div>
      </div>
    )
  },

  /**
   * renderChangeImageButton
   * Return a button node
   * @return {Node}
   */

  renderChangeImageButton: function () {
    return (
      <div className="field-asset__display-controls field-asset__display-controls--right">
        <div className="button-group">
          <button
            className="button insertable-display__edit button button--soft"
            onClick={ this.openAssetSelector }>
            Change image
          </button>
        </div>
      </div>
    )
  },

  /**
   * renderSortAnchor
   *
   * @return {[type]} [description]
   */

  renderSortAnchor: function () {
    return (
      <span className="button button--soft selected-page__handle"><i className="fa fa-arrows"/></span>
    )
  },

  /**
   * formatSelection
   * render an asset block
   * Render asset details based on if this is a standalone image insertable or
   * a gallery asset
   * @return {Node}
   */

  formatSelection: function () {
    var state = this.state;
    var previewURL = state.value.thumbnail_url;
    var aspect = (state.value.correct_width / state.value.correct_height) > 1.4 ? "width" : "height";
    var width = state.value.width != null ? "" + state.value.width : "—";

    return (
      <div className="field-asset__display">
        <div className="field-asset__preview">

          { state.isGalleryAsset ?
            null :
            this.renderChangeImageButton() }

          <img
            src={ previewURL }
            className={ "field-asset__preview-image field-asset__preview-image--" + aspect }/>
        </div>

        <div className="field-asset__display-controls field-asset__display-controls--right">
          <div className="button-group">
            { this.props.isSortable ?
              this.renderSortAnchor() :
              null }
            <button
              className="button insertable-display__edit button button--soft"
              onClick={ this.editValue }>
              Edit details
            </button>
            <button
              className="button insertable-display__remove button button--soft"
              onClick={ this.remove }>
              <i className="fa fa-times"/>
            </button>
          </div>
        </div>

        <div className="field-asset__details">
          { state.isGalleryAsset ?
            this.renderGalleryAssetDetails(state) :
            this.renderStandAloneAssetDetails(state) }
        </div>
      </div>
    );
  },

  /**
   * render
   * render a node block for this.state.value
   * @return {Node}
   */

  render: function () {
    return (
      <div
        className="insertable-display insertable-display-image"
        contentEditable="false"
        data-asset-id={this.state.value.id}
        key={ this.props.key || this.state.value.id }>
        { this.state.value ? this.formatSelection() : "" }
      </div>
    );
  }
});

/**
 * InsertableImageEdit
 * An insertable image edit block for the editor
 */

var InsertableImageEdit = React.createClass({

  // consume global mixin
  mixins: [InsertableEditMixin],

  /**
   * handleChange
   * On change of form inputs, save the property name and value to state
   * @param  {String} ref - an object property name
   * @param  {Event} e
   */

  handleChange: function (ref, e) {
    this.state.value[ref] = e.target.value;
    this.setState({
      value: this.state.value
    });
  },

  /**
   * handleCheckboxChange
   * On change of checkbox, save the property name and value to state
   * @param  {String} ref - an object property name
   * @param  {Event} e
   */

  handleCheckboxChange: function (ref, e) {
    this.state.value[ref] = this.refs[ref].getDOMNode().checked;
    this.setState({
      value: this.state.value
    });
  },

  /**
   * _onLinkChange
   * Assign data to this.state.value.link prop
   * @param  {String} type : "link"
   * @param  {Object} data : {href: "...", title: "..."}
   */

  _onLinkChange: function (type, data) {
    var value;
    value = _.extend({}, this.state.value);
    value.link = data;
    this.setState({
      value: value
    });

    // if isGalleryAsset, call onValueUpdate() and pass this
    // asset data back up to the gallery
    if (this.props.isGalleryAsset) {
      this.props.onValueUpdate(this.state.value)
    }
  },

  /**
   * renderDisplayField
   * return a form element.
   * Only called if this is NOT isGalleryAsset
   * @param  {Object} state
   * @return {Node}
   */

  renderDisplayField: function (state) {
    return (
      <div className="field">
        <div className="field-header">
          <label
            className="field-label"
            htmlFor="edit__display">Display</label>
        </div>
        <div className="field-main">
          <select
            ref="alt"
            id="edit__display"
            className="field-select"
            value={ state.value.display }
            onChange={ this.handleChange.bind(this, "display") }>
            <option/>
            <option>Inline</option>
            <option>Left-aligned</option>
            <option>Right-aligned</option>
            <option>Center-aligned</option>
            <option>Full-width</option>
          </select>
        </div>
      </div>
    );
  },

  /**
   * renderWidthField
   * return a form element.
   * Only called if this is NOT isGalleryAsset
   * @param  {Object} state
   * @return {Node}
   */

  renderWidthField: function (state) {
    return (
      <div className="field">
        <div className="field-header">
          <label className="field-label" htmlFor="edit__width">Width</label>
        </div>
        <div className="field-name">
          <input
            type="text"
            ref="width"
            id="edit__width"
            className="field-text-input insertable-edit__width"
            value={ state.value.width }
            onChange={ this.handleChange.bind(this, "width") }
            placeholder="Width — e.g., 30% or 30px"/>
        </div>
      </div>
    );
  },

  /**
   * render
   * return a form.
   * @return {Node}
   */

  render: function () {
    var state = this.state;
    return (
      <div className="insertable-edit fields--reversed">
        <form onSubmit={ this.onSubmit }>
          <h2 className="insertable-edit__title">Edit image details</h2>

          { !this.props.isGalleryAsset ? this.renderDisplayField(state) : '' }

          <div className="field">
            <div className="field-header">
              <label
                className="field-label"
                htmlFor="edit__alt-text">Alternate text</label>
            </div>
            <div className="field-main">
              <input
                ref="alt"
                id="edit__alt-text"
                className="field-text-input"
                value={ state.value.alt_text }
                onChange={ this.handleChange.bind(this, "alt_text") }
                placeholder="Visual description of the image"/>
            </div>
          </div>

          <div className="field">
            <div className="field-header">
              <label className="field-label" htmlFor="edit__caption">Caption</label>
            </div>
            <div className="field-main">
              <textarea
                ref="caption"
                id="edit__caption"
                className="field-text-input insertable-edit__caption"
                value={ state.value.caption }
                onChange={ this.handleChange.bind(this, "caption") }
                placeholder="Caption"/>
            </div>
          </div>

          { !this.props.isGalleryAsset ? this.renderWidthField(state) : '' }

          <div className="field">
            <div className="field-main">
              <div className="field-checkbox">
                <input
                  ref="show_attribution"
                  className="field-checkbox-input"
                  type="checkbox"
                  defaultChecked={ this.props.value.show_attribution }
                  id="edit__show-page-link"
                  onChange={ this.handleCheckboxChange.bind(this, "show_attribution") }/>
                <label
                  className="field-checkbox-label"
                  htmlFor="edit__show-page-link">Show attribution?</label>
              </div>
            </div>
          </div>

          <div className="field">
            <div className="field-header">
              <label className="field-label">Link</label>
            </div>
            <div className="field-name">
              <FieldContentInlineEditor
                type="link"
                data={ state.value.link }
                callback={ this._onLinkChange }
                withForm={false}/>
            </div>
          </div>

          <button
            type="submit"
            className="button button--highlight">Save changes to image</button>
        </form>
      </div>
    );
  }
});

HeraclesAdmin.availableInsertables.add({
  type: "image",
  label: "Image",
  icon: "picture-o",
  display: InsertableImageDisplay,
  edit: InsertableImageEdit
});
