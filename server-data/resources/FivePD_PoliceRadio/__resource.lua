resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
description "FivePD Police Radio"

ui_page "html/index.html"

client_script "PoliceRadio.net.dll"

files {
	"FivePD.net.dll",
	"Newtonsoft.Json.dll",
	
	"config.json",

	"html/index.html",
	"html/listener.js",
	"html/reset.css",
	"html/style.css",
	
	"html/audio/radio.mp3",
	"html/audio/beep.mp3",
	
	"html/images/radio.png",
	"html/images/arrows.png",
	"html/images/air_ambulance.png",
	"html/images/ambulance.png",
	"html/images/animal_control.png",
	"html/images/check_ped.png",
	"html/images/check_vehicle.png",
	"html/images/coroner.png",
	"html/images/fire_department.png"
}