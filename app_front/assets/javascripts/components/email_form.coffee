class App.EmailForm
  constructor: ->
    @assignDomVariables()
    @bindEvents()

  assignDomVariables: ->
    @modals = $('.modal')
  bindEvents: ->
    @modals.on 'show.bs.modal',  (event)=>
      @assignModalElements(event)
    $(document).on 'ajax:success', @emailForm, () =>
      Turbolinks.visit(location.toString());
    $(document).on 'ajax:error', @emailForm, (event, xhr, status, error) =>
      alert(xhr.responseText)

  bindModalEvents: ->
    @submitButton.on 'click', (event)=>
      @modals.modal('hide')

  assignModalElements:(event) =>
    @emailForm = $(event.target).find('form')
    @submitButton = @emailForm.find('button[type="submit"]')
    @bindModalEvents()

$(document).on "turbolinks:load page:change", ->
  emailFrom = new App.EmailForm();