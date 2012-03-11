var imagesLocation = "/struct/images/";
var subtitleBase = "Num Minions: ";
var selectedArea;
var attackArea;
var attackingTurn = true;

function swapSubtitle(annotation, color){
	Ti.API.info('Swapping annotations');

	if(color == "Red"){
		annotation.subtitle = "Blue Team";
	}
	else{
		annotation.subtitle = "Red Team";
	}
}

function setArea(annotation){
	if(attackingTurn){
		if(selectedArea == null){
			selectedArea = annotation;
		}
		else{
			Ti.API.info(selectedArea.title + " is attacking " + annotation.title);
			attackingTurn = false;
		
			if(selectedArea.color != annotation.color){
				Ti.API.info("ATTACK!");
				attackArea = annotation;
				attack();
			}
			else{
				Ti.API.info("Same Team...");
			}
			
			selectedArea = null;
			attackArea = null;
		}
	}
	else{
		attackingTurn = true;
	}
}

function attack(){
	var multiplier = 0.5;
	var luck = Math.floor(Math.random() * 3) + 1;
	var attackingMinions = Math.floor(selectedArea.numMinions * luck * multiplier);
	
	Ti.API.info("Attacking area has: " + selectedArea.numMinions + " and is attacking with a force of " + attackingMinions + ", defending with " + attackArea.numMinions);
	
	if(attackingMinions > attackArea.numMinions){
		Ti.API.info("Victory");
		attackArea.numMinions = attackingMinions - attackArea.numMinions;
		attackArea.image = imagesLocation + selectedArea.color + "_" + attackArea.image.split("_")[1];
		attackArea.subtitle = subtitleBase + attackArea.numMinions;
		attackArea.color = selectedArea.color;
	}
	else{
		Ti.API.info("Defeat");
		selectedArea.numMinions = selectedArea.numMinions - (attackArea.numMinions - attackingMinions);
		selectedArea.subtitle = subtitleBase + selectedArea.numMinions;
	}
}