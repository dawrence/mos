// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.turbolinks
//= require turbolinks
//= require datepicker
//= require browser_timezone_rails/application.js
//= require_self
//= require_tree .


var kitchen_container;
var modal;
var body;
$(function(){
	body = $('body');
	modal = $('#mos-modal')


	$(document).foundation();

	initMenu();
	setFontSize();
	bindBills();
	bindGhostSubmit();

	$('.fdatepicker').fdatepicker({
	  language: 'es'
	});
	
	$( window ).resize(function() {
		setFontSize();
	});

	if (body.hasClass('kitchen')){
		kitchen_container = $('.kitchen_scope');
		window.setInterval(function(){
			window.location.reload();
		}, 20000);
		body.fadeIn();
		initKitchenMasonry();
	}


	$(".supplies_report_submit").click(function(e){
		$(this).closest(".wait-header").show();
		$(this).hide();
	});
});

function bindGhostSubmit(){
	$('a.ghost-submit').click(function(e){
		e.preventDefault();
		$('form.ghost input[type="submit"]').click();
	})
}


