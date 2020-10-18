var CurrentID = 0;
var options = document.getElementsByClassName("option");
		
function update(){
		
	for(i = 0; i < options.length; i++){
		options[i].style.display = "none";
	}
	
	console.log(CurrentID);
	
	document.getElementById(CurrentID).style.display = "block";
}
		
document.addEventListener("keydown", function(e) {
	console.log(e.keyCode);
	
	switch(e.keyCode){
		case 13: // Enter Key
			emit("radio:select-option", CurrentID);
			break;
			
		case 174: // Left Arrow Key
			if (CurrentID <= 0){
				CurrentID = 6;
			}else{
				CurrentID -= 1;
			}
			break;
					
		case 172: // Up Arrow Key (Do nothing)
			break;
					
		case 175: // Right Arrow Key
			if (CurrentID >= 6){
				CurrentID = 0;
			}else{
				CurrentID += 1;
			}
			break;
					
		case 173: // Down Arrow Key (Do nothing)
			break;
	}
			
	update();
})