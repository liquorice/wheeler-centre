#= require lodash
#= require react
#= require momentjs
#= require pikaday
#= require jquery
#= require jstimezonedetect
#= require jquery-timepicker-jt
#= require select2

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

window.FieldDateTime = React.createClass
  mixins: [FieldMixin]
  propTypes:
    value_date: React.PropTypes.string
    value_time: React.PropTypes.string
    time_zone: React.PropTypes.string
  getInitialState: ->
    formattedDate = if @props.value_date? and @props.value_date != ""
      moment(@props.value_date, "YYYY-MM-DD").format "D/M/YYYY"
    else
      @props.value_date

    field: @props.field
    value_date: formattedDate
    value_time: @props.value_time
    time_zone: @props.time_zone
    isDateOnly: @props.field.field_config.field_is_date_only
  componentDidMount: ->
    timeZone = jstz.determine()
    @userTimeZone = timeZone.name().split("/")[1]

    # Set up Pikaday datepicker
    datePicker = new Pikaday
      field: @refs.date.getDOMNode()
      format: "D/M/YYYY"
      onSelect: =>
        # Manually update
        @handleChange "value_date",
          target:
            value: datePicker.toString()

    # Set up timepicker
    timePicker = $(@refs.time.getDOMNode()).timepicker
      step: 15
    timePicker.on "change", (e) => @handleChange "value_time", e

    # Set up the timeZonePicker
    @timeZonePicker = $(@refs.timeZone.getDOMNode()).select2
      allowClear: true
    @timeZonePicker.on "change", (e) => @handleChange "time_zone", e

    # Activate the fieldAddons
    $el = $(@getDOMNode())
    new FieldAddon $el.find('.field-date-time__date'), -> datePicker.show()
    new FieldAddon $el.find('.field-date-time__time')
    new FieldAddon $el.find('.field-date-time__time-zone'), -> @timeZonePicker.select2("open")

  handleChange: (attrName, event, value) ->
    # Override only the field data that changes
    newAttrs = {}
    newAttrs[attrName] = value || event.target.value
    newField = _.extend {}, @state.field, newAttrs

    # Remove the combined datetime value when passing changes back up. The
    # separated date, time and zone values will allow this to be reconstructed
    # anyway, and we need to allow the behaviour of clearing those separate
    # fields to remove the datetime value altogether.
    delete newField.value

    @props.updateField @state.field.field_name, newField
    @setState _.extend {}, field: newField, newAttrs

  buildTimeZoneOptions: ->
    options = _.map @props.field.available_time_zones, (zone, name) ->
      `<option key={name} value={name}>{zone}</option>`
  formatFallback: ->
    if @state.field.field_config.field_fallback?.value_date? and @state.field.field_config.field_fallback?.value_time? and @state.field.field_config.field_fallback?.time_zone?
      """
        #{moment(@state.field.field_config.field_fallback.value_date, "YYYY-MM-DD").format "D/M/YYYY"}
        #{@state.field.field_config.field_fallback.value_time}
        #{@state.field.field_config.field_fallback.time_zone}
      """
  render: ->
    timeZoneOptions = @buildTimeZoneOptions()
    timeStyle = if @state.isDateOnly
      display: "none"
    setToNowText = if @state.isDateOnly
      "Set to today"
    else
      "Set to now"
    `<div className={this.displayClassName("field-date-time")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <div className="field-addon field-date-time__date">
            <div className="field-addon-text">
              <i className="fa fa-calendar"/>
            </div>
            <input className="field-text-input field-addon-input" ref="date" value={this.state.value_date} onChange={this.handleChange.bind(this, "value_date")} placeholder="dd/mm/yyyy"/>
          </div>
          <div className="field-addon field-date-time__time" style={timeStyle}>
            <div className="field-addon-text">
              <i className="fa fa-clock-o"/>
            </div>
            <input className="field-text-input field-addon-input" ref="time" value={this.state.value_time} onChange={this.handleChange.bind(this, "value_time")} placeholder="hh:mm"/>
          </div>
          <div className="field-addon field-date-time__time-zone" style={timeStyle}>
            <div className="field-addon-text">
              <i className="fa fa-map-marker"/>
            </div>
            <select className="field-select2 field-addon-input" ref="timeZone" value={this.state.time_zone} onChange={this.handleChange.bind(this, "time_zone")} placeholder="Select a time zone">
              <option/>
              {timeZoneOptions}
            </select>
          </div>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <div className="field-date-time__actions">
          <button className="field-date-time__now button button--soft button--small" onClick={this._setTimeToNow}>{setToNowText}</button>
          <button className="field-date-time__user-timezone button button--soft button--small" style={timeStyle} onClick={this._setTimeZone}>Set to your timezone</button>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`

  _setTimeToNow: (e) ->
    e.preventDefault()
    date = moment()
    # Override only the field data that changes
    newAttrs = {}
    newAttrs.value_date = date.format "D/M/YYYY"
    newAttrs.value_time = date.format "h:mma"
    newAttrs.time_zone = @userTimeZone
    @timeZonePicker.select2 "val", @userTimeZone
    newField = _.extend {}, @state.field, newAttrs

    # Remove the combined datetime value when passing changes back up. The
    # separated date, time and zone values will allow this to be reconstructed
    # anyway, and we need to allow the behaviour of clearing those separate
    # fields to remove the datetime value altogether.
    delete newField.value

    @props.updateField @state.field.field_name, newField
    @setState _.extend {}, field: newField, newAttrs

  _setTimeZone: (e) ->
    e.preventDefault()
    @timeZonePicker.select2 "val", @userTimeZone
    @handleChange "time_zone", null, @userTimeZone


# Register as available
HeraclesAdmin.availableFields.add
  editorType: "date_time"
  formatProps: (data) ->
    key: data.key
    newRow: data.newRow
    updateField: data.updateField
    field: data.field
    value_date: data.field.value_date
    value_time: data.field.value_time
    time_zone: data.field.time_zone
  component: FieldDateTime
