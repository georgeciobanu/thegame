function swapSubtitle(annotation, color){
	Ti.API.info('Swapping annotations');

	if(color == "Red"){
		annotation.subtitle = "Blue Team";
	}
	else{
		annotation.subtitle = "Red Team";
	}
}