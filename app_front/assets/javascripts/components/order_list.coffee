class App.OrderList
  constructor: ($select, $searchForm)->
    @$select = $select
    @$searchForm = $searchForm
    @initSelect2()
    @bindEvents()

  initSelect2: () ->
    @$select.select2
      minimumResultsForSearch: -1
      theme: "bootstrap"
      templateSelection: @formatStatus

  formatStatus: (status) =>
    $("<span class='status-selected-element'>" + status.text + " </span><i class='"+ @iconClass(status.id)+ "'></i>")

  iconClass: (status) ->
    switch status
      when 'archived' then 'fa fa-archive'
      when 'deleted' then 'fa fa-ban'
      when 'partially_finished' then 'fa fa-motorcycle'
      when 'created' then 'fa fa-envelope'
      when 'processed' then 'fa fa-exchange'
      when 'finished' then 'fa fa-money'
      else  'fa fa-circle'

  bindEvents: () ->
    $(document).on 'change', @$select,  (event) =>
      @$searchForm.submit()
    $(document).on 'select2:unselecting', @$select,  (event) ->
      $(document).on 'select2:opening', @$select,  (event) ->
        event.preventDefault()


$(document).on "turbolinks:load page:change", ->
  $select = $('#order-list-select-statuses')
  $searchForm = $('#search-form')
  if $select.length
    new App.OrderList($select, $searchForm);