var calendar_initialized;
calendar_initialized = function(){
  $('.calendar').each(function(){
    var calendar = $(this)
  })
};
$(document).on("turbolinks:load", calendarize);
