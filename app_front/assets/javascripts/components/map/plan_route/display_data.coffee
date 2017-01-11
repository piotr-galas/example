class App.DisplayData
  constructor: ($totalDistance, $totalTime) ->
    @$totalDistance = $totalDistance
    @$totalTime = $totalTime
    @bindEvents()

  bindEvents: () ->
    pubsub.on('calculate-route-success', @displayTotal)

  displayTotal: (event) =>
    @$totalDistance.html(parseInt(event.distance/1000))
    @$totalTime.html(@secondsToHms(event.duration))

  secondsToHms: (d) ->
    d = Number(d)
    h = Math.floor(d / 3600)
    m = Math.floor(d % 3600 / 60)
    s = Math.floor(d % 3600 % 60)
    (if h > 0 then h + ':' + (if m < 10 then '0' else '') else '') + m + ':' + (if s < 10 then '0' else '') + s
