$(document).ready(function(){
  $('textarea').each(function() {
    var textArea = $(this);

    var limitElement = $("<div>",
      {
        "class" : "character-limit",
        "aria-live" : "polite"
      }
    );

    textArea.parent().append(limitElement);

    function updateRemaining() {
      var limit = textArea.attr('maxlength');
      var used = textArea.val().length;

      var remaining = limit - used;

      if (remaining == 1) {
        remainingText = "1 character remaining";
      } else {
        remainingText = remaining + " characters remaining";
      }

      limitElement.text(remainingText);
    }

    if (textArea.attr('maxlength')) {
      textArea.keyup(function() {
        updateRemaining();
      });

      updateRemaining();
    }
  });
});
