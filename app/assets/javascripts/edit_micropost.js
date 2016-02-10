var ready;
ready = function() {
  $("#micropost_edit_submit").click(function(){
  	$("#micropost_user_id").val($("#names_id").val())
  });
};

$(document).ready(ready)
$(document).on('page:load', ready)