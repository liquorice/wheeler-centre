/** @jsx React.DOM */

// Stub out the dependencies. These are all filled by stuff in the
// heracles_admin engine.
//= stub lodash
//= stub jquery
//= stub react
//= stub heracles/admin/components/available_insertables

(function() {

  /**
   * Insertable display class
   * Exists _inside_ the TinyMCE iframe we render for ContentFields
   *
   */

  var InsertableFlarumDiscussionDisplay = React.createClass({

    mixins: [InsertableDisplayMixin],

    render: function() {
      return (
        <div className="insertable-display insertable-display-pages" contentEditable="false">
          <div className="insertable-display-pages__details">
            <div className="insertable-display-pages__controls">
              <div className="button-group">
                <button className="button insertable-display__edit button button--soft" onClick={this.editValue}>
                  Edit discussion
                </button>
                <button className="button insertable-display__remove button button--soft" onClick={this.remove}>
                  <i className="fa fa-times"/>
                </button>
              </div>
            </div>
          </div>
        </div>
      );
    },

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

  var InsertableFlarumDiscussionEdit = React.createClass({

    mixins: [InsertableEditMixin],

    render: function() {
      return (
        <div className="insertable-edit fields--reversed">
          <form onSubmit={this.onSubmit}>
            <h2 className="insertable-edit__title">Edit insertable events</h2>
            <div className="field">
              <div className="field-header">
                <label className="field-label" htmlFor="edit__caption">Events</label>
              </div>
              <div className="field-main">
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
            <button type="submit" className="button button--highlight">Save changes to events insertable</button>
          </form>
        </div>
      );
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
    type:    "flarum_discussion",
    label:   "Discussion",
    icon:    "comments",
    display: InsertableFlarumDiscussionDisplay,
    edit:    InsertableFlarumDiscussionEdit
  });

}).call(this);
