class App.Directions
  constructor: (map) ->
    @bindEvents()
    @directionsService = new google.maps.DirectionsService
    @directionsDisplay = new google.maps.DirectionsRenderer(
      map: map.getMap()
      draggable: true,
      panel: document.getElementById('right-panel')
    )

  calculateButtonWasClicked = false
  destination: {placeId: 'ChIJI3eyxiaBr0cRzGSUWZmlNTI'}
  origin: {placeId: 'ChIJI3eyxiaBr0cRzGSUWZmlNTI'}
  waypoints: []
  datasets: {}
  distance: 0
  duration: 0

  bindEvents:() ->
    pubsub.on('calculate-route', @calculateRoute)
    pubsub.on('update-waypoints', @updateWaypoints)
    pubsub.on('origin-update', @updateOrigin )
    pubsub.on('destination-update', @updateDestination )
    pubsub.on('save-route', @prepareDataAndSave)

  prepareDataAndSave: (event) =>
    if @calculateButtonWasClicked
      data =
        waypoints: JSON.stringify(@waypoints)
        origin: JSON.stringify(@origin)
        destination: JSON.stringify(@destination)
        order_data: JSON.stringify(@datasets)
        distance: JSON.stringify(@distance)
        duration: JSON.stringify(@duration)
      pubsub.emit('save-data', {data: data})

  updateOrigin: (event) =>
    @origin = {placeId: event.place.place_id}

  updateDestination: (event) =>
    @destination = {placeId: event.place.place_id}

  updateWaypoints:(event) =>
    @waypoints = event.waypoints
    @datasets = event.datasets

  calculateRoute: () =>
    @calculateButtonWasClicked = true
    @directionsService.route(
      origin: @origin
      destination: @destination
      travelMode: 'DRIVING'
      waypoints: @waypoints
    ,(response, status)=>
      if (status == 'OK')
        @directionsDisplay.setDirections(response);
        @calculateTotals(response)
        pubsub.emit('calculate-route-success', {distance: @distance, duration: @duration})
      else
        window.alert('Directions request failed due to ' + status);
    )



  calculateTotals: (response) ->
    for route in response.routes[0].legs
      @distance += route.distance.value
      @duration += route.duration.value


