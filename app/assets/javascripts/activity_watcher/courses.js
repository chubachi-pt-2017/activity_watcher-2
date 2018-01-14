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
  if ($("#js-team-commit-chart-0").length) {

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
      // $("#change-task").submit();
      var val = $(this).val();
      $(".js-contents-wrap").addClass("disnon");
      $(".js-contents-wrap").eq(val).removeClass("disnon");
      instantiate_graph(val);
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
  var thisWeekCommitDates = $("#js-this-week-commit-date-" + num).data("this-week-commit-dates");
  var thisWeekCommitNumbers = $("#js-this-week-commit-number-" + num).data("this-week-commit-numbers");

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
              "x":thisWeekCommitDates.Sunday,
              "y":thisWeekCommitNumbers.Sunday
            },
            {
              "x":thisWeekCommitDates.Monday, 
              "y":thisWeekCommitNumbers.Monday
            },
            {
              "x":thisWeekCommitDates.Tuesday,
              "y":thisWeekCommitNumbers.Tuesday
            },
            {
              "x":thisWeekCommitDates.Wednesday,
              "y":thisWeekCommitNumbers.Wednesday
            },
            {
              "x":thisWeekCommitDates.Thursday,
              "y":thisWeekCommitNumbers.Thursday
            },
            {
              "x":thisWeekCommitDates.Friday,
              "y":thisWeekCommitNumbers.Friday
            },
            {
              "x":thisWeekCommitDates.Saturday,
              "y":thisWeekCommitNumbers.Saturday
            }
          ]
        },
      ],
    }
  ];

  var order = [0, 1, 0, 2],
  i = 0,
  chart = new xChart('line-dotted', data[order[i]], '#js-team-commit-chart-' + num, {
    axisPaddingTop: 5,
    timing: 1250
  });

  // ここから棒グラフ
  var thisWeekPullRequestDates = $("#js-this-week-pull-request-date-" + num).data("this-week-pull-request-dates");
  var thisWeekPullRequestNumbers = $("#js-this-week-pull-request-number-" + num).data("this-week-pull-request-numbers");

  var pullRequestData = {
    "xScale": "ordinal",
    "yScale": "linear",
    "main": [
      {
        "className": ".pizza",
        "data": [
          {
            "x":thisWeekPullRequestDates.Sunday,
            "y":thisWeekPullRequestNumbers.Sunday
          },
          {
            "x":thisWeekPullRequestDates.Monday, 
            "y":thisWeekPullRequestNumbers.Monday
          },
          {
            "x":thisWeekPullRequestDates.Tuesday,
            "y":thisWeekPullRequestNumbers.Tuesday
          },
          {
            "x":thisWeekPullRequestDates.Wednesday,
            "y":thisWeekPullRequestNumbers.Wednesday
          },
          {
            "x":thisWeekPullRequestDates.Thursday,
            "y":thisWeekPullRequestNumbers.Thursday
          },
          {
            "x":thisWeekPullRequestDates.Friday,
            "y":thisWeekPullRequestNumbers.Friday
          },
          {
            "x":thisWeekPullRequestDates.Saturday,
            "y":thisWeekPullRequestNumbers.Saturday
          }
        ]
      }
    ]
  };
  var pullRequestChart = new xChart('bar', pullRequestData, '#js-pull-request-' + num, { axisPaddingTop: 5 });
}