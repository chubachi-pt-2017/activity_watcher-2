
$(function() {
  // team_participantsのチーム編集ページだったら
  if($('#js_team_participants').length) {
    check_content();
    
    $('#js_team_participants').on('cocoon:after-insert', function() {
      check_content();
    });
    
    $('#js_team_participants').on('cocoon:after-remove', function() {
      check_content();
    });
  }
  
});

function check_content() {
  var elements_display = $('#js_team_participants .nested-fields:not(:has(a.destroyed)).nested-fields:has(:visible)');

  if(elements_display.length <= 1) {
    $('#js_team_participants a.remove_fields').hide();
  } else {
    $('#js_team_participants a.remove_fields').show();
  }
  $('#js_team_participants a.add_fields').show();
};

