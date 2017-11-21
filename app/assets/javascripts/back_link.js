$(document).ready(function(){
  function backLink(text) {
    var backLink = $("<a class='link-back' href='#' rel='nofollow'></a>");
    backLink.text(text);
    backLink.click(function(){
      parent.history.back();
      return false;
    });
    return backLink;
  }

  $(".js-back-link").replaceWith(function(){
    text = $(this).data("text");
    return backLink(text);
  });
});
