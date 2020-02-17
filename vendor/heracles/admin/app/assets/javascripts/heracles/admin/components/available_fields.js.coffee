# Singleton class for storing and accessing the React field components
# Each field needs to define a `formatProps` method
class AvailableFields
  constructor: ->
    @fields = []
  add: (field) ->
    unless field.formatProps?
      field.formatProps = (data) ->
        key: data.key
        newRow: data.newRow
        updateField: data.updateField
        field: data.field
        value: data.field.value
    @fields.push(field)
  get: (editorType, propData) ->
    for field in @fields
      if field.editorType is editorType
        return field.component(field.formatProps(propData))

# Attach the instance to the app object
HeraclesAdmin.availableFields = new AvailableFields()
