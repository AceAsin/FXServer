-- Config
local useAcePerms = true

local menuInputGroup = 0
local menuControl = 170 -- F3

local showGPS = true
local alertOnEntry = true
local toggleMouse = false

local status_r = 255
local status_g = 255
local status_b = 255

local blipColor = 1
local blipRoute = true
local blipHeading = true
local blipSprite = 426

local alertSuspect = "You have stolen a BaitCar which has been remotely disabled. Officers are en route."
local successInstalled = "~g~BaitCar system installed successfully."
local errorInVehicle = "~r~Exit your vehicle before spawning a BaitCar."
local errorOutOfVehicle = "~r~You are either not in a car, or the BaitCar system is already installed."
local errorNoCar = "~r~No BaitCar found."
local errorEmptyCar = "~r~You are attempting to disarm an empty BaitCar."
local errorLockedArm = "~r~BaitCar must be unlocked before re-arming."
local errorMoving = "~r~The vehicle must be stopped to install the BaitCar system."
local errorMenuOpen = "~r~You do not have permission to access the BaitCarPro menu."

-- Declarations
local bcinstalled = false
local baitcar = nil
local bctemp = nil
local bctempu = nil
local isDisabled = false
local isUnlocked = false
local suspect = false
local alerted = false
local dashcamActive = false
local allowedToUse = false
local playSounds = true  -- This looks like a toggle, just realized this doesnt effect target only source, dont bother changing until this is fixed

-- Install BaitCar
RegisterNetEvent('installBaitCar')
AddEventHandler('installBaitCar', function()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		loadAnimDict("anim@veh@std@panto@ds@base")
		TaskPlayAnim(PlayerPedId(), "anim@veh@std@panto@ds@base", "hotwire", 8.0, 1.0, -1, 0, 0, false, false, false)
		
		if playSounds then
			PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
		end
		
		baitcar = GetVehiclePedIsIn(PlayerPedId(), false)
		manageGPS(baitcar)
		bcinstalled = true
	else
		ShowNotification(errorOutOfVehicle)
	end
end)

-- Disable BaitCar
RegisterNetEvent('disableBaitCar')
AddEventHandler('disableBaitCar', function(target)
	bctemp = NetworkGetEntityFromNetworkId(target)
	NetworkRequestControlOfNetworkId(target)
	SetNetworkIdCanMigrate(target, false)
	local targetveh = NetworkGetEntityFromNetworkId(target)
	isDisabled = true
end)

-- Unlock BaitCar
RegisterNetEvent('unlockBaitCar')
AddEventHandler('unlockBaitCar', function(target)
	NetworkRequestControlOfNetworkId(target)
	SetNetworkIdCanMigrate(target, false)
	bctempu = NetworkGetEntityFromNetworkId(target)
	local targetveh = NetworkGetEntityFromNetworkId(target)
	isDisabled = false
	isUnlocked = true
	SetVehicleDoorsLockedForAllPlayers(targetveh, false)
	suspect = false
	alerted = false
	SetFakeWantedLevel(0)
	
	if playSounds then
		PlaySoundFrontend(-1, "Breaker_01", "DLC_HALLOWEEN_FVJ_Sounds", 0)
	end
end)

-- Reset BaitCar
RegisterNetEvent('resetBaitCar')
AddEventHandler('resetBaitCar', function()
	isDisabled = false
	isUnlocked = false
	suspect = false
	alerted = false
	baitcar = nil
	bcinstalled = false
	DisableDash()
	SetFakeWantedLevel(0)
	manageGPS()
end)

-- Re-Arm BaitCar
RegisterNetEvent('rearmBaitCar')
AddEventHandler('rearmBaitCar', function(target)
	isUnlocked = false
	local targetveh = NetworkGetEntityFromNetworkId(target)
	SetVehicleFixed(targetveh)
	SetVehicleEngineOn(targetveh, true, true, false)
	if playSounds then PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0) end
end)

