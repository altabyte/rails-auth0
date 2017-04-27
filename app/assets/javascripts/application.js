// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require open_source/auth0/lock
//
//= require jquery
//= require jquery_ujs
//= require open_source/jquery.dropdown
//= require turbolinks
//= require public_pages
//= require dashboard

$(document).on('turbolinks:load', function () {
    publicPagesReady.call();
    dashboardReady.call();


    if ($("#flash").length) {
        $("#flash").fadeIn(1500);
        setTimeout(function() {
            $("#flash").fadeOut(1500);
        }, 3000);
        $("#flash").click(function() {
            $("#flash").hide('fast');
        });
    }


    $('header a.app-aside-trigger').click(function() {
        $('aside.app-nav').addClass('with-overlay');

        if ($('#app-aside-overlay').length == 0) {
            $('body').prepend("<div id='app-aside-overlay'></div>");

            var overlayHeight = Math.max($(document).height(), $(document).width()); /* Allow for mobile device rotation. */
            $("#app-aside-overlay")
                .height(overlayHeight)
                .css({
                    'opacity': 0.15,
                    'position': 'fixed',
                    'top': 0,
                    'left': 0,
                    'background-color': '#000000',
                    'width': '100%',
                    'z-index': 100000,
                    '-webkit-transition': '0.25s ease-in-out',
                    '-moz-transition': '0.25s ease-in-out'
                });
        }
    });
    $(document.body).on('click', '#app-aside-overlay, aside.app-nav.with-overlay, aside.app-nav.with-overlay a', function() {
        $('aside.app-nav').removeClass('with-overlay');
        $('#app-aside-overlay').remove();
    });


    $('.toggle-next-element').click(function (event) {
        $(this).next().toggle("slow");
        $(this).find(".fa.more").toggle();
        $(this).find(".fa.less").toggle();
    });
});
