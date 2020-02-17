/** @jsx React.DOM */

//= require react
//= require jquery
//= require select2

(function() {

  /**
   * Format the Select2 dropdowns
   */

  var formatPages = function(page) {
    return (
      "<div class=\"select2-result__primary\">\n  " + page.title + "<span class=\"field-mono\">&nbsp;/" + page.url + " " + (page.published ? "" : "(unpublished)") + "</span>\n</div>"
    );
  };



  // props: {
  //   page_ids: [1,2,3]
  //   pageType: "event"
  //   pageTypeLabel: "calendar event"
  //   callback: {page_ids, pages}
  // }

  var PagesSelector = React.createClass({

    getDefaultProps: function() {
      return {
        multiple: true,
        page_ids: []
      };
    },

    getInitialState: function() {
      // Initialise if there are no pages
      if (this.props.page_ids.length > 0) {
        this.fetchPages(this.props.page_ids).done(function(data) {
          this.setState({
            pages: _.map(data.pages, this.stripPageData)
          });
        }.bind(this));
      }

      return {
        pages: this.props.pages || []
      };
    },


    componentDidMount: function() {
      this.element = this.getDOMNode();
      this.initAddPageSelector();
      if (this.props.multiple) {
        this.initSortable();
      }
    },

    render: function() {
      var selectedPagesClassNames = React.addons.classSet({
        "selected-pages": true,
        "selected-pages--hide": (this.state.pages.length === 0)
      });

      if (this.props.multiple) {
        return (
          <div>
            <div className="field-associated-pages__form field-addon">
              <input className="field-select2 field-addon-input" type="hidden" ref="input"/>
              <button className="field-addon-button button button--soft" onClick={this.addPageID}>Add this {this.props.pageTypeLabel}</button>
            </div>
            <div className={selectedPagesClassNames} ref="pageList">{this.formatPagesList()}</div>
          </div>
        );
      } else {
        return (
          <div>
            <div className="field-associated-pages__form">
              <input className="field-select2" type="hidden" ref="input" defaultValue={this.props.page_ids.join(",")}/>
            </div>
          </div>
        );
      }

    },

    formatPagesList: function() {
      var showHandles = (this.state.pages.length > 1);
      return _.map(this.state.pages, function(page, index) {
        return (
          <div className="selected-page" key={page.id + "-" + index} data-position={index}>
            <div className="selected-page__controls">
              <div className="button-group">
                {(showHandles) ? <span className="button button--small button--soft selected-page__handle"><i className="fa fa-arrows"/></span> : null}
                <button className="button button button--soft button--small" onClick={this.removeFromSelectedPages.bind(this, index)}>
                  <i className="fa fa-times"/>
                </button>
              </div>
            </div>
            <h2 className="selected-page__title">{page.title} <span className="field-mono">&nbsp;&nbsp;/{page.url}</span></h2>
          </div>
        );
      }.bind(this));
    },

    fetchPages: function(page_ids) {
      var request = $.ajax({
        url: HeraclesAdmin.baseURL + 'api/sites/' + HeraclesAdmin.siteSlug + '/pages/',
        dataType: "json",
        data: {
          page_ids: page_ids
        }
      });
      return request;
    },

    stripPageData: function(page) {
      var propertiesToKeep = ["id", "title", "url"];
      return _.pick(page, propertiesToKeep);
    },

    // Initialise a Select2 instance for the add-page input
    initAddPageSelector: function() {
      var _this = this;
      var inputElement = this.refs.input.getDOMNode();

      var inputSelect = $(inputElement).select2({
        allowClear: true,
        placeholder: "Search for a " + this.props.pageTypeLabel,
        ajax: {
          url: HeraclesAdmin.baseURL + 'api/sites/' + HeraclesAdmin.siteSlug + '/pages',
          dataType: "json",
          // Format data request data
          data: function(term, page) {
            return {
              q: term,
              page: page,
              page_type: _this.props.pageType
            };
          },
          // Clean up results set
          results: function(data, page) {
            // Filter out any pages that are already in the selected set
            var pages = _.filter(data.pages, function(page) {
              index = _.findIndex(_this.state.pages, function(selectedPage) {
                return (page.id === selectedPage.id);
              });
              return (index === -1);
            });
            return {
              results: pages
            };
          },
        },
        initSelection: function(element, callback) {
          // Set the selected state if we're in non-mulitple mode
          if (!_this.props.multiple && _this.props.page_ids) {
            var selectedPage = _this.state.pages[0] || _this.props.pages[0];
            callback(selectedPage);
          }
        },
        // Override default escaping function to leave things un-manipulated
        escapeMarkup: function(m) { return m; },
        formatResult: formatPages,
        formatSelection: formatPages
      });

      // If singular, just handle things with onChange
      if (!this.props.multiple) {
        inputSelect.on("change", this.addPageID.bind(this));
      }

    },

    // Add a selected page to set
    addPageID: function(e) {
      e.preventDefault();
      var inputElement = this.refs.input.getDOMNode();
      var pageID = inputElement.value;
      if (pageID && pageID !== "") {
        // Get the full page data
        var request = this.getPageData(pageID);
        request.done(this.addToSelectedPages);
        // Reset the select2 to empty
        if (this.props.multiple) {
          $(inputElement).select2("val", "");
        }
      }
    },

    // Retrieve the full data for a page
    getPageData: function(pageID) {
      var request = $.ajax({
        url: HeraclesAdmin.baseURL + 'api/sites/' + HeraclesAdmin.siteSlug + '/pages/' + pageID,
        dataType: "json"
      });
      return request;
    },

    addToSelectedPages: function(data) {
      var selectedPages = this.state.pages.slice(0);
      selectedPages.push(
        this.stripPageData(data.page)
      );
      this.setState({
        pages: selectedPages
      });
      this.props.callback(selectedPages);
    },

    removeFromSelectedPages: function(index, e) {
      e.preventDefault();
      var selectedPages = this.state.pages.slice(0);
      selectedPages.splice(index, 1);
      this.setState({pages: selectedPages});
      this.props.callback(selectedPages);
    },

    // Initialise the jquery UI sortable
    initSortable: function() {
      var pageListElement = this.refs.pageList.getDOMNode();
      $(pageListElement).sortable({
        axis: "y",
        handle: ".selected-page__handle",
        items: ".selected-page",
        update: this.onSortableUpdate,
        tolerance: "pointer"
      });
    },

    onSortableUpdate: function(e) {
      // Not ideal using data-attrs, but there’s no easy way to pass this data
      var orderedPages = [];
      var pageListElement = this.refs.pageList.getDOMNode();
      var currentPages = this.state.pages.slice(0);
      $(pageListElement).find("[data-position]").each(function(index) {
        var position = $(this).data("position");
        orderedPages.push(currentPages.slice(position, position + 1)[0]);
      });
      // Attempt to avoid DOM mutation issues with jQuery UI sortables
      this.setState({pages: []});
      this.setState({pages: orderedPages});
      this.props.callback(orderedPages);
    },

  });

  // Add to Heracles.components

  HeraclesAdmin.components.PagesSelector = PagesSelector;

}).call(this);
