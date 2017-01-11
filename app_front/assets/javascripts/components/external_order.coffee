#requester_type_radio\
class App.ExternalOrder
  constructor: ($select)->
    @$select = $select
    @assignDom()
    @uncheckAllInputs()
    @bindEvents()
    @hideInvoiceForm()

  assignDom: ->
    @$receiverInput = @$select.find('#order_requester_type_requester_receiver')
    @$consignorInput = @$select.find('#order_requester_type_requester_consignor')
    @$companyInput = @$select.find('#order_requester_type_requester_company')
    @$invoiceContainer = $('.external-form__form-container__invoice-address')
    @$invoiceInputs = @$invoiceContainer.find('.external-form__form-container__address__inputs-container').find('input')

  uncheckAllInputs: ->
    @$receiverInput.prop('checked', false)
    @$consignorInput.prop('checked', false)
    @$companyInput.prop('checked', false)

  bindEvents: ->
    @$receiverInput.on('click', => @fillAddress('start'))
    @$consignorInput.on('click', => @fillAddress('destination'))
    @$companyInput.on('click', => @$invoiceContainer.show())

  fillAddress: (type)=>
    @$invoiceContainer.show();
    for input in @$invoiceInputs
      $(input).val( @addressValue(input, type))

  addressValue: (input, type) ->
    id = @replaceAt(input.id, 27, 1) if type == 'start'
    id = @replaceAt(input.id, 27, 0) if type == 'destination'

    $('#' + id ).val()

  replaceAt: (string, n, replaceWith) ->
     string.substring(0, n) + replaceWith + string.substring(n + 1);

  hideInvoiceForm: ()->
    @$invoiceContainer.hide() if @isInvoiceFormEmpty() && !$('#error_explanation').length

  isInvoiceFormEmpty: ->
    for input in @$invoiceInputs
      return false unless $(input).val() == ''
    true


$(document).on "turbolinks:load page:change", ->
  $select = $('#requester_type_radio')
  if $select.length
    new App.ExternalOrder($select);