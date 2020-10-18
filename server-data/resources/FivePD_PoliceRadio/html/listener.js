$(function(){
	window.onload = function(e) {
		window.addEventListener("message", function(event) {
			var item = event.data;
			var audioPlayer = null;
			
			if (item != undefined){
				if (item.type === "ui"){
					if (item.display === true){
						$('#radio').show();
						
						var size = item.scale + "%";
						$('img').each(function(){
							$(this).width(size);
						});
						
						for (i = 0; i < 7; i++){
							//$('#' + i).hide();
							$('#' + i).css("opacity", 0.0);
						}
						//$('#0').show();
						$('#0').css("opacity", 1.0);
					}else{
						$('#radio').hide();
					}
				}
				
				else if (item.type === "setOption"){
					for (i = 0; i < 7; i++){
						//$('#' + i).hide();
						$('#' + i).fadeTo(150, 0.0)
					}
					//$(item.id).show();
					$(item.id).fadeTo(150, 1.0)
				}
				
				else if (item.type === "selectOption"){
					
				}
				
				else if (item.type === "playAudio"){
					if (audioPlayer != null){
						audioPlayer.pause();
					}
					
					if(item.sound === "selection"){
						audioPlayer = new Howl({src: ["./audio/radio.mp3"]})
					}
					else if(item.sound === "beep"){
						audioPlayer = new Howl({src: ["./audio/beep.mp3"]})
					}
					
					audioPlayer.volume(item.volume);
					audioPlayer.play();
				}
			}
		})
	}
})