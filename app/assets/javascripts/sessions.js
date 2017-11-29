
$(function() {
  // 所属大学の子要素があるページだったら
  if($('#user_universities').length) {
    check_content();
    
    $('#user_universities').on('cocoon:after-insert', function() {
      check_content();
    });
    
    $('#user_universities').on('cocoon:after-remove', function() {
      check_content();
    });
  }
  
  // user_thanksページ
  if($('#js-users-thanks').length) {
    // URLにhashを付加してブラウザバックできないようにする
    window.location.hash = "no-back";
    window.location.hash = "no-back-button";
    window.onhashchange = function() {
      window.location.hash = "no-back";
    }
  }
});

function check_content() {
  var elements_display = $('#user_universities .nested-fields:has(:visible)');
  
  if(elements_display.length >= 5) {
    $('#user_universities a.add_fields').hide();
    $('#user_universities a.remove_fields').show();
  } else if(elements_display.length <= 1) {
    $('#user_universities a.add_fields').show();
    $('#user_universities a.remove_fields').hide();
  } else {
    $('#user_universities a.add_fields').show();
    $('#user_universities a.remove_fields').show();
  }
};

