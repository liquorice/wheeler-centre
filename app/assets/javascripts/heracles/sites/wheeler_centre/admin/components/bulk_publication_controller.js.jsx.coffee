###* @jsx React.DOM ###

"use strict"

HeraclesAdmin.views.bulkPublicationController = ($el, el) ->
  # Kick start the React component
  $form = $el.find(".form")
  React.renderComponent BulkForm(), $form[0]

#
# BulkForm React component
#
BulkForm = React.createClass

  render: ->
    `<div>
      <div className="bulk-publication-search">
        <input id="bulk-publication-search" className="field-text-input bulk-publication-search-input" placeholder="Search for publications by tag ..." type="search" />
        <label htmlFor="bulk-publication-search" className="bulk-publication-search-label"><i className="fa fa-search"></i></label>
      </div>
      <div className="bulk-publication-scope">
        <RadioGroup name="fields" value={this.fieldsValue} onChange={this.fieldsChange}>
          among
          <label className="bulk-publication-scope-label">
            <input type="radio" value="unpublished" />
            unpublished
          </label>
          <label className="bulk-publication-scope-label">
            <input type="radio" value="published" />
            published
          </label>
        </RadioGroup>
      </div>
    </div>`

