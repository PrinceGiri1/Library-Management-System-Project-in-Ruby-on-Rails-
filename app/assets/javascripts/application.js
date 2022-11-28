// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require_tree .
//= require_self

var ready = function () {
    // $('#more2come').hide();
    $('#student_sub_form').show();
    $('#librarian_sub_form').hide();
    //$('#lib2come').hide();
    $('#user_role').change(function(){
        if($('#user_role').val()=='user'){
            $('#more2come').show();
            $('#student_sub_form').show();
            $('#librarian_sub_form').hide();
            $('#user_student_name').prop("required",true);
            $('#user_student_education').prop("required",true);
            $('#user_student_university').prop("required",true);
        }
        else if($('#user_role').val()=='librarian') {
            $('#more2come').show();
            $('#student_sub_form').hide();
            $('#librarian_sub_form').show();
            $('#user_librarian_name').prop("required",true);
            $('#user_library_name').prop("required",true);
        }
        else {
            $('#more2come').hide();
            $('#student_sub_form').hide();
            $('#librarian_sub_form').hide();
        }
    });

    $('#mb_field').hide();
    // $('#student_education').change(function(){
    //     if($('#user_student_education').val()=='Masters') {
    //         $('#user_student_max_books').val(4);
    //     }
    //     if ($('#user_student_education').val()=='Undergraduate') {
    //         $('#user_student_max_books').val(2);
    //     }
    //     if ($('#user_student_education').val()=='PhD') {
    //         $('#user_student_max_books').val(6);
    //     }
    //     else $('#user_student_max_books').val(2);
    // });
    //
    // $('#student_education').change(function(){
    //     if($('#student_education').val()=='Masters') {
    //         $('#student_max_books').val(4);
    //     }
    //     if ($('#student_education').val()=='Undergraduate') {
    //         $('#student_max_books').val(2);
    //     }
    //     if ($('#student_education').val()=='PhD') {
    //         $('#student_max_books').val(6);
    //     }
    //     else $('#student_max_books').val(2);
    // });

    $('#user_password, #user_password_confirmation').on('keyup',function(){
        if($('#user_password').val() == $('#user_password_confirmation').val()){
            $('#user_message').html('Passwords Match!').css('color','green');
            $('#user_submit').prop('disabled',false);
        } else{
            $('#user_message').html('Passwords do NOT match!!!').css('color','red');
            $('#user_submit').prop('disabled',true);
        }
    });

    $('#librarian_password, #librarian_password_confirmation').on('keyup',function(){
        if($('#librarian_password').val() == $('#librarian_password_confirmation').val()){
            $('#librarian_message').html('Passwords Match!').css('color','green');
            $('#librarian_submit').prop('disabled',false);
        } else{
            $('#librarian_message').html('Passwords do NOT match!!!').css('color','red');
            $('#librarian_submit').prop('disabled',true);
        }
    });

    $('#student_password, #student_password_confirmation').on('keyup',function(){
        if($('#student_password').val() == $('#student_password_confirmation').val()){
            $('#student_message').html('Passwords Match!').css('color','green');
            $('#student_submit').prop('disabled',false);
        } else{
            $('#student_message').html('Passwords do NOT match!!!').css('color','red');
            $('#student_submit').prop('disabled',true);
        }
    });

    $('#admin_email').prop('disabled', true);
};

$(document).ready(ready);
$(document).on('turbolinks:load',ready);
