(function( $ ) {
    $.fn.loading = function () {

        // create loading element
        var loadingElement = document.createElement('div');
        loadingElement.id = 'loading';
        loadingElement.className = 'loading';
        loadingElement.innerHTML = 'Loading...';

        // apply styles
        loadingElement.style.position = 'relative';
        loadingElement.style.width = '100%';
        loadingElement.style.height = '100%';
        loadingElement.style.textAlign = 'center';
        loadingElement.style.zIndex = '10000';
        loadingElement.style.padding = '4px';
        loadingElement.style.border = 'grey solid 1px #ccc';
        loadingElement.style.display = 'none';
        loadingElement.style.backgroundImage ='url(../images/loader.gif)';
        loadingElement.style.backgroundRepeat='no-repeat';
        loadingElement.style.backgroundSize='100px, 100px';
        loadingElement.style.backgroundPosition='center';

        // attach it to DOM
        $(this).append(loadingElement);

        // position element
        $("#loading").position({
            my: "center top",
            at: "center top",
            of: window
        });

        // every time ajax is called
        $(document).ajaxSend(function () {
            $(loadingElement).show();
        })

        // every time ajax is completed
        $(document).ajaxComplete(function () {
            self.setTimeout(function (){
                $(loadingElement).hide();
            }, 1000);
        });
    };

})(jQuery);

$(document).ready(function () {
    $('body').loading();
});

