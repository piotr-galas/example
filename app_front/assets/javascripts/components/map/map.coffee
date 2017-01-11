class App.Map
  constructor:() ->
    @initMap()
    @bindEvents()

  startPosition: {lat: 50.95, lng: 6.64}
  zoom: 6

  bindEvents: ->
    pubsub.on('center-germany', @centerGermany)

  centerGermany: =>
    @map.setZoom(@zoom)
    @map.setCenter(@startPosition)



  initMap: ->
    @map = new google.maps.Map(document.getElementById('map'), {
      center: @startPosition,
      zoom: @zoom
      mapTypeId: google.maps.MapTypeId.ROADMAP
      mapTypeControl: false
    });

  getMap:() ->
    @map