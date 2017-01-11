class App.Markers
  constructor: (map)->
    @map = map.getMap()
    @bindEvents()

  iconBase: 'http://maps.google.com/mapfiles/ms/micons/blue-dot.png'
  iconWaypoint: 'http://s9.postimg.org/ag6vhsj1r/truckk.png'
  markers: {}


  bindEvents: () ->
    pubsub.on('create-marker', @createMarker)
    pubsub.on('remove-marker', @removeMarker)

  createMarker: (event) =>
    marker = new MarkerWithLabel
      map: @map
      position: event.position
      draggable: true
      raiseOnDrag: true
      labelContent: event.dataset['zip']
      labelAnchor: new google.maps.Point(15, 65)
      labelClass: @getMarkerClass(event.dataset)
      labelInBackground: false
      icon: 'http://maps.google.com/mapfiles/ms/micons/blue-dot.png'
    @markers[event.dataset['addressId']] = marker
    google.maps.event.addListener(marker, 'click', => @toggleWayPoint(marker, event.dataset ) )

  removeMarker:(event) =>
    marker = @markers[event.dataset['addressId']]
    marker.setMap(null)
    pubsub.emit('remove-waypoint', marker: marker, dataset: event.dataset)

  toggleWayPoint: (marker, dataset)->
    if marker.getIcon() == @iconBase
      marker.setIcon(@iconWaypoint)
      pubsub.emit('create-waypoint', marker: marker, dataset: dataset)
    else
      marker.setIcon(@iconBase)
      pubsub.emit('remove-waypoint', marker: marker, dataset: dataset)

  getMarkerClass: (dataset) ->
    if dataset['type'] == 'from'
      "labels-marker-map-from"
    else
      "labels-marker-map-to"