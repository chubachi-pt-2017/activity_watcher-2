$(function(){
  if($("#js-team-name-count").length) {
    // チーム名のテキストカウンター
    var nameCount = $("#js-team-name-count");
    var teamName = $("#js-team-name");
    nameCount.text(teamName.val().length);
  
    teamName.on("keyup", function() {
      nameCount.text(teamName.val().length);
      set_alert_before_transition();
    });
  
    // Githubリポジトリ名のテキストカウンター
    var repositoryCount = $("#js-repository-name-count");
    var repositoryName = $("#js-repository-name");
    repositoryCount.text(repositoryName.val().length);
  
    teamName.on("keyup", function() {
      repositoryCount.text(repositoryName.val().length);
      set_alert_before_transition();
    });
  
    // Heroku URLのテキストカウンター
    var herokuUrlCount = $("#js-heroku-url-count");
    var herokuUrl = $("#js-heroku-url");
    herokuUrl.text(herokuUrl.val().length);
  
    teamName.on("keyup", function() {
      herokuUrlCount.text(herokuUrl.val().length);
      set_alert_before_transition();
    });
  
    // CIツール URLのテキストカウンター
    var ciToolCount = $("#js-ci-tool-count");
    var ciTool = $("#js-ci-tool");
    ciToolCount.text(ciTool.val().length);
  
    ciTool.on("keyup", function() {
      ciToolCount.text(ciTool.val().length);
      set_alert_before_transition();
    });
  
    // チーム詳細のテキストカウンター
    var detailTextCount = $("#js-team-detail-count");
    var detailText = $("#js-team-detail");
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