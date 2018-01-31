
$(function() {
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
