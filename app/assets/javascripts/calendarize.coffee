# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
alert("asdfasdfdfa2222")

# jQuery(document).on('turbolinks:load',->
#   $('.best_in_place').best_in_place()
#
#   $('#activity_type').autocomplete
#     source: $('#activity_type').data('autocomplete-source')
#
#   $('#activity_for').autocomplete
#     source: $('#activity_for').data('autocomplete-source')
#
#   $('#member').autocomplete
#     source: $('#member').data('autocomplete-source')
#
#   $("#meeting_form_link").click(->
#     $('#newmeetingform').removeAttr("hidden")
#     $('#meeting_form_link').attr("hidden",true)
#   )
#
#   $('.calendar').each(->
#     calendar = $(this)
#     calendar.fullCalendar({
#       header: {
#         left: 'prev,next today',
#         center: 'title',
#         right: 'month,agendaWeek,agendaDay'
#       },
#       selectable: true,
#       selectHelper: true,
#       editable: true,
#       eventLimit: true,
#       events: "/calendarize/event.json?activity_id="+getParams()["activity_id"]+"&meeting_id="+getParams()["meeting_id"]
#       select: (start, end)->
#         $('#start_time').val(moment(start).format("YYYY-MM-DD HH:mm:ss"))
#         $('#end_timing').val(moment(end).format("YYYY-MM-DD HH:mm:ss"))
#         $('#timing_form').show()
#         $('#edit_timing_form').hide()
#         calendar.fullCalendar('unselect')
#       eventDrop: (event, delta, revertFunc)->
#         event_data = {
#           event: {
#             id: event.id,
#             start: event.start.format()
#             end: event.end.format()
#           }
#         }
#         $.ajax({
#           url: "/calendarize/edit?edit_type=availabletime",
#           data: event_data,
#           type: 'PATCH'
#           })
#       eventClick: (event, jsEvent, view) ->
#         $('#edit_timing_for').val(event.title)
#         $('#edit_start_time').val(event.start.format())
#         $('#edit_end_timing').val(event.end.format())
#         $('#edit_availabletime_id').val(event.id)
#         $('#delete_availabletime_id').val(event.id)
#         $('#timing_form').hide()
#         $('#edit_timing_form').show()
#     })
#   )
# )
#
# getParams = ->
#   query = window.location.search.substring(1)
#   raw_vars = query.split("&")
#
#   params = {}
#
#   for v in raw_vars
#     [key, val] = v.split("=")
#     params[key] = decodeURIComponent(val)
#   console.log(params)
#   params
