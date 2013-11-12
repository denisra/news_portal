# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('[data-behaviour~=datepicker]').datepicker({
  	todayBtn: "linked",
  	language: "pt-BR",
  	format: "dd/mm/yyyy",
  	orientation: "top right",
  	autoclose: "true",
  	todayHighlight: "true"

  });