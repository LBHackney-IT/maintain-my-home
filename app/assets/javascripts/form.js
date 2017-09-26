$(document).ready(function() {
  $('body').addClass('js-enabled');

  // Loop over each form on the page
  $('form').each(function() {

    // If the form contains radio buttons, hide the submit button
    if ($(this).find('input[type=radio]').length > 0) {
      $(this).find('input[type=button]').hide();
      $(this).find('input[type=submit]').hide();
    }

    // Clicking on any radio button will show the submit button
    if ($(this).find('input[type=radio]').click(function() {
      $(this).closest('form').find('input[type=button]').show();
      $(this).closest('form').find('input[type=submit]').show();
    }));
  });
});
