$(function(){
  if($("#js-course-title-count").length) {
    // コース名のテキストカウンター
    var titleCount = $("#js-course-title-count");
    var courseTitle = $("#js-course-title");
    titleCount.text(courseTitle.val().length);
  
    courseTitle.on("keyup", function() {
      titleCount.text(courseTitle.val().length);
      set_alert_before_transition();
    });
  
    // コース詳細のテキストカウンター
    var detailTextCount = $("#js-course-detail-count");
    var detailText = $("#js-course-detail");
    detailTextCount.text(detailText.val().length);
  
    detailText.on("keyup", function() {
      detailTextCount.text(detailText.val().replace(/[\n\s　]/g, "").length);
      set_alert_before_transition();
    });
    
    $("#js-submit-button").on("click", function(){
      $(window).off('beforeunload');
    });
  }

  if ($("#myChart").length) {
    // var data = {
    //   "xScale": "ordinal",
    //   "yScale": "linear",
    //   "main": [
    //     {
    //       "className": ".pizza",
    //       "data": [
    //         {
    //           "x": "Pepperoni",
    //           "y": 4
    //         },
    //         {
    //           "x": "Cheese",
    //           "y": 8
    //         }
    //       ]
    //     }
    //   ]
    // };
    // var myChart = new xChart('bar', data, '#myChart');

var data = {
  "xScale": "ordinal",
  "yScale": "linear",
  "type": "bar",
  "main": [
    {
      "className": ".pizza",
      "data": [
        {
          "x": "Pepperoni",
          "y": 12
        },
        {
          "x": "Cheese",
          "y": 8
        }
      ]
    }
  ],
  "comp": [
    {
      "className": ".pizza",
      "type": "line-dotted",
      "data": [
        {
          "x": "Pepperoni",
          "y": 10
        },
        {
          "x": "Cheese",
          "y": 4
        }
      ]
    }
  ]
}
var myChart = new xChart('bar', data, '#myChart');

  }
});

function set_alert_before_transition() {
  $(window).off('beforeunload');
  $(window).on('beforeunload', function(e) {
    return "";
  });
}