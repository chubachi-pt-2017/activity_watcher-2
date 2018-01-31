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
  
    if($('#js-repository-name-count').length) {
      // Githubリポジトリ名のテキストカウンター
      var repositoryCount = $("#js-repository-name-count");
      var repositoryName = $("#js-repository-name");
      repositoryCount.text(repositoryName.val().length);
    
      repositoryName.on("keyup", function() {
        repositoryCount.text(repositoryName.val().length);
        set_alert_before_transition();
      });
    
      // Heroku URLのテキストカウンター
      var herokuUrlCount = $("#js-heroku-url-count");
      var herokuUrl = $("#js-heroku-url");
      herokuUrlCount.text(herokuUrl.val().length);
    
      herokuUrl.on("keyup", function() {
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
    }

    // チーム詳細のテキストカウンター
    var detailTextCount = $("#js-team-detail-count");
    var detailText = $("#js-team-detail");
    detailTextCount.text(detailText.val().length);
  
    detailText.on("keyup", function() {
      detailTextCount.text(detailText.val().replace(/[\n\s　]/g, "").length);
      set_alert_before_transition();
    });
    
    // メンバー追加ボタンクリック
    var addMembersButton = $('#js-member-add-button');
    initialize_member_selected();
    
    addMembersButton.on("click", function() {
      add_member();
      initialize_member_selected();
    });
    
    // メンバー削除ボタンクリック
    var removeMembersButton = $('#js-member-remove-button')
    
    removeMembersButton.on('click', function() {
      remove_member();
      initialize_member_selected();
    });
    
    $("#js-submit-button").on("click", function(){
      $(window).off('beforeunload');
      initialize_member_selected();
      $('#js-select-selected-member option').prop('selected', true);
    });
  }
})

function set_alert_before_transition() {
  $(window).off('beforeunload');
  $(window).on('beforeunload', function(e) {
    return "";
  });
}

function add_member() {
  var selectedValue = $('#js-select-all-member').val();
  var selectedTextArray = [];
  
  // 要素未選択だったら処理を終了
  if (selectedValue == null) {return false;}
  
  $('#js-select-all-member option:selected').each(function() {
    selectedTextArray.push($(this).text());
  });
  
  for (var i = 0; i < selectedValue.length; i++) {
    $('#js-select-selected-member').append(function() {
      if ($('#js-select-selected-member option[value=' + selectedValue[i] + ']').length == 0) {
        // 選択後のセレクトになければ追加
        return $('<option>').val(selectedValue[i]).text(selectedTextArray[i]);
      }
    });
  }
}

function remove_member() {
  var selectedValue = $('#js-select-selected-member').val();
  var selectedTextArray = [];

  if (selectedValue == null) {return false;}
  
  $('#js-select-selected-member option:selected').each(function() {
    selectedTextArray.push($(this).text());
  });
  
  for (var i = 0; i < selectedValue.length; i++) {
    $('#js-select-selected-member option[value=' + selectedValue[i] + ']').remove();
    $('#js-select-all-member').append(function() {
      if($('#js-select-all-member option[value=' + selectedValue[i] + ']').length == 0) {
        return $('<option>').val(selectedValue[i]).text(selectedTextArray[i]);
      }
    });
  }
}

function initialize_member_selected() {
  $('#js-select-all-member option').prop("selected", false);
  $('#js-select-selected-member option').prop("selected", false);
}