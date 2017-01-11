class App.AutocomplieteInputs
  constructor: (el, map)->
    @$el = el
    @map = map.getMap()
    @assignDomInputs()
    @moveInputsToMap()
    @assignAutocompleteToIputs()
    @addListenersToAutocomplete()

  assignDomInputs: ->
    @startInput  = $('#start-input')[0]
    @endInput  = $('#end-input')[0]

  assignAutocompleteToIputs: ->
    @autocompleteStart = new google.maps.places.Autocomplete(@startInput)
    @autocompleteEnd = new google.maps.places.Autocomplete(@endInput)
    @autocompleteStart.bindTo('bounds', @map)
    @autocompleteEnd.bindTo('bounds', @map)

  addListenersToAutocomplete: ->
    @autocompleteStart.addListener('place_changed', =>
      pubsub.emit('origin-update', place: @autocompleteStart.getPlace())
    )
    @autocompleteEnd.addListener('place_changed', =>
      pubsub.emit('destination-update', place: @autocompleteEnd.getPlace())
    )

  moveInputsToMap: ->
    @map.controls[google.maps.ControlPosition.TOP_LEFT].push(@startInput);
    @map.controls[google.maps.ControlPosition.TOP_LEFT].push(@endInput);