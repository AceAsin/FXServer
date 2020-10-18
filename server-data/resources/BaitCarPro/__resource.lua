-- https://wiki.fivem.net/wiki/Resource_manifest

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'BaitCarPro by EURoFRA1D'

version '1.0.0'

server_script 'bcpsv.lua'

client_scripts {
	'@NativeUI/NativeUI.lua',
	'bcpcl.lua'
}

dependency 'NativeUI'
