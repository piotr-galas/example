class App.ToggleSearch
  constructor: ->
    @assignDomVariables()
    @bindEvents()

  assignDomVariables: ->
    @toggle_trigger = $("#toggle-control-bar-trigger");
    @toggle_element = $("#toggle-control-bar")

  bindEvents: ->
    @toggle_trigger.on 'click', (e) =>
      e.preventDefault()
      @toggle()

  toggle: ->
    @toggle_element.toggleClass('control-bar-show')


$(document).on "turbolinks:load", ->
    toggleSearch = new App.ToggleSearch();
    $.AdminLTE.layout.activate();