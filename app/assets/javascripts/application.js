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
  setTimeout('timerThing()', 5000);
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
    jQuery.each(data, function() {$('#developer_' + this.id).removeClass('notupdated')});

    $.each(data, function() {
      updateDeveloper(this);
    });
  }
  else {
    updateDeveloper(data);
  }

  $('.update-time').html('' + Date())
}

function updateDeveloper(developer) {
  box=$('#developer_' + developer.id);

  updateMetric(box.find("#points"), 
               developer.points_accepted + ' pts', 
               developer.points_accepted_score);

  updateMetric(box.find("#broke-production"), 
               developer.time_since_broke_production + ' days', 
               developer.time_since_broke_production_score);

  updateMetric(box.find("#last-question"), 
               developer.time_since_question + ' hrs', 
               developer.time_since_question_score);

  box.removeClass('notupdated');
}

function updateMetric(target, value, score) {
  target.find('.metric').html(value);
  description=target.find('.score-description');
  description.html(score.toUpperCase());
  applyScoreClass(target, score);
}

function applyScoreClass(target, scoreclass) {
  target.removeClass('win nominal weak fail');
  target.addClass(scoreclass);
}

jQuery(document).ready(function(){
  if ($('.updateable')[0]) {timerThing();}
  else {return}
});
