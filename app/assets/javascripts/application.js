// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function timerThing() {
  swapThing();
  setTimeout('timerThing()', 50000);
}

function swapThing() {
  if (window.location.pathname == '/')
    { var ls = 'developers' }
  else
    { var locationArray = window.location.pathname.split('/')
      var ls = locationArray[locationArray.length - 1]
    }
  jQuery.getJSON((ls + '.json'), {}, doStuff)
  .error(function() {$('.error-lightbox').removeClass('hidden')})
  .success(function() {$('.error-lightbox').addClass('hidden')})
  .error(function(jqXHR, textStatus, errorThrown) {
        $('.error-code').html('CODE OF ERROR OF PROBLEM IS ' + jqXHR.status)
    })
}

function doStuff(data) {
  $('.developer-box').addClass('notupdated')
  if (data[0]) {
    jQuery.each(data, function() {$('#developer_' + this.id).find("#points").html(this.points_accepted + ' points')});
    jQuery.each(data, function() {$('#developer_' + this.id).find("#last-question").html(this.time_since_question + ' hours')});
    jQuery.each(data, function() {$('#developer_' + this.id).find("#broke-production").html(this.time_since_broke_production + ' days')});
    jQuery.each(data, function() {$('#developer_' + this.id).removeClass('notupdated')});
    }
  else {
    $('#developer_' + data.id).find("#points").html(data.points_accepted + ' points');
    $('#developer_' + data.id).find("#last-question").html(data.time_since_question + ' hours');
    $('#developer_' + data.id).find("#broke-production").html(data.time_since_broke_production + ' days');
    $('#developer_' + data.id).removeClass('notupdated');
  }
  $('.update-time').html('' + Date())
}

jQuery(document).ready(function(){
  if ($('.updateable')[0]) {timerThing();}
  else {return}
});
