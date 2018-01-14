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

  // チーム・個人詳細ページ
  if ($("#js-team-commit-chart").length) {

    // default表示は一番左のメンバーを表示しておく
    $(".js-individual-summary").addClass("disnon");
    $(".js-individual-summary").eq(0).removeClass("disnon");
    $(".off-tab").eq(0).removeClass("off-tab").addClass("on-tab");
    
    // 個人詳細をみるをクリックしたときの処理
    // 該当メンバーの情報を表示しつつスクロールする
    $(".js-scroll-to-individual-summary").on("click", function(){
      var num = $(".js-scroll-to-individual-summary").index(this);
      show_target_member_summary(num);

      $("html,body").animate({
        scrollTop : $("#js-individual-summary-area").offset().top
      });
    });

    // individual Summaryのタブ制御、タップされたメンバーのサマリーのみ表示。
    $(".js-member-name").on("click", function(){
      var num = $(".js-member-name").index(this);
      show_target_member_summary(num);
    });

    // 最初の課題をefault表示にする
    $(".js-contents-wrap").addClass("disnon");
    $(".js-contents-wrap").eq(0).removeClass("disnon");

    $("#js-task-list").change(function(){
      var val = $(this).val();
      $(".js-contents-wrap").addClass("disnon");
      $(".js-contents-wrap").eq(val).removeClass("disnon");
    });
    instantiate_graph();
  }
});

function set_alert_before_transition() {
  $(window).off('beforeunload');
  $(window).on('beforeunload', function(e) {
    return "";
  });
}

function show_target_member_summary(num) {
  // 該当メンバーのタブに切り替え
  $(".js-member-name").removeClass("on-tab").addClass("off-tab");
  $(".js-member-name").eq(num).removeClass("off-tab").addClass("on-tab");

  // 該当メンバーのサマリーに切り替え
  $(".js-individual-summary").addClass("disnon");
  $(".js-individual-summary").eq(num).removeClass("disnon");
}

function instantiate_graph() {
  var thisWeekCommitDates = $("#js-this-week-commit-date").data("this-week-commit-dates");
  var thisWeekCommitNumbers = $("#js-this-week-commit-number").data("this-week-commit-numbers");
  var time = "T00:00:00";

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
                "y":thisWeekCommitNumbers.Sunday,
                "x":thisWeekCommitDates.Sunday + time
              },
              {
                "y":thisWeekCommitNumbers.Monday,
                "x":thisWeekCommitDates.Monday + time
              },
              {
                "y":thisWeekCommitNumbers.Tuesday,
                "x":thisWeekCommitDates.Tuesday + time
              },
              {
                "y":thisWeekCommitNumbers.Wednesday,
                "x":thisWeekCommitDates.Wednesday + time
              },
              {
                "y":thisWeekCommitNumbers.Thursday,
                "x":thisWeekCommitDates.Thursday + time
              },
              {
                "y":thisWeekCommitNumbers.Friday,
                "x":thisWeekCommitDates.Friday + time
              },
              {
                "y":thisWeekCommitNumbers.Saturday,
                "x":thisWeekCommitDates.Saturday + time
              }
            ]
          },
        ],
      }
    ];

    var order = [0, 1, 0, 2],
      i = 0,
      xFormat = d3.time.format('%A'),
      chart = new xChart('line-dotted', data[order[i]], '#js-team-commit-chart', {
        axisPaddingTop: 5,
        dataFormatX: function (x) {
          return new Date(x);
        },
        tickFormatX: function (x) {
          return xFormat(x);
        },
        timing: 1250
      });
      
    var pullRequestData = {
      "xScale": "ordinal",
      "yScale": "linear",
      "main": [
        {
          "className": ".pizza",
          "data": [
            {
              "x": "12月12日",
              "y": 4
            },
            {
              "x": "12月13日",
              "y": 8
            },
            {
              "x": "12月14日",
              "y": 8
            },
            {
              "x": "12月15日",
              "y": 0
            },
            {
              "x": "12月16日",
              "y": 1
            },
            {
              "x": "12月17日",
              "y": 8
            },
            {
              "x": "12月18日",
              "y": 7
            }            
          ]
        }
      ]
    };
    var pullRequestChart = new xChart('bar', pullRequestData, '#js-pull-request', { axisPaddingTop: 5 });
}