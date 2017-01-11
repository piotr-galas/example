class App.Waypoints
  constructor:() ->
    @bindEvents()

  waypointsHash: {}
  waypoints: []
  datasets: []
  datasetsHash: {}

  bindEvents:()->
    pubsub.on('create-waypoint', @createWaypoint )
    pubsub.on('remove-waypoint', @removeWaypoint )

  createWaypoint:(event) =>
    waypoint =
      location: event.marker.getPosition()
      stopover: false
    @waypointsHash[event.marker.labelContent] = waypoint
    @datasetsHash[event.dataset['addressId']] = event.dataset
    @emitWaypointsChange()

  removeWaypoint:(event) =>
    delete @waypointsHash[event.marker.labelContent]
    delete @datasetsHash[event.dataset['addressId']]
    @emitWaypointsChange()

  emitWaypointsChange: ->
    @convertToArray()
    pubsub.emit('update-waypoints', waypoints: @waypoints, datasets: @datasets)

  convertToArray: () ->
    @waypoints = []
    for zip, waypoint of @waypointsHash
      @waypoints.push(waypoint)
    @datasets = []
    for addresId, dataset of @datasetsHash
      @datasets.push(dataset)