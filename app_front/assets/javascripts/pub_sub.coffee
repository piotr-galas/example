class App.PubSub
  events: {}
  on: (eventName, fn)->
    @events[eventName] = @events[eventName] || []
    @events[eventName].push(fn)

  emit: (eventName, data) ->
    if (@events[eventName])
      @events[eventName].forEach((fn)-> fn(data))