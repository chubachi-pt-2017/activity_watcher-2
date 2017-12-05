$(function(){
    // コース名のテキストカウンター
    var titleCount = $("#js-course-title-count");
    var courseTitle = $("#js-course-title");
    titleCount.text(courseTitle.val().length);
  
    courseTitle.on("keyup", function() {
      titleCount.text(courseTitle.val().length);
    });
  
    // コース詳細のテキストカウンター
    var detailTextCount = $("#js-course-detail-count");
    var detailText = $("#js-course-detail");
    detailTextCount.text(detailText.val().length);
  
    detailText.on("keyup", function() {
      detailTextCount.text(detailText.val().replace(/[\n\s　]/g, "").length);
    });
})