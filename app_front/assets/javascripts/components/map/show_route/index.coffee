class App.ShowRouteMap
  waypoints: []
  origin: {}
  direction: {}

  constructor: ($el, map) ->

    @$el = $el
    @directionsService = new google.maps.DirectionsService
    @directionsDisplay = new google.maps.DirectionsRenderer(
      map: map.getMap()
      draggable: true,
      panel: $el[0].getElementById('right-panel')
    )
    @getMapData()
    @showRoute()



  getMapData: ->
    dataset = $('#map-data')[0].dataset
    @waypoints = @createWaypoints(JSON.parse(dataset.waypoints))
    @origin = JSON.parse(dataset.origin)
    @destination = JSON.parse(dataset.destination)

  createWaypoints:(waypointsUnformated) ->
    waypointArray = []
    for index, waypointUnformated of waypointsUnformated
      waypoint =
        location: new google.maps.LatLng(waypointUnformated['location'])
        stopover: false
      waypointArray.push(waypoint)
    @waypoints = waypointArray


  showRoute: () =>
    @directionsService.route(
      origin: @origin
      destination: @destination
      travelMode: 'DRIVING'
      waypoints: @waypoints
    ,(response, status)=>
      if (status == 'OK')
        @directionsDisplay.setDirections(response);
      else
        window.alert('Directions request failed due to ' + status);
    )

@initShowRouteMap = =>
  @pubsub = new App.PubSub()
  map = new App.Map()
  new App.ShowRouteMap($(document), map)