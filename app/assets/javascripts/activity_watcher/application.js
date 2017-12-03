// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require_tree .

$(function() {
  // 途中から固定したいボックスの情報を得る
  var navBox = $("#js-sidebar");
  var navOst = navBox.offset().top;

  // スクロールされた際に実行
  $(window).scroll( function() {
     // 現在のスクロール位置と、固定したいボックスの位置を比較
     if( $(window).scrollTop() > navOst ) {
        // 固定用のclassを付加
        navBox.addClass("fixBox");
     }
     else {
        // 固定用のclassを削除
        navBox.removeClass("fixBox");
     }
  });
});