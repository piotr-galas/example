class App.Save
  constructor:() ->
    @bindEvents()

  bindEvents: () ->
    pubsub.on('save-data', @sendDataToServer )

  sendDataToServer:(event) ->
    $.ajax '/routes',
      type: "POST"
      dataType: 'json'
      data: event.data
      success: (data) ->
        alert('Route save success')
        Turbolinks.visit('/routes/'+ data.id)
      error: (data) ->
        console.log(data)