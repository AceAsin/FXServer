-- Networking
RegisterServerEvent("netDisable")
AddEventHandler("netDisable", function(bcnetid, target)
	TriggerClientEvent('disableBaitCar', target, bcnetid)
end)

RegisterServerEvent("netUnlock")
AddEventHandler("netUnlock", function(bcnetid, target)
	TriggerClientEvent('unlockBaitCar', target, bcnetid)
end)

RegisterServerEvent("netRearm")
AddEventHandler("netRearm", function(bcnetid, target)
	TriggerClientEvent('rearmBaitCar', target, bcnetid)
end)

RegisterServerEvent("netReset")
AddEventHandler("netReset", function(bcnetid, target)
	TriggerClientEvent('resetBaitCar', -1)
end)

-- Permission Check
RegisterServerEvent("BaitCarPro.getIsAllowed")
AddEventHandler("BaitCarPro.getIsAllowed", function()
	if IsPlayerAceAllowed(source, "BaitCarPro.open_menu") then
		TriggerClientEvent("BaitCarPro.returnIsAllowed", source, true)
	else
		TriggerClientEvent("BaitCarPro.returnIsAllowed", source, false)
	end
end)

-- Version Checking
local versionCheckEnabled = true

Citizen.CreateThread( function()
	if versionCheckEnabled then 
		local vFile = LoadResourceFile(GetCurrentResourceName(), "version.json")
		local currentVersion = json.decode(vFile).version
		local updatePath = "/eurofra1d/BaitCarPro"
		local resourceName = "BaitCarPro ("..GetCurrentResourceName()..")"
		function checkVersion(err,response, headers)
			if err == 200 then
				local data = json.decode(response)
				
				if currentVersion ~= data.version and tonumber(currentVersion) < tonumber(data.version) then
					print("\n--------------------------------------------------------------------------")
					print("\n"..resourceName.." is outdated.\nCurrent Version: "..data.version.."\nYour Version: "..currentVersion.."\nPlease update it from https://github.com"..updatePath.."")
					print("\nUpdate Changelog:\n"..data.changelog)
					print("\n--------------------------------------------------------------------------")
				elseif tonumber(currentVersion) > tonumber(data.version) then
					print("Your version of "..resourceName.." seems to be higher than the current version.")
				else
					print(resourceName.." is up to date!")
				end
			else
			print("BaitCarPro Version Check failed!")
			end
			
			local nativeuitest = LoadResourceFile("NativeUI", "__resource.lua")
			
			if not nativeuitest then
				print("\n--------------------------------------------------------------------------")
				print("\nNativeUI is not installed on this Server, this means that BaitCarPro will not work *at all*, please download and install it from:")
				print("\nhttps://github.com/FrazzIe/NativeUILua")
				print("\n--------------------------------------------------------------------------")
			else
				StartResource("NativeUI")
			end
			
			SetTimeout(3600000, checkVersionHTTPRequest)
		end
	 
	function checkVersionHTTPRequest()
		PerformHttpRequest("https://raw.githubusercontent.com/eurofra1d/BaitCarPro/master/version.json", checkVersion, "GET")
	end

	checkVersionHTTPRequest()
	end
end)
