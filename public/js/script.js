$(document).ready(function(){

    //When the input event is fired for anything with the disable-empty class, run the function
    $('.disable-empty').on('input', function() {
        //contents of the textarea
        var value = this.value;
        //parent of the textarea - so the function only disables/enables one button
        var parent = $(this).parent();

        //if the textarea isn't empty, enable the button (disabled by defualt)
        if (value != '') {
            $('.search-button', parent).prop('disabled', false);
        } else {
            //otherwise disable the button
            $('.search-button', parent).prop('disabled', true);
        }
    });

});



