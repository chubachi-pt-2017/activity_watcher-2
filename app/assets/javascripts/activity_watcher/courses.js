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

  if ($("#team-commit-chart").length) {
    var data = [
      {
        "xScale":"ordinal",
        "yScale":"linear",
        "type":"line-dotted",
        "comp":[],
        "main":[
          { 
            "className":".main.l1",
            "data": [
              {
                "y":15,
                "x":"2012-11-19T00:00:00"
              },
              {
                "y":11,
                "x":"2012-11-20T00:00:00"
              },
              {
                "y":8,
                "x":"2012-11-21T00:00:00"
              },
              {
                "y":10,
                "x":"2012-11-22T00:00:00"
              },
              {
                "y":1,
                "x":"2012-11-23T00:00:00"
              },
              {
                "y":6,
                "x":"2012-11-24T00:00:00"
              },
              {
                "y":8,
                "x":"2012-11-25T00:00:00"
              }
            ]
          },
          {
            "className":".main.l2",
            "data":[
              {
                "y":29,
                "x":"2012-11-19T00:00:00"
              },
              {
                "y":33,
                "x":"2012-11-20T00:00:00"
              },
              {
                "y":13,
                "x":"2012-11-21T00:00:00"
              },
              {
                "y":16,
                "x":"2012-11-22T00:00:00"
              },
              {
                "y":7,
                "x":"2012-11-23T00:00:00"
              },
              {
                "y":18,
                "x":"2012-11-24T00:00:00"
              },
              {
                "y":8,
                "x":"2012-11-25T00:00:00"
              }
            ]
          }],
      }
    ];

    var order = [0, 1, 0, 2],
      i = 0,
      xFormat = d3.time.format('%A'),
      chart = new xChart('line-dotted', data[order[i]], '#team-commit-chart', {
        axisPaddingTop: 5,
        dataFormatX: function (x) {
          return new Date(x);
        },
        tickFormatX: function (x) {
          return xFormat(x);
        },
        timing: 1250
      });
  }
});

function set_alert_before_transition() {
  $(window).off('beforeunload');
  $(window).on('beforeunload', function(e) {
    return "";
  });
}