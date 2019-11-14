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
//= require popper
//= require jquery3
//= require bootstrap-sprockets
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

$("document").ready(function(){
	$("#afterSort").hide();
})

function tryYourLucky(){
	var userId = $("#userSelect").val();

	if(userId == -1){
		alert("Please, indentify yourself!");
	}else{
		 $.ajax({
		   url: '/raffle',
		   data: { 
		           user: userId },
		   method: 'POST',
		   success: function (res) {
		   	$("#preSort").fadeOut("slow");
		   	$("#afterSort").fadeIn("slow").html("Sorteados: " + res.raffled1 + " e " + res.raffled2);
		   	$("#afterSort").show();
		   	$("#main-sort-jumbotron").css("background-color", "#00FF00");
		   	$("#main-sort-jumbotron").css("font-size", "40px");
		  },
		  error: function (jqXHR, exception) {
		        var msg = '';
		        if (jqXHR.status === 0) {
		            msg = 'Not connect.\n Verify Network.';
		        } else if (jqXHR.status == 404) {
		            msg = 'Requested page not found. [404]';
		        } else if (jqXHR.status == 500) {
		            msg = 'Internal Server Error [500].';
		        } else if (exception === 'parsererror') {
		            msg = 'Requested JSON parse failed.';
		        } else if (exception === 'timeout') {
		            msg = 'Time out error.';
		        } else if (exception === 'abort') {
		            msg = 'Ajax request aborted.';
		        } else {
		            msg = 'Uncaught Error.\n' + jqXHR.responseText;
		        }

		        $("#preSort").fadeOut("slow");
			   	$("#afterSort").fadeIn("slow").html("Erro: " + msg);
			   	$("#afterSort").show();
			   	$("#main-sort-jumbotron").css("background-color", "#FF0000");
			   	$("#main-sort-jumbotron").css("font-size", "40px");
		    }
		}); 
	}
}