-- BaitCar Kill Loop
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(isDisabled) then
			if PlayerPedId() then
				if (IsPedSittingInVehicle(PlayerPedId(), bctemp)) then
					suspect = true
					if not alerted then
						Notify(alertSuspect)
						if playSounds then PlaySoundFrontend(-1, "Arming_Countdown", "GTAO_Speed_Convoy_Soundset", 0) end
						SetFakeWantedLevel(5)
						alerted = true
					end
					for i = -1, GetVehicleMaxNumberOfPassengers(bctemp) - 1, 1
					do 
						if (GetPedInVehicleSeat(bctemp, i) == PlayerPedId()) then
							myseat = i
						end
					end
				elseif suspect then
					ClearPedTasksImmediately(PlayerPedId())
					TaskWarpPedIntoVehicle(PlayerPedId(), bctemp, myseat)
				end
				for i = 0, 6, 1
				do 
					SetVehicleDoorShut(bctemp, i, true)
				end
				SetVehicleDoorsLockedForAllPlayers(bctemp, true) 
				SetVehicleEngineHealth(bctemp, -0)
				SetVehicleEngineOn(bctemp, false, true, false)
			end
		elseif(isUnlocked) then
			if PlayerPedId() then
				if (IsPedSittingInVehicle(PlayerPedId(), bctempu)) then
					for i = -1, GetVehicleMaxNumberOfPassengers(bctempu) - 1, 1
					do 
						if (GetPedInVehicleSeat(bctempu, i) == PlayerPedId()) then
							myseat = i
						end
					end
				end
				SetVehicleDoorsLockedForAllPlayers(bctempu, false) 
				SetVehicleEngineHealth(bctempu, -0)
				SetVehicleEngineOn(bctempu, false, true, false)
			end
		end				
	end
end)

-- Networking
RegisterNetEvent('getNetID_disable')
AddEventHandler('getNetID_disable', function(netID, target)
	if DoesEntityExist(baitcar) then
		if isVehicleOccupied(baitcar) then
			TriggerServerEvent("netDisable", netID , target)
		else
			ShowNotification(errorEmptyCar)
		end
	else
		ShowNotification(errorNoCar)
	end
end)

RegisterNetEvent('getNetID_unlock')
AddEventHandler('getNetID_unlock', function(netID, target)
	if DoesEntityExist(baitcar) then
		TriggerServerEvent("netUnlock", netID, target)
	else
		ShowNotification(errorNoCar)
	end
end)

RegisterNetEvent('getNetID_rearm')
AddEventHandler('getNetID_rearm', function(netID, target)
	if DoesEntityExist(baitcar) then
		if isDisabled == false then
			TriggerServerEvent("netRearm", netID, target)
		elseif isUnlocked == false then
			TriggerServerEvent("netRearm", netID, target)
		else
			ShowNotification(errorLockedArm)
		end
	else
		ShowNotification(errorNoCar)
	end
end)

-- Occupied Text
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DoesEntityExist(baitcar) then
			if isVehicleOccupied(baitcar) and alertOnEntry then
				if not dashcamActive and not IsPedInVehicle(PlayerPedId(), baitcar, true) then drawTxt2(1.0, 1.45, 1.0, 1.0, 0.45, "BaitCar Occupied", status_r, status_g, status_b, 255) end
			end	
		end	
	end
end)

-- GPS Management
function manageGPS(veh)
	if showGPS and DoesEntityExist(veh) then 
		if not DoesBlipExist(blip) then blip = AddBlipForEntity(veh) end
		SetBlipSprite(blip, blipSprite)
		SetBlipColour(blip, blipColor)
		SetBlipAlpha(blip, 255)
		SetBlipRoute(blip,  blipRoute)
		ShowHeadingIndicatorOnBlip(blip, blipHeading)
	elseif DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

-- Dash Cam Functions | Credit to Xander1998 | Modified with permission
local cameraHandle = nil
local shader = "scanline_cam_cheap"

Citizen.CreateThread(function()
	while true do
		if dashcamActive then
			local bonPos = GetWorldPositionOfEntityBone(baitcar, GetEntityBoneIndexByName(baitcar, "windscreen"))
			local vehRot = GetEntityRotation(baitcar, 0)
			SetCamCoord(cameraHandle, bonPos.x , bonPos.y, bonPos.z)
			SetCamRot(cameraHandle, vehRot.x - 180.0, -vehRot.y -180.0, vehRot.z, 0)
		DisableControlAction(0, 75)
		end
		Citizen.Wait(0)
	end
end)

function EnableDash()
	SetTimecycleModifier(shader)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	RenderScriptCams(1, 0, 0, 1, 1)
	SetFocusEntity(baitcar)
	cameraHandle = cam
	dashcamActive = true
end

