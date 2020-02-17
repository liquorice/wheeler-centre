//=require lodash
//=require jquery
//=require react

//=require heracles/admin/components/available_insertables
//=require heracles/admin/lightboxes/lightbox
//=require heracles/admin/lightboxes/lightbox__asset_selector

/** @jsx React.DOM */

var InsertableButtonDisplay = React.createClass({

  // consume mixins
  mixins: [_.extend({}, InsertableDisplayMixin)],

  render: function () {
    return (
      <div className="insertable-display-button">
        <div className="field-asset__display py-xsm">
          <div className="column-left px-xsm">
            <span className="btn">{ this.props.value.text }</span>
          </div>
          <div className="column-right insertable-details">
            <div className="insertable-details__item px-xsm">
              <dl className="field-details-list">
                <dt>Position</dt>
                <dd>{ this.state.value.position || "Default" }</dd>
              </dl>
            </div>
            <div className="insertable-details__item px-xsm">
              <dl className="field-details-list">
                <dt>Size</dt>
                <dd>{ this.state.value.size || "Default" }</dd>
              </dl>
            </div>
            <div className="insertable-details__item px-xsm">
              <dl className="field-details-list">
                <dt>Color</dt>
                <dd>{ this.state.value.color || "Default" }</dd>
              </dl>
            </div>
            <div className="insertable-details__item px-xsm">
              <dl className="field-details-list">
                <dt>Link</dt>
                <dd>{ this.state.value.link }</dd>
              </dl>
            </div>
          </div>
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
        </div>
      </div>
    )
  }
})

var InsertableButtonEdit = React.createClass({

  // consume global mixin
  mixins: [ InsertableEditMixin ],

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
   * onLinkChange
   * Assign data to this.state.value.link prop
   * @param  {String} type : "link"
   * @param  {Object} data : {href: "...", title: "..."}
   */

  onLinkChange: function (type, data) {
    var value = this.state.value;
    value.link = data;
    this.setState({
      value: value
    });
  },

  /**
   * render
   * @return {Node}
   */

  render: function () {
    return (
      <div className="insertable-edit fields--reversed">
        <form onSubmit={ this.onSubmit }>
          <h2 className="insertable-edit__title">Edit image details</h2>

          <div className="field">
            <div className="field-header">
              <label
                className="field-label"
                htmlFor="edit__button-text">Button text</label>
            </div>
            <div className="field-main">
              <input
                ref="alt"
                id="edit__button-text"
                className="field-text-input"
                value={ this.props.value.text }
                onChange={ this.handleChange.bind(this, "text") }
                placeholder="Enter button text"/>
            </div>
          </div>

          <div className="field">
            <div className="field-header">
              <label className="field-label">Link</label>
            </div>
            <div className="field-name">
              <FieldContentInlineEditor
                type="link"
                data={ this.state.value.link }
                callback={ this.onLinkChange }
                withForm={false}/>
            </div>
          </div>

          <div className="field">
            <div className="field-header">
              <label
                className="field-label"
                htmlFor="edit__width">Size</label>
            </div>
            <div className="field-main">
              <select
                ref="alt"
                id="edit__width"
                className="field-select"
                value={ this.state.value.size }
                onChange={ this.handleChange.bind(this, "size") }>
                <option/>
                <option>Default</option>
                <option>Small</option>
                <option>Large</option>
              </select>
            </div>
          </div>

          <div className="field">
            <div className="field-header">
              <label
                className="field-label"
                htmlFor="edit__position">Position</label>
            </div>
            <div className="field-main">
              <select
                ref="alt"
                id="edit__position"
                className="field-select"
                value={ this.state.value.position }
                onChange={ this.handleChange.bind(this, "position") }>
                <option/>
                <option>Default</option>
                <option>Left</option>
                <option>Right</option>
                <option>Center</option>
                <option>Full</option>
              </select>
            </div>
          </div>

          <div className="field">
            <div className="field-header">
              <label
                className="field-label"
                htmlFor="edit__color">Colour</label>
            </div>
            <div className="field-main">
              <select
                ref="alt"
                id="edit__color"
                className="field-select"
                value={ this.state.value.color }
                onChange={ this.handleChange.bind(this, "color") }>
                <option/>
                <option>Default</option>
                <option>Primary</option>
                <option>Secondary</option>
                <option>Tertiary</option>
              </select>
            </div>
          </div>

          <button
            type="submit"
            className="button button--highlight">Save changes to button</button>
        </form>
      </div>
    )
  }
})

HeraclesAdmin.availableInsertables.add({
  type: "button",
  label: "Button",
  icon: "dot-circle-o",
  display: InsertableButtonDisplay,
  edit: InsertableButtonEdit
});
