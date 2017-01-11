class App.Login
  constructor: ->
    @page = $('#login_page')
    @body = $('body')
    @add_class_to_body()

  add_class_to_body: ->
    if (@page.length) # check if element exist
      @body.addClass('body-with-image')

$ ->
  app = new App.Login()
