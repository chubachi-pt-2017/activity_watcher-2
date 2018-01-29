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
      instantiate_graph(val);

      $(".js-individual-summary").addClass("disnon");
      $(".js-individual-summary").eq(3).removeClass("disnon");
      $(".off-tab").eq(0).removeClass("off-tab").addClass("on-tab");
    });
    instantiate_graph(0);
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

function instantiate_graph(num) {
  
  // 折れ線グラフ
  var thisWeekDates = $("#js-this-week-commit-date").data("this-week-dates").split(",");
  var thisWeekCommitNumbers = $("#js-this-week-commit-number").data("this-week-commit-numbers").split(",");

  var data = [
    {
      "xScale":"ordinal",
      "yScale":"linear",
      "type":"line-dotted",
      "yMin": 0,
      "comp":[],
      "main":[
        { 
          "className":".main.l1",
          "data": [
            {
              "x":thisWeekDates[0], // 日曜
              "y":thisWeekCommitNumbers[0]
            },
            {
              "x":thisWeekDates[1], // 月曜
              "y":thisWeekCommitNumbers[1]
            },
            {
              "x":thisWeekDates[2], // 火曜
              "y":thisWeekCommitNumbers[2]
            },
            {
              "x":thisWeekDates[3], // 水曜
              "y":thisWeekCommitNumbers[3]
            },
            {
              "x":thisWeekDates[4], // 木曜
              "y":thisWeekCommitNumbers[4]
            },
            {
              "x":thisWeekDates[5], // 金曜
              "y":thisWeekCommitNumbers[5]
            },
            {
              "x":thisWeekDates[6], // 土曜
              "y":thisWeekCommitNumbers[6]
            }
          ]
        },
      ],
    }
  ];

  var order = [0, 1, 0, 2],
  i = 0,
  chart = new xChart('line-dotted', data[order[i]], '#js-team-commit-chart', {
    axisPaddingTop: 5,
    timing: 1250
  });

  // ここから棒グラフ
  // var thisWeekPullRequestDates = $("#js-this-week-pull-request-date").data("this-week-pull-request-dates");
  var thisWeekPullRequestNumbers = $("#js-this-week-pull-request-number").data("this-week-pull-request-numbers").split(",");

  var pullRequestData = {
    "xScale": "ordinal",
    "yScale": "linear",
    "yMin": 0,
    "main": [
      {
        "className": ".pizza",
        "data": [
          {
            "x":thisWeekDates[0], // 日曜
            "y":thisWeekPullRequestNumbers[0]
          },
          {
            "x":thisWeekDates[1], // 月曜
            "y":thisWeekPullRequestNumbers[1]
          },
          {
            "x":thisWeekDates[2], // 火曜
            "y":thisWeekPullRequestNumbers[2]
          },
          {
            "x":thisWeekDates[3], // 水曜
            "y":thisWeekPullRequestNumbers[3]
          },
          {
            "x":thisWeekDates[4], // 木曜
            "y":thisWeekPullRequestNumbers[4]
          },
          {
            "x":thisWeekDates[5], // 金曜
            "y":thisWeekPullRequestNumbers[5]
          },
          {
            "x":thisWeekDates[6], // 土曜
            "y":thisWeekPullRequestNumbers[6]
          }
        ]
      }
    ]
  };
  var pullRequestChart = new xChart('bar', pullRequestData, '#js-pull-request', { axisPaddingTop: 5 });
}