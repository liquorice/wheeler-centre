//=require lodash
//=require jquery
//=require react
//=require heracles/admin/object-hash.js
//=require heracles/admin/sortable.js
//=require heracles/admin/react-sortable-mixin.js
//=require heracles/admin/insertables/insertable_image
//=require heracles/admin/components/available_insertables
//=require heracles/admin/lightboxes/lightbox
//=require heracles/admin/lightboxes/lightbox__asset_selector

/** @jsx React.DOM */

/**
 * InsertableGalleryDisplay
 * Admin editor insertable
 */

var InsertableGalleryDisplay = React.createClass({

  // include the React SortableJS Mixin
  mixins: [SortableMixin],


  /**
   * getInitialState
   */

  getInitialState: function () {
    return {
      value: this.props.value || {}
    };
  },

  /**
   * sortableOptions
   * Define options for the sortable list.
   * ghostClass: allows us to define styles to the ghost element
   * model: will watch this.state.assets
   * onUpdate: will call handleUpdate() when the list changes
   * ref: relates to  <div ref="gallery-assets"> in the render() method
   *
   * More options: https://github.com/RubaXa/Sortable#options
   */

  sortableOptions: {
    ghostClass: "sortable-ghost",
    model: "assets",
    onUpdate: "handleUpdate",
    ref: "gallery-assets"
  },

  /**
   * handleUpdate
   * Pass the asset_id, oldIndex and newIndex of the 'sorted' asset to
   * this.sortAssetsArray().
   * Pass it's reponse to this.setAssetData()
   * @param  {Event} e - the event of sorting an element in the list
   */

  handleUpdate: function (e) {
    this.setAssetData(
      this.sortAssetsArray(
        e.item.getAttribute('data-asset-id'),
        e.oldIndex,
        e.newIndex
     )
   );
  },

  /**
   * sortAssetsArray
   * This is kind of messy.
   * What we're doing is sorting this.state.assets based on the event of
   * dragging (and dropping) and asset in a gallery.
   *
   * Take an asset `id`, `newIndex` and `oldIndex` positions.
   * Filter out the target asset (the moved asset) from the array of `assets`.
   * If it doesnt exist, get out.
   * Remove the target asset and insert it again at the new index.
   *
   * @param  {String} id - and asset's `id`
   * @param  {Number} oldIndex - the position this asset was in `assets`
   * @param  {Number} newIndex - the position this asset should be in `assets`
   * @return {Array}  clone - the mutated clone of this.state.assets
   */

  sortAssetsArray: function (id, oldIndex, newIndex) {
    // I don't understand why but this is somehow already sorted when it arrives here?

    // var clone = this.state.assets.slice().map(function(obj) {
    //   return _.assign({}, obj);
    // });

    // var target = clone.filter(function(asset, idx){
    //   if (asset.id === id) return asset
    // });

    // if (!target.length) return;

    // // remove > insert > return
    // clone.splice(oldIndex, 1)
    // clone.splice(newIndex, 0, target[0]);
    // return clone;
    return this.state.assets
  },

  /**
   * componentWillMount
   * Check for existing `this.props.value.assets_data`, return if
   * it doesnt exist.
   * If exists, call strip out the asset_id of each object
   * Using the IDs, pass it to fetchAssetData() to
   * - merge existing asset_data with each asset
   * - set the merged asset data with setAssetData()
   */

  componentWillMount: function () {
    var self = this;
    var data = this.props.value.assets_data;
    if (!data) return;

    var ids = data.map(function(obj){
      return obj.asset_id
    });

    this.fetchAssetData(ids)
      .then(function (res) {
        return self.mergeFetchedAssetData(res.assets)
      })
      .then(function (data) {
        return self.setAssetData(data);
      })
      .catch(function (err){
        console.log('fetchAssetData:', err.stack);
      });
  },

  /**
   * fetchAssetData
   * Request asset data for each id in `assetIDs`.
   * @param {Array} assetIDs
   * @return {Promise}
   */

  fetchAssetData: function (assetIDs) {
    return new Promise(function (resolve, reject) {
      var url = HeraclesAdmin.baseURL + "api/sites/" + HeraclesAdmin.siteSlug + "/assets";
      var request = $.ajax({
        url: url,
        dataType: "json",
        data: {
          asset_ids: assetIDs.join(",")
        }
      });
      request.done(resolve).fail(reject);
    });
  },

  /**
   * mergeFetchedAssetData
   * merge a fetched asset object with any existing 'assets_data' objects
   * @param  {Array} arr - an array of fetched objects from fetchAssetData()
   * @return {Array} and array of the same fetched objects with any merged asset_data
   */

  mergeFetchedAssetData: function(arr) {
    var value = this.state.value;
    return arr.map(function (assetObject, idx) {
      if (assetObject.id === value.assets_data[idx].asset_id) {
        _.merge(assetObject, value.assets_data[idx]);
      }
      return assetObject;
    });
  },

  /**
   * componentDidMount
   * Cache a reference to window.document
   * Delegate event listeners to 'cover:close, lightbox.closed' and call
   * removeIfEmpty()
   * Check if `this.props.value` is empty, if so, call openAssetSelector() which
   * will open the lightbox
   */

  componentDidMount: function () {
    this.$doc = $(document);
    this.$doc.on("cover:close, lightbox.closed", function () {
      setTimeout(this.removeIfEmpty, 0);
    }.bind(this));

    if (this.isEmptyObject(this.props.value)) {
      return this.openAssetSelector();
    }
  },

  /**
   * componentDidUpdate
   * Everytime something is saved to the state, update the parent
   * element with the new data
   */

  componentDidUpdate: function() {
    var data = this.buildAssetData();
    this.updateContainerValue(data);
  },

  /**
   * handleValueChange
   * We need this method as it's tightly bound to the global `InsertableEditMixin`
   * So on 'submit' of the edit form (when we save a gallery width / modifier / display),
   * this method is triggered.
   * We just need to set the width/modifier/display values on the state.
   * @param  {Object} updatedGalleryData
   */

  handleValueChange: function (updatedGalleryData) {
    var clone = _.assign({}, this.state.value);
    clone.width = updatedGalleryData.width;
    clone.modifier = updatedGalleryData.modifier;
    clone.display = updatedGalleryData.display;

    this.setState({
      value: clone
    });
  },

  /**
   * updateContainerValue
   * Store 'data' in the elements 'value' attribute
   * @param  {Object} data
   */

  updateContainerValue: function (data) {
    $(this.props.container).attr("value", JSON.stringify(data));
  },

  /**
   * removeIfEmpty
   * if no `value` call remove(), unmounting the component
   * @param  {Object} value
   */

  removeIfEmpty: function (value) {
    var val = value || this.state.value;
    if (this.isEmptyObject(val)) {
      return this.remove();
    }
  },

  /**
   * isEmptyObject
   * Check if `obj` is an empty object
   * @param  {Object} value
   * @return {Boolean}
   */

  isEmptyObject: function (value) {
    return _.isEmpty(value)
  },

  /**
   * editValue
   * Toggles the edit form.
   * See window.InsertableEditor in components/available_insertables.js.coffee
   */

  editValue: function () {
    return this.$doc.trigger("insertable:edit", [
      this.props.type,
      this.state.value,
      30,
      this.handleValueChange
    ]);
  },

  /**
   * remove
   * Unmount the insertable react component from the editor
   */

  remove: function () {
    React.unmountComponentAtNode(this.props.container);
    return $(this.props.container).remove();
  },

  /**
   * removeAsset
   * Remove an asset with a matching `id` from state.
   * Filter existing `assets_data`
   * If there are no assets left over from filtering, call this.remove().
   * Send the filtered assets to setAssetData()
   * @param  {String} id
   */

  removeAsset: function (id) {
    var assets = this.state.assets;

    var filtered = assets.filter(function (obj) {
      return obj.id !== id
    })

    if (!filtered.length) return this.remove();
    this.setAssetData(filtered);
  },

  /**
   * addAsset
   * on click, openAssetSelector so more assets can be added
   * Pass 'true' as a second param so we can append assets in `setAssetData()`
   */

  addAsset: function (e) {
    return this.openAssetSelector(e, true);
  },

  /**
   * buildAssetData
   * Build up asset data structure to be stored as this.state.value
   * as well as on the parent gallery element updateContainerValue()
   * @param {Array} arr : an array of asset objects
   * @return {Object}
   *
   * example structure:
   *
   * {
   *   "assets_data": [
   *     {
   *       "asset_id": "3db06c05-9a8d-4b9f-9032-6e96420d4b97",
   *       "caption": null,
   *       "alt_text": null,
   *       "show_attribution": false
   *     },
   *     {
   *       "asset_id": "c579730a-7eb7-43b5-80de-43863a975743",
   *       "caption": null,
   *       "alt_text": null,
   *       "show_attribution": false
   *     }
   *   ],
   *   "gallery_display": "Center-aligned",
   *   "gallery_width": "100%"
   *   "gallery_modifier": "grid"
   * }
   */

  buildAssetData: function (arr) {
    var assets_data = [];
    var value = this.state.value;
    arr = arr || this.state.assets;

    // store the edited properties of an asset in 'assets_data'
    arr.map(function (obj) {
      assets_data.push({
        asset_id: obj.id,
        caption: obj.caption || null,
        alt_text: obj.alt_text || null,
        show_attribution: obj.show_attribution || false,
        link: obj.link || false
      });
    });

    return {
      assets_data: assets_data,
      display: value.display || 'Center-aligned',
      width: value.width || '100%',
      modifier: value.modifier || ''
    };
  },

  /**
   * openAssetSelector
   * Create a new instance of `AssetSelectorLightbox`
   * - callback: fired when 'Confirm selection' button is clicked in the lightbox
   * - allowMultiple: false by default, allow multiple selection
   * - selectedAssets: array of assets
   */

  openAssetSelector: function (e, append) {
    var self = this;
    if (e != null) e.preventDefault();
    return HeraclesAdmin.availableLightboxes.helper('AssetSelectorLightbox', {
      callback: function (res) { self.onAssetSelection(res, append) },
      fileType: "image",
      allowMultiple: true,
      selectedAssets: this.state.asset_data ? this.state.asset_data : []
    });
  },

  /**
   * onAssetSelection
   * Called when 'Confirm selection' button is clicked in the asset lightbox
   * @param  {Array} selectedAssets [Object, Object]
   */

  onAssetSelection: function (selectedAssets, append) {
    if (!selectedAssets.length) return this.clearAssetData();
    this.setAssetData(selectedAssets, append);
  },

  /**
   * setAssetData
   * Take an object of assets (array).
   * Check if we're going to 'append' assets. Passed in from `addAssets()` allowing
   * us to append a new assets to existing this.state.assets
   * Pass `assets` to  buildAssetData() to construct our asset data structure
   * Save built asset data ( this.buildAssetData() ) to 'value'
   * Save 'assets'
   * @param  {Array} assets: an array of asset objects
   */

  setAssetData: function (assets, append) {
    if (!assets) return;

    if (append && (this.state.assets && this.state.assets.length)) {
      var copy = this.state.assets.slice(0)
      assets = copy.concat(assets)
    }

    this.setState({
      value: this.buildAssetData(assets),
      assets: assets
    });
  },

  /**
   * clearAssetData
   * Reset 'value', 'assets' back to and empty object/array and remove
   */

  clearAssetData: function () {
    this.setState({
      value: {},
      assets: []
    });
    this.remove();
  },

  /**
   * mergeUpdatedAssetData
   * Take an asset and merge it's new data into the
   * 'assets' object(s) in this.state.assets
   * Send the merged assets to setAssetData()
   * @param {Object} asset
   * @param {Array} arr
   */

  mergeUpdatedAssetData: function (asset, arr) {
    var state = this.state;
    arr = arr || state.assets;

    var merged = arr.map(function (obj, idx) {
      if (obj.id === asset.id) {
        _.merge(state.assets[idx], asset);
      }
      return obj;
    });

    this.setAssetData(merged);
  },

  /**
   * renderAsset
   * Pass in the asset 'data' object and 'idx' to an image insertable.
   * Return a 'display' node for each asset
   * Pass in 'isGalleryAsset' to override certain aspects of the image_insertable
   * Pass in 'onValueUpdate' as a hook to get updated asset data after it's been edited
   * @param  {Object} data - the asset data object
   * @param  {Number} idx - an index passed in by render()s .map functiom
   * @return {Node} element
   */

  renderAsset: function (data, idx) {
    var isSortable = (this.state.assets.length > 1) ? true : false;

    return (
      <InsertableImageDisplay
        isGalleryAsset={ true }
        isSortable={ isSortable }
        key={ objectHash(_.assign({idx: idx}, data)) }
        onRemove={ this.removeAsset }
        onValueUpdate={ this.mergeUpdatedAssetData }
        type="image"
        value={ data }
      />
    );
  },

  /**
   * renderGalleryActions
   * Render a edit & remove button for the gallery insertable
   * @return {Node}
   */

  renderGalleryActions: function () {
    var value = this.state.value;

    return (
      <div className="field-asset__display border-none align-center flex flex__item-2">
        <div className="insertable-display-gallery__title flex flex--align flex__item-2 p-xsm text-left">
          Gallery
        </div>
        <div className="flex flex--align flex__item-2 p-xsm text-left">
          <dl className="field-details-list">
            <dt>Display</dt>
            <dd>{ value.display || "Center-aligned" }</dd>
          </dl>
        </div>
        <div className="flex flex--align flex__item-2 p-xsm text-left">
          <dl className="field-details-list">
            <dt>Width</dt>
            <dd>{ value.width || "100%" }</dd>
          </dl>
        </div>
        <div className="flex flex--align flex__item-2 p-xsm text-left">
          <dl className="field-details-list">
            <dt>Modifier keyword</dt>
            <dd>{ value.modifier || "" }</dd>
          </dl>
        </div>
        <div className="field-asset__details field-asset__details--gallery flex flex__item-2 flush">
          <div className="field-asset__display-controls field-asset__display-controls--right">
            <div className="button-group">
              <button
                className="button insertable-display__add button button--soft"
                onClick={ this.addAsset }>
                Add
              </button>
              <button
                className="button insertable-display__edit button button--soft"
                onClick={ this.editValue }>
                Edit
              </button>
              <button
                className="button insertable-display__remove button button--soft"
                onClick={ this.remove }>
                <i className="fa fa-times"/>
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  },

  /**
   * render
   * map through existing `this.state.assets_data` and call formatSelection()
   * for every asset
   * @return {Node} Element
   */

  render: function () {
    var assets = this.state.assets || [];
    var className = (assets.length > 1) ? "js-sortable" : "";
    return (
      <div className="insertable-display-gallery">
        { this.renderGalleryActions() }
        <div className={ className } ref="gallery-assets">
          { assets.length ? assets.map(this.renderAsset) : ""}
        </div>
      </div>
    );

    // return (
    //   <div className={ className }>
    //     { assets.length ? assets.map(this.renderAsset) : ""}
    //   </div>
    // );
  }
});

/**
 * InsertableGalleryEdit
 * Admin edit form for a gallery insertable
 * on save the 'handleValueChange()' of the display block above will be triggered,
 * saving what is in this `this.state.value` to the gallery element (via InsertableEditMixin)
 */

var InsertableGalleryEdit = React.createClass({

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
   * render
   * render the gallery 'edit' form
   */

  render: function () {
    var state = this.state;

    return (
      <div className="insertable-edit fields--reversed">
        <form onSubmit={this.onSubmit}>
          <h2 className="insertable-edit__title">Edit image details</h2>
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
                <option>Left-aligned</option>
                <option>Right-aligned</option>
                <option>Center-aligned</option>
                <option>Full-width</option>
              </select>
            </div>
          </div>
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
          <div className="field">
            <div className="field-header">
              <label className="field-label" htmlFor="edit__modifier">Modifier keyword</label>
            </div>
            <div className="field-name">
              <input
                type="text"
                ref="modifier"
                id="edit__modifier"
                className="field-text-input insertable-edit__modifier"
                value={ state.value.modifier }
                onChange={ this.handleChange.bind(this, "modifier") }
                placeholder="Modifier keyword — e.g., grid"/>
            </div>
          </div>
          <button
            type="submit"
            className="button button--highlight">Save changes to gallery</button>
        </form>
      </div>
    );
  }
});

/**
 * 'export' this insertable
 */

HeraclesAdmin.availableInsertables.add({
  type: "gallery",
  label: "Gallery",
  icon: "picture-o",
  display: InsertableGalleryDisplay,
  edit: InsertableGalleryEdit
});
