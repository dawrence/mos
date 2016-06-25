/*-- Función que setea el font size del html con respecto al tamaño del viewport ---*/
function setFontSize(){
	var width = window.innerWidth;
	var height = window.innerHeight;
	var wfontSize;
	var hfontSize;

	if(window.innerHeight <= 450){
		hfontSize = 60;
	}
	else{
		height = 880 - height;
		hfontSize = 100 - (height*40)/630;
	}
	if(window.innerWidth <= 670){
		wfontSize = 60;
	}
	else{
		width = 1920 - width;
		wfontSize = 100 - (width*40)/1250;
	}
	if(wfontSize <= hfontSize){
		fontSize = wfontSize;
	}
	else{
		fontSize = hfontSize;
	}
	$('html').css("font-size", String(fontSize) + "%");
}

/*--- Función que inicializa el menú custom ---*/
function initMenu(){
	$('header ul.main-menu li:first-child a').click(function(e){
		e.preventDefault();
		$(this).closest('ul').toggleClass("open");
	})
}