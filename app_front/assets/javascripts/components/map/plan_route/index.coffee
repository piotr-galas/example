class App.PlanRouteMap
  constructor: ($el, map)->
    @$el = $el
    @$zipNodes = $('.zip-field-js-selector')
    @map = map.getMap()
    @customizePageDesign()
    @bindEvents()
    @geocoder = new google.maps.Geocoder

  toggleMarkerClicked: false

  customizePageDesign: () ->
    $('body').addClass('sidebar-collapse')

  bindEvents: ->
    @$el.on 'click', '.zip-field-js-selector', (event) =>
      node = $(event.target)
      @toggleMarker(node)

    @$el.on 'click', '#calculate-route',  (event) =>
      pubsub.emit('calculate-route')

    @$el.on 'click', '#save-route',  (event) =>
      pubsub.emit('save-route')

    @$el.on 'click', '#center-germany',  (event) =>
      pubsub.emit('center-germany')

    @$el.on 'click', '#toggle-markers', (event) =>
      @toggleAllMarkers()

  toggleAllMarkers: () ->
    if @toggleMarkerClicked == true
      @removeAllMarkers()
    else
      @createAllMarkers()

  removeAllMarkers: () ->
    @toggleMarkerClicked = false
    that = @
    @$zipNodes.each( (index) ->
      if $(this).hasClass('clicked')
        setTimeout ( =>
          that.removeMarker($(this)[0].dataset)
          $(this).removeClass('clicked')
        ), 600 * index

    )

  createAllMarkers: () ->
    @toggleMarkerClicked = true
    that = @
    @$zipNodes.each( (index) ->
      unless $(this).hasClass('clicked')
        setTimeout ( =>
          that.createMarker($(this)[0].dataset)
          $(this).addClass('clicked')
        ), 600 * index

    )

  toggleMarker: (node)->
    if node.hasClass('clicked')
      @removeMarker(node[0].dataset)
      node.removeClass('clicked')
    else
      @createMarker(node[0].dataset)
      node.addClass('clicked')

  removeMarker: (dataset)->
    pubsub.emit('remove-marker', dataset: dataset)

  createMarker: (dataset)->
    @geocoder.geocode { componentRestrictions:
      country: 'DE'
      postalCode: dataset['zip']
      route: dataset['street']
    }, (results, status) =>
      if status == 'OK'
        pubsub.emit('create-marker', { position: results[0].geometry.location, dataset: dataset })
      else
        @createMarkerWithoutStreet(dataset)
        window.alert 'Street was not find: ' + status

  createMarkerWithoutStreet: (dataset)->
    @geocoder.geocode { componentRestrictions:
      country: 'DE'
      postalCode: dataset['zip']
    }, (results, status) =>
      if status == 'OK'
        pubsub.emit('create-marker', { position: results[0].geometry.location, dataset: dataset })
      else
        window.alert 'Geocode was not successful for the following reason: ' + status


@initPlanRouteMap = =>
  @pubsub = new App.PubSub()
  map = new App.Map()
  new App.PlanRouteMap($(document), map)
  new App.AutocomplieteInputs($(document), map)
  new App.Markers(map)
  new App.Waypoints
  new App.Directions(map)
  new App.DisplayData($('#total-distance'), $('#total-time'))
  new App.Save