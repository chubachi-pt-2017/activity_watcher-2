$(function(){
  if($("#js-task-title-count").length) {
    // 課題名のテキストカウンター
    var titleCount = $("#js-task-title-count");
    var taskTitle = $("#js-task-title");
    titleCount.text(taskTitle.val().length);
  
    taskTitle.on("keyup", function() {
      titleCount.text(taskTitle.val().length);
      set_alert_before_transition();
    });
  
    // 課題詳細のテキストカウンター
    var detailTextCount = $("#js-task-detail-count");
    var detailText = $("#js-task-detail");
    detailTextCount.text(detailText.val().length);
  
    detailText.on("keyup", function() {
      detailTextCount.text(detailText.val().replace(/[\n\s　]/g, "").length);
      set_alert_before_transition();
    });
    
    $("#js-submit-button").on("click", function(){
      $(window).off('beforeunload');
    });
  }
})

function set_alert_before_transition() {
  $(window).off('beforeunload');
  $(window).on('beforeunload', function(e) {
    return "";
  });
}