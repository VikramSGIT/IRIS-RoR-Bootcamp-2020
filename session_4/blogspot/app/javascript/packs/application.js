// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .
//= require turbolinks

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'bootstrap'
import 'bootstrap/js/dist/toast'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).ready(function()
{
    document.getElementById('hide').addEventListener('click', function()
    {
        $('.toast').toast('hide');
    });
    if (document.cookie.length > 0)
    {
        setInterval(function() 
        {
            var cookie = document.cookie.toString();
            var lenght = cookie.length;
            if (lenght != 0)
            {
                var out = cookie.substr(3, lenght-3);
                $.ajax({
                    url: "http://192.168.62.128:3000/newarticle/" + out,
                    type: "get",
                    success: function(result){
                        if(result.name != null)
                        {
                            $('.toast').toast('show');
                            $('#name').html(result.name);
                            $('#msg').html(result.html);
                        }
                    }
                });
            }
        }, 1000);
    }
});

$(window).on('beforeunload',function()
{
    document.cookie = 'id=; Path=/; Expires=Thu, 26 April 2001 00:00:01 GMT;'
});