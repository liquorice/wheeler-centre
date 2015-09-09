/** @jsx React.DOM */

// Stub out the dependencies. These are all filled by stuff in the
// heracles_admin engine.
//= stub lodash
//= stub jquery
//= stub react
//= stub heracles/admin/components/available_insertables
//= stub heracles/admin/components/pages_selector

(function() {

  // Utilities

  var PagesSelector = HeraclesAdmin.components.PagesSelector;

  // Override the standard insertable display mixin
  var InsertablePeoplePagesDisplayMixin = _.extend({}, InsertableDisplayMixin, {

    getInitialState: function() {
      var value = _.extend({}, {pages: [], page_ids: []}, this.props.value);
      return {
        size:  this.props.size || "30",
        value: value
      };
    },

    // Override the `isEmpty` method in the display mixin
    isEmpty: function(value) {
      return _.isEmpty(value.page_ids);
    }

  });


  /**
   * Insertable display class
   * Exists _inside_ the TinyMCE iframe we render for ContentFields
   *
   */

  var InsertablePeoplePagesDisplay = React.createClass({

    mixins: [InsertablePeoplePagesDisplayMixin],

    render: function() {
      return (
        <div className="insertable-display insertable-display-pages" contentEditable="false">
          <div className="insertable-display-pages__details">
            <div className="insertable-display-pages__controls">
              <div className="button-group">
                <button className="button insertable-display__edit button button--soft" onClick={this.editValue}>
                  Edit people
                </button>
                <button className="button insertable-display__remove button button--soft" onClick={this.remove}>
                  <i className="fa fa-times"/>
                </button>
              </div>
            </div>
            {this.formatPages()}
          </div>
        </div>
      );
    },

    formatPages: function() {
      if (this.state.value.pages && this.state.value.pages.length > 0) {
        var pages =  _.map(this.state.value.pages, function(page) {
          return (
            <li>
             <p className="insertable-display-pages__page-title">{page.title}</p>
             <p className="insertable-display-pages__page-url">/{page.url}</p>
            </li>
          );
        });
        var displayValue = this.state.value.display || "Default";
        return (
          <div className="insertable-display-pages__content">
            <div className="insertable-display-pages__pages">
              <dl className="field-details-list">
                <dt>Selected people</dt>
                <dd>
                  <ul className="insertable-display-pages__list">
                    {pages}
                  </ul>
                </dd>
              </dl>
            </div>
            <div className="insertable-display-pages__meta">
              <dl className="field-details-list">
                <dt>Display</dt>
                <dd>{this.state.value.display || "—"}</dd>
                <dt>Title</dt>
                <dd>{this.state.value.title || "—"}</dd>
              </dl>
            </div>
          </div>
        );
      } else {
        return (
          <p className="insertable-display-pages__empty">No people selected</p>
        );
      }
    }

  });


  // Override the standard insertable edit mixin
  var InsertablePeoplePagesEditMixin = _.extend({}, InsertableEditMixin, {
    getInitialState: function() {
      var value = _.extend({}, {pages: [], page_ids: []}, this.props.value);
      return {
        value: value
      };
    }
  });

  /**
   * Insertable edit class
   * Rendered into the sidebar
   *
   * Expected `state.value`:
   *    page_ids: []
   *    display_as: "grid/list/"
   *    display_position: "left/right/full-width"
   */

  var InsertablePeoplePagesEdit = React.createClass({

    mixins: [InsertablePeoplePagesEditMixin],

    render: function() {
      return (
        <div className="insertable-edit fields--reversed">
          <form onSubmit={this.onSubmit}>
            <h2 className="insertable-edit__title">Edit insertable people</h2>
            <div className="field">
              <div className="field-header">
                <label className="field-label" htmlFor="edit__caption">People</label>
              </div>
              <div className="field-main">
                <PagesSelector pageTypeLabel="person" pageType="person" page_ids={this.state.value.page_ids} callback={this.onPagesSelectorUpdate}/>
              </div>
            </div>
            <div className="field">
              <div className="field-header">
                <label className="field-label" htmlFor="edit__title">Title</label>
              </div>
              <div className="field-main">
                <input ref="title" id="edit__title" className="field-text-input" value={this.state.value.title} onChange={this.handleChange.bind(this, "title")} placeholder="Title"/>
              </div>
            </div>
            <div className="field">
              <div className="field-header">
                <label className="field-label" htmlFor="edit__display">Display</label>
              </div>
              <div className="field-main">
                <select ref="alt" id="edit__display" className="field-select" value={this.state.value.display} onChange={this.handleChange.bind(this, "display")}>
                  <option/>
                  <option value="Left-aligned">Left column</option>
                  <option value="Right-aligned">Right column</option>
                  <option value="Right-aligned-narrow">Right column (narrow)</option>
                  <option>Grid narrow</option>
                  <option>Grid mid</option>
                  <option>Grid wide</option>
                  <option value="Full-width">Grid full-width</option>
                </select>
              </div>
            </div>
            <button type="submit" className="button button--highlight">Save changes to people insertable</button>
          </form>
        </div>
      );
    },

    onPagesSelectorUpdate: function(pages) {
      var value = _.extend({}, this.state.value, {
        page_ids: _.map(pages, function(page) { return page.id; }),
        pages: pages
      });
      this.setState({
        value: value
      });
    },

    handleChange: function(ref, e) {
      this.state.value[ref] = e.target.value;
      this.setState({value: this.state.value});
    }

  });


  /**
   * Register the insertable in Heracles
   */

  HeraclesAdmin.availableInsertables.add({
    type:    "people_pages",
    label:   "People",
    icon:    "user",
    display: InsertablePeoplePagesDisplay,
    edit:    InsertablePeoplePagesEdit
  });

}).call(this);