function DisableDash()
	ClearTimecycleModifier(shader)
	RenderScriptCams(0, 0, 1, 1, 1)
	DestroyCam(cameraHandle, false)
	SetFocusEntity(GetPlayerPed(PlayerId()))
	dashcamActive = false
end

-- NativeUI Functions
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("BaitCarPro", "~w~by ~r~EURoFRA1D", 1400, 50)
_menuPool:Add(mainMenu)

function AddMenuInstall(menu)
	installitem = NativeUI.CreateItem("Install BaitCar System", "Installs the BaitCar System in the current vehicle.")
	menu:AddItem(installitem)
	menu.OnItemSelect = function(sender, item, index)
		if item == installitem then
			if IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedInVehicle(PlayerPedId(), baitcar) then
				if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) <= 0.5 then
					TriggerEvent('installBaitCar')
					ShowNotification(successInstalled)
					installitem:SetRightBadge(BadgeStyle.Tick)
				else
					ShowNotification(errorMoving)
				end
			else
				ShowNotification(errorOutOfVehicle)
			end
		end
	end
end

function AddMenuCarControls(menu)
	controlmenu = _menuPool:AddSubMenu(menu, "BaitCar Controls >>", 1400, 50)
	killitem = NativeUI.CreateItem("Kill", "Shut down baitcar")
	unlockitem = NativeUI.CreateItem("Unlock", "Unlock baitcar")
	repairitem = NativeUI.CreateItem("Repair", "Repair baitcar")
	camitem = NativeUI.CreateItem("Video Feed", "View video feed from inside Baitcar")
	local targetVeh = nil
	local targetPed = nil
	controlmenu:AddItem(killitem)
	controlmenu:AddItem(unlockitem)
	controlmenu:AddItem(repairitem)
	controlmenu:AddItem(camitem)
	controlmenu.OnItemSelect = function(sender, item, index)
		if  item == killitem then
			if DoesEntityExist(baitcar) then
				targetveh =	NetworkGetNetworkIdFromEntity(baitcar)
				targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(baitcar, -1)))
				TriggerEvent('getNetID_disable', targetveh, targetPed)
				ShowNotification("~g~Baitcar killed")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		elseif item == unlockitem then
			if DoesEntityExist(baitcar) then
				targetveh =	NetworkGetNetworkIdFromEntity(baitcar)
				targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(baitcar, -1)))
				TriggerEvent('getNetID_unlock', targetveh, targetPed)
				ShowNotification("~g~Baitcar unlocked")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		elseif item == repairitem then
			if DoesEntityExist(baitcar) then
				targetveh =	NetworkGetNetworkIdFromEntity(baitcar)
				targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(baitcar, -1)))
				TriggerEvent('getNetID_rearm', targetveh, targetPed)
				ShowNotification("~g~Baitcar repaired")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		elseif item == camitem then
			if DoesEntityExist(baitcar) then
				if dashcamActive then
					DisableDash()
				else
					EnableDash()
				end
				ShowNotification("~g~Video Feed Toggled")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		end
	end
	
end

function AddMenuSettings(menu)
	settingsmenu = _menuPool:AddSubMenu(menu, "Settings >>", 1400, 50)
	local alertitem = NativeUI.CreateCheckboxItem("Alert on entry?", alertOnEntry, "Displays text informing you when the BaitCar is occupied.")
	local sounditem = NativeUI.CreateCheckboxItem("Sound?", playSounds, "Toggles whether sounds are played.")
	local resetitem = NativeUI.CreateItem("Reset", "Resets ALL BaitCar systems in server. Use if something breaks (Deleted locked BaitCar, ect.)")
	settingsmenu:AddItem(alertitem)
	settingsmenu:AddItem(sounditem)
	settingsmenu:AddItem(resetitem)
	settingsmenu.OnCheckboxChange = function(sender, item, checked_)
		if item == alertitem then
			alertOnEntry = checked_
		elseif item == sounditem then
			playSounds = checked_
		end
	end
	settingsmenu.OnItemSelect = function(sender, item, index)
		if item == resetitem then
			TriggerServerEvent('netReset')
		end
	end
end

