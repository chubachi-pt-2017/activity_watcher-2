
$(function() {
  // team_participantsの子要素があるページだったら
  if($('#team_participants').length) {
    check_content();
    
    $('#team_participants').on('cocoon:after-insert', function() {
      check_content();
    });
    
    $('#team_participants').on('cocoon:after-remove', function() {
      check_content();
    });
  }
  
});

function check_content() {
  var elements_display = $('#team_participants .nested-fields:not(:has(a.destroyed)).nested-fields:has(:visible)');

  if(elements_display.length <= 1) {
    $('#team_participants a.add_fields').show();
    $('#team_participants a.remove_fields').hide();
  } else {
    $('#team_participants a.add_fields').show();
    $('#team_participants a.remove_fields').show();
  }
};

