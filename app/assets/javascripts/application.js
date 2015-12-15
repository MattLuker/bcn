// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require modernizr
//= require foundation/foundation
//= require foundation
//= require foundation/foundation.alert
//= require foundation/foundation.tab
//= require foundation/foundation.abide
//= require foundation/foundation.clearing
//= require turbolinks
//= require_tree .
//= require foundation-datepicker
//= require clockpicker
//= require sweet-alert
//= require sweet-alert-confirm
//= require leaflet
//= require colpick
//= require transition
//= require zoom
//= require chosen.jquery
//= require editor
//= require marked
//= require sisyphus
//= require mustache
//= require moment
//= require truncatelines

$(function(){
    $(document).foundation({
        abide: {
            validators: {
                notUrl140Max: function(el, required, parent) {
                    $value = $(el).val();
                    url = /^((?!((https?|ftp|file|ssh):\/\/)).)*$/;

                    noturl = url.exec($value);

                    if (noturl && $value.length < 141) {
                        return true
                    } else {
                        return false
                    }
                }
            }
        },
        equalizer: {
          equalize_on_stack: true
        },
        topbar: {
          mobile_show_parent_link: true,
        }
    });

    $('.copyright-year').html(new Date().getFullYear());

    $('#tour').on('click', function(e) {
      e.preventDefault();
      console.log('touring...');
      $(document).foundation('joyride', 'start');
    });
});

$(window).on('page:load', function() {
    // Set the year in the footer copyright statement.
    $('.copyright-year').html(new Date().getFullYear());
    stickyFooter();
    $('#tour').on('click', function(e) {
      e.preventDefault();
      console.log('touring...');
      $(document).foundation('joyride', 'start');
    });
    $(document).foundation('reflow');
});


window.onload = function() {
    stickyFooter();

    //you can either uncomment and allow the setInterval to auto correct the footer
    //or call stickyFooter() if you have major DOM changes
    //setInterval(checkForDOMChange, 1000);
};

//check for changes to the DOM
function checkForDOMChange() {
    stickyFooter();
}

//check for resize event if not IE 9 or greater
window.onresize = function() {
    stickyFooter();
}

//lets get the marginTop for the <footer>
function getCSS(element, property) {

    var elem = document.getElementsByTagName(element)[0];
    var css = null;

    if (elem.currentStyle) {
        css = elem.currentStyle[property];

    } else if (window.getComputedStyle) {
        css = document.defaultView.getComputedStyle(elem, null).
            getPropertyValue(property);
    }

    return css;

}

function stickyFooter() {
    if (document.getElementsByTagName("footer")[0].getAttribute("style") != null) {
        document.getElementsByTagName("footer")[0].removeAttribute("style");
    }

    if (window.innerHeight != document.body.offsetHeight) {
        var offset = window.innerHeight - document.body.offsetHeight;
        var current = getCSS("footer", "margin-top");

        if (isNaN(current) == true) {
            document.getElementsByTagName("footer")[0].setAttribute("style","margin-top:0px;");
            current = 0;
        } else {
            current = parseInt(current);
        }

        if (current+offset > parseInt(getCSS("footer", "margin-top"))) {
            document.getElementsByTagName("footer")[0].setAttribute("style","margin-top:"+(current+offset)+"px;");
        }
    }
}

//
// Create an object from the query parameters.
//
jQuery.extend({
    getQueryParameters : function(str) {
        return (str || document.location.search).replace(/(^\?)/,'').split("&").map(function(n){return n = n.split("="),this[n[0]] = n[1],this}.bind({}))[0];
    }
});
