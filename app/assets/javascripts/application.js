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
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function(){
    // datepicker
    $('#datepicker-default .date').datepicker({
        format: "yyyy-mm-dd",
    });

    // multi-select
    $('#label-select').multiSelect();

    $('.detail-toggle-btn').on('click', function(){
        $('#detail').stop().fadeToggle(200);
    })

    // ラベル選択に関する
    $('.selected-label').each(function(i, em) {
        console.log(em);
        $('.select-label-form option').each(function(){
            if( $(this).text() == $(em).text()) {
                $(this).remove();
            }
        })
    });
    $('.select-label-form').on('change', function(){
        var value = $(this).val();
        var text = $('.select-label-form option:selected').text();
        var labelLength = $('.selected-labels span').length;
        var label = '<span class="selected-label selected-label-green">' + text + '</span>';
        var hiddenFormLabelId = '<input type="hidden" value="' 
          + value
          + '" name="task[task_labels_attributes][' 
          + labelLength 
          + '][label_id]" id="task_task_labels_attributes_' 
          + labelLength + '_label_id">';

        $('.select-label-form option').each(function(){
            if( $(this).val() == value) {
                $(this).remove();
            }
        })

        $('.selected-labels').append(label);
        $('.selected-labels').append(hiddenFormLabelId);
    });

    $(document).on('click', '.selected-label', function(){
        var text = $(this).text();
        var task_id = $(this).data('task_id');
        $(this).next('input:hidden').remove();
        $(this).remove();
        $.ajax({
            url: "/labels.json",
            type: "GET",
            data: {
                name: text,
                task_id: task_id
            },
        })
        .done((data) => {
            $option = $('<option>')
                .val(data.id)
                .text(data.name)
            $('.select-label-form').append($option);
        })
    });

    // tasks create
    $('.data-submit').on('click', function(){
        var $form = $('#data-form');
        var query = $form.serialize();

        $.ajax({
            url: $form.attr('action'),
            type: $form.attr('method'),
            data: query,
            headers: {
                'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
            },
        })
        .done((data) => {
            location.reload();
        })
        .fail((data) => {
            var messages = data.responseJSON.messages;
            for(var i=0; i < messages.length; i++) {
                toastr.error(messages[i]);
            }
        })
    })


});
