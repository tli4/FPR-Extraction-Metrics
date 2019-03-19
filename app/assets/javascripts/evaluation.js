// Javascript for the evaluation controller

$(document).ready(function() {
  $('select#evaluation_instructor_id').on('change', function() {
    if ($(this).val() == 0) {
      $('#instructor_select_wrapper').hide();
      $('#instructor_name_wrapper').show();
    }
  });

  $('a#cancel_manual_instructor_entry').on('click', function(e) {
    e.preventDefault();
    select_box = $('select#evaluation_instructor_id');
    select_box.val(select_box.children()[0].value);
    $('#instructor_select_wrapper').show();
    $('#instructor_name_wrapper').hide();
  })
});
