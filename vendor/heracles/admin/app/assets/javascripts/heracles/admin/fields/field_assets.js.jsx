/** @jsx React.DOM */

//= require lodash
//= require react

//= require heracles/admin/utils/jquery-ui
//= require heracles/admin/components/available_fields
//= require heracles/admin/fields/field_header
//= require heracles/admin/fields/field_fallback
//= require heracles/admin/fields/field_errors
//= require heracles/admin/lightboxes/lightbox
//= require heracles/admin/lightboxes/lightbox__asset_selector

(function() {

  function fetchAssetData(assetIDs) {
    return new Promise(function(resolve, reject) {
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
  }

  function getIDs(arr) {
    return _.map(arr, function(a) { return a.id; });
  }



  /**
   * FieldAsset React component
   */

  var FieldAssets = React.createClass({

    mixins: [FieldMixin],

    propTypes: {
      asset_ids: React.PropTypes.array
    },

    getDefaultProps: function() {
      return {
        assets: [],
        asset_ids: []
      };
    },

    getInitialState: function() {
      return {
        field: this.props.field,
        assets: this.props.assets,
        asset_ids: this.props.asset_ids
      };
    },

    componentWillMount: function() {
      // Trigger a fetch of assets data on first load
      if (this.props.asset_ids.length > 0) {
        var fetch = fetchAssetData(this.props.asset_ids);
        fetch.then(function(data) {
          this.setAssetsData(data.assets, {clobber: true});
        }.bind(this));
      }
    },

    componentDidMount: function() {
      // Cache a reference to our list element as a jQuery object
      this.sortableListEl = $(this.refs.sortableList.getDOMNode());
      this.initSortableList();
    },

    setAssetsData: function(assets, opts) {
      opts = opts || {};
      if (!opts.clobber) {
        assets = this.state.assets.slice(0).concat(assets);
      }
      this.setState({assets: assets});
      return assets;
    },

    clearAssetData: function() {
      // Override only the field data that changes
      var newField = _.extend({}, this.state.field);
      delete newField.asset_ids;
      this.props.updateField(this.state.field.field_name, newField);
      this.setState({assets: []});
    },

    // Open the asset selector in a lightbox
    openAssetSelector: function(e) {
      e.preventDefault();
      // Call the lightbox, passing it a callback reference in this component,
      // the fileType limitation, and the currently selected asset
      HeraclesAdmin.availableLightboxes.helper('AssetSelectorLightbox', {
        callback: this.onAssetSelection,
        allowMultiple: true,
        fileType: this.props.field.field_config.field_assets_file_type
      });
    },


    // Callback, passed to the selector
    // Expects an array of assets to come back
    onAssetSelection: function(selectedAssets) {
      if (selectedAssets.length > 0) {
        var assets = this.setAssetsData(selectedAssets);
        this.propagateChangesToParent(getIDs(assets));
      } else {
        this.clearAssetData();
      }
    },

    removeFromAssets: function(index, e) {
      e.preventDefault();
      var assets = this.state.assets.slice(0);
      assets.splice(index, 1);
      this.setState({assets: assets});
      this.propagateChangesToParent(getIDs(assets));
    },

    propagateChangesToParent: function(assetIDs) {
      // Override only the field data that changes
      var newField = _.extend({}, this.state.field, {asset_ids: assetIDs});
      this.props.updateField(this.state.field.field_name, newField);
      this.setState({
        field: newField,
        asset_ids: assetIDs
      });
    },

    initSortableList: function() {
      this.sortableListEl.sortable({
        axis: "y",
        handle: ".sortable-asset__handle",
        items: ".sortable-asset",
        update: this.onSortableListUpdate,
        tolerance: "pointer"
      });
    },

    onSortableListUpdate: function(e) {
      // Not ideal using data-attrs, but there’s no easy way to pass this data
      // with jQuery UI.
      var orderedAssets = [];
      var currentAssets = this.state.assets.slice(0);
      this.sortableListEl.find("[data-position]").each(function(index) {
        var position = $(this).data("position");
        orderedAssets.push(
          currentAssets.slice(position, position + 1)[0]
        );
      });
      // Attempt to avoid DOM mutation issues with jQuery UI sortables
      this.setState({assets: []});
      this.setState({assets: orderedAssets});
      this.propagateChangesToParent(
        getIDs(orderedAssets)
      );
    },

    formatFallback: function() {
      var fallback = this.state.field.field_config.field_fallback;
      var hasFallback = (fallback !== undefined && fallback !== null);
      if (hasFallback && fallback.asset_id !== undefined && fallback.asset_id !== null) {
        return "Asset id: " + fallback.asset_id;
      }
    },

    render: function() {
      var field = this.state.field;
      var config = field.field_config;
      var hasAssets = (this.state.assets.length > 0);
      var showSortHandles = (this.state.assets.length > 1);

      var assetLabel = "assets";
      if (config.field_assets_file_type === "audio") {
        assetLabel = "audio assets";
      } else if (config.field_assets_file_type) {
        assetLabel = config.field_assets_file_type + "s";
      }

      var listClassNames = React.addons.classSet({
        "field-assets__selected-assets": true,
        "field-assets__selected-assets--hide": !hasAssets
      });
      var listItems = _.map(this.state.assets, function(asset, index) {

        var preview;
        if (asset.thumbnail_url) {
          preview = <div className="field-assets__preview" style={{backgroundImage: "url("+asset.thumbnail_url+")"}}/>;
        } else {
          preview = <div className="field-assets__preview"><span className={"field-assets__preview-proxy field-assets__preview-proxy--"+HeraclesAdmin.helpers.slugify(asset.content_type)}/></div>;
        }

        return (
          <li key={index + "-" + asset.id} className="sortable-asset" data-position={index}>
            <div className="sortable-asset__controls">
              <div className="button-group">
                {(showSortHandles) ? <span className="button button--small button--soft sortable-asset__handle"><i className="fa fa-arrows"/></span> : null}
                <button className="button button button--soft button--small" onClick={this.removeFromAssets.bind(this, index)}>
                  <i className="fa fa-times"/>
                </button>
              </div>
            </div>
            {preview}
            <h2 className="field-assets__selected-assets-title">{asset.file_name}</h2>
          </li>
        );
      }.bind(this));

      var controlsClassNames = React.addons.classSet({
        "field-assets__controls": true,
        "field-assets__controls--hide": !hasAssets
      });

      var emptyClassNames = React.addons.classSet({
        "field-empty__select": true,
        "field-empty__select--hide": hasAssets
      });

      return (
        <div className={this.displayClassName("field-assets")}>
          <FieldHeader label={config.field_label} name={field.field_name} hint={config.field_hint} required={config.field_required}/>
          <div className="field-main">
            <div className={controlsClassNames}>
              <button className="field-assets__add-more-button button button--soft button--small" onClick={this.openAssetSelector}>Select additional {assetLabel}</button>
            </div>
            <ul ref="sortableList" className={listClassNames}>
              {listItems}
            </ul>
            <a className={emptyClassNames} onClick={this.openAssetSelector} href="#">
              <span className="field-empty__select-label button button--dark">Select {assetLabel}</span>
            </a>
            <FieldFallback field={config.field_fallback} content={this.formatFallback()}/>
          </div>
        </div>
      );
    }
  });


  // Register as available
  HeraclesAdmin.availableFields.add({
    editorType: "assets",
    formatProps: function(data) {
      return {
        key: data.key,
        newRow: data.newRow,
        updateField: data.updateField,
        field: data.field,
        asset_ids: data.field.asset_ids
      };
    },
    component: FieldAssets
  });

}).call(this);
