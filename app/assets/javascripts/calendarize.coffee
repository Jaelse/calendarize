# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(document).on('turbolinks:load',->
  $('#activity_type').autocomplete
    source: $('#activity_type').data('autocomplete-source')

  $('#activity_for').autocomplete
    source: $('#activity_for').data('autocomplete-source')

  $('#member').autocomplete
    source: $('#member').data('autocomplete-source')

  $("#meeting_form_link").click(->
    $('#newmeetingform').removeAttr("hidden");
    $('#meeting_form_link').attr("hidden",true);
  )
)
