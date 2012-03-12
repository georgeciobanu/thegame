var imagesLocation = "/struct/images/";
var imagesType = "png";
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
			if(annotation.color != Game.ui.getUserColor()){
				Ti.API.info("User cannot initate on opposing area");
			}
			else{
				Ti.API.info("User initating on " + annotation.title);
				selectedArea = annotation;
			}
		}
		else{
			attackArea = annotation;
			
			Ti.API.info(selectedArea.title + " " + selectedArea.color + " is attacking " + attackArea.title + " " + attackArea.color);
			attackingTurn = false;
		
			if(selectedArea.color != attackArea.color){
				Ti.API.info("ATTACK!");
				attack();
			}
			else{
				Ti.API.info(selectedArea.color + " cannot attack " + attackArea.color);
			}
		}
	}
	else{
		attackingTurn = true;
	}
}

function attack(){
	var multiplier = 0.5;
	var luck = Math.floor(Math.random() * 3) + 1;
	var attackingMinions = Math.floor(selectedArea.minions * luck * multiplier);
	
	Ti.API.info("Attacking area has: " + selectedArea.minions + " and is attacking with a force of " + attackingMinions + ", defending with " + attackArea.minions);
	
	if(attackingMinions > attackArea.minions){
		Ti.API.info("Victory");
		attackArea.minions = attackingMinions - attackArea.minions;
		attackArea.image = imagesLocation + selectedArea.color + "_" + attackArea.image.split("_")[1];
		attackArea.subtitle = subtitleBase + attackArea.minions;
		attackArea.color = selectedArea.color;
		
		Ti.API.info("New Color: " + attackArea.color + "\nNew Image: " + attackArea.image + "\nNew minions: " + attackArea.minions);
	}
	else{
		Ti.API.info("Defeat");
		selectedArea.minions = selectedArea.minions - (attackArea.minions - attackingMinions);
		selectedArea.subtitle = subtitleBase + selectedArea.minions;
		
		Ti.API.info("New Color: " + selectedArea.color + "\nNew Image: " + selectedArea.image + "\nNew minions: " + selectedArea.minions);
	}
	
	selectedArea = null;
	attackArea = null;
}