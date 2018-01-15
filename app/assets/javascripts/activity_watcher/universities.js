$(function(){
  if($("#js-university-name-count").length) {
    // 大学名(日本語)のテキストカウンター
    var nameCount = $("#js-university-name-count");
    var universityName = $("#js-university-name");
    nameCount.text(universityName.val().length);
  
    universityName.on("keyup", function() {
      nameCount.text(universityName.val().length);
      set_alert_before_transition();
    });
  
    // 大学名(英語)のテキストカウンター
    var nameEnCount = $("#js-university-name-en-count");
    var universityNameEn = $("#js-university-name-en");
    nameEnCount.text(universityNameEn.val().length);
  
    universityNameEn.on("keyup", function() {
      nameEnCount.text(universityNameEn.val().length);
      set_alert_before_transition();
    });
  
    // メールドメインのテキストカウンター
    var emailDomainCount = $("#js-university-email-domain-count");
    var universityEmailDomain = $("#js-university-email-domain");
    emailDomainCount.text(universityEmailDomain.val().length);
  
    universityEmailDomain.on("keyup", function() {
      emailDomainCount.text(universityEmailDomain.val().length);
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