function AddMenuGPS(menu)
	gpsmenu = _menuPool:AddSubMenu(menu, "GPS >>", 1400, 50)
	local showgpsitem = NativeUI.CreateCheckboxItem("Show GPS?", showGPS, "Toggles GPS Tracking for the BaitCar")
	local brouteitem = NativeUI.CreateCheckboxItem("Show Blip Route?", blipRoute, "Toggles route to BaitCar on minimap")
	local bheadingitem = NativeUI.CreateCheckboxItem("Show Blip Heading?", blipHeading, "Shows direction BaitCar is facing with an indicator")
	gpsmenu:AddItem(showgpsitem)
	gpsmenu:AddItem(brouteitem)
	gpsmenu:AddItem(bheadingitem)
	gpsmenu.OnCheckboxChange = function(sender, item, checked_)
		if item == showgpsitem then
			showGPS = checked_
			manageGPS(baitcar)
		elseif item == brouteitem then
			blipRoute = checked_
			manageGPS(baitcar)
		elseif item == bheadingitem then
			blipHeading = checked_
			manageGPS(baitcar)
		end
	end
end

AddMenuInstall(mainMenu)
AddMenuCarControls(mainMenu)
AddMenuSettings(mainMenu)
AddMenuGPS(settingsmenu)
_menuPool:MouseControlsEnabled(toggleMouse)
_menuPool:MouseEdgeEnabled(toggleMouse)
_menuPool:ControlDisablingEnabled(toggleMouse)
_menuPool:RefreshIndex()

RegisterNetEvent("BaitCarPro:Open")
AddEventHandler("BaitCarPro:Open", function()
	_menuPool:ProcessMenus()
	if useAcePerms then
		if allowedToUse then
			mainMenu:Visible(not mainMenu:Visible())
		else
			ShowNotification(errorMenuOpen)
		end
	else 
		mainMenu:Visible(not mainMenu:Visible()) 
	end
	
	if not DoesEntityExist(baitcar) and bcinstalled then
		installitem:SetRightBadge(BadgeStyle.None)
		bcinstalled = false
	end

	if not bcinstalled then
		killitem:SetRightBadge(BadgeStyle.Lock)
		unlockitem:SetRightBadge(BadgeStyle.Lock)
		repairitem:SetRightBadge(BadgeStyle.Lock)
		camitem:SetRightBadge(BadgeStyle.Lock)
	else
		killitem:SetRightBadge(BadgeStyle.None)
		unlockitem:SetRightBadge(BadgeStyle.None)
		repairitem:SetRightBadge(BadgeStyle.None)
		camitem:SetRightBadge(BadgeStyle.None)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		_menuPool:ProcessMenus()
		if IsControlJustPressed(menuInputGroup, menuControl) then
			if useAcePerms then
				if allowedToUse then
					mainMenu:Visible(not mainMenu:Visible())
				else
					ShowNotification(errorMenuOpen)
				end
			else mainMenu:Visible(not mainMenu:Visible()) end
		end
		
		if not DoesEntityExist(baitcar) and bcinstalled then
			installitem:SetRightBadge(BadgeStyle.None)
			bcinstalled = false
		end

		if not bcinstalled then
			killitem:SetRightBadge(BadgeStyle.Lock)
			unlockitem:SetRightBadge(BadgeStyle.Lock)
			repairitem:SetRightBadge(BadgeStyle.Lock)
			camitem:SetRightBadge(BadgeStyle.Lock)
		else
			killitem:SetRightBadge(BadgeStyle.None)
			unlockitem:SetRightBadge(BadgeStyle.None)
			repairitem:SetRightBadge(BadgeStyle.None)
			camitem:SetRightBadge(BadgeStyle.None)
		end
	end
end)

-- Utilities
function isVehicleOccupied(veh)
	local passenger = false
	for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1, 1
	do 
		if (GetPedInVehicleSeat(veh, i) ~= 0) then
			passenger = true
			
		end
	end
	return passenger
end

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	SetNotificationMessage("CHAR_BLOCKED", "CHAR_BLOCKED", false, 8, "WARNING", "")
	DrawNotification(false, false)
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
		SetTextFont(6)
		SetTextProportional(0)
		SetTextScale(scale, scale)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - width/2, y - height/2 + 0.005)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

Citizen.CreateThread(function()
	TriggerServerEvent("BaitCarPro.getIsAllowed")
end)

RegisterNetEvent("BaitCarPro.returnIsAllowed")
AddEventHandler("BaitCarPro.returnIsAllowed", function(isAllowed)
	allowedToUse = isAllowed
end)