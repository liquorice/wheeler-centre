//=require lodash
//=require jquery
//=require react
//=require heracles/admin/components/available_insertables
//=require heracles/admin/lightboxes/lightbox
//=require heracles/admin/lightboxes/lightbox__asset_selector

/** @jsx React.DOM */

/**
 * InsertableGalleryDisplay
 * Admin editor insertable
 */

var InsertableSharedImageDisplay = React.createClass({

  /**
   * editValue
   * Toggles the edit form.
   * See window.InsertableEditor in components/available_insertables.js.coffee
   */

  editValue: function () {
    return this.$doc.trigger("insertable:edit", [
      this.props.type,
      this.props.value,
      this.props.size || 30,
      this.props.handleValueChange
    ]);
  },

  /**
   * remove
   * Unmount the insertable react component from the editor
   */

  remove: function (e) {
    e.preventDefault();
    this.props.onRemove(this.props.key);
  },

  /**
   * hasLinkData
   * yeah... not sure
   * TODO: clean this up
   */

  hasLinkData: function () {
    var ref, ref1, ref2;
    return !_.isEmpty((ref = this.props.value.link) != null ? ref.href : void 0) || !_.isEmpty((ref1 = this.props.value.link) != null ? ref1.pageID : void 0) || !_.isEmpty((ref2 = this.props.value.link) != null ? ref2.assetID : void 0);
  },

  render: function () {
    var value = this.props.value;
    var width = value.width != null ? "" + value.width : "—";
    var previewURL = this.props.asset.thumbnail_url;
    var aspect = (this.props.asset.correct_width / this.props.asset.correct_height) > 1.4 ? "width" : "height";

    return (
      <div
        className="insertable-display insertable-display-image"
        contentEditable="false"
      >
        <div className="field-asset__display">
          <div className="field-asset__preview">
            <div className="field-asset__display-controls field-asset__display-controls--right">
              <div className="button-group">
                <button
                  className="button insertable-display__edit button button--soft"
                  onClick={ this.props.openAssetSelector }>
                  Change image
                </button>
              </div>
            </div>
            <img
              src={ previewURL }
              className={"field-asset__preview-image field-asset__preview-image--" + aspect}/>
          </div>
          <div className="field-asset__details">
            <div className="field-asset__display-controls field-asset__display-controls--right">
              <div className="button-group">
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
            <dl className="field-details-list">
              <dt>Display</dt>
              <dd>{ value.display || "—" }</dd>
              <dt>Alternate text</dt>
              <dd>{ value.alt_text || "—" }</dd>
              <dt>Caption</dt>
              <dd>{ value.caption || "—" }</dd>
              <dt>Width</dt>
              <dd>{ width }</dd>
              <dt>Show attribution</dt>
              <dd>{ (value.show_attribution === true) ? "Yes" : "No" }</dd>
              <dt>Link</dt>
              <dd>{ (this.hasLinkData()) ? "Yes" : "No" }</dd>
            </dl>
          </div>
        </div>
      </div>
    );
  }
});
