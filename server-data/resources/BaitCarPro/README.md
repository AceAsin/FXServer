# BaitCarPro

A fully-featured, networked BaitCar system. Any vehicle can be tagged as a BaitCar with an intuitive menu. BaitCars can be remotely disabled by the player that installed the BaitCar system regardless of who is driving the vehicle. Players are unable to enter/exit a disabled BaitCar, and players inside the vehicle will be given a fake wanted level and an alert.
   
## Config

Settings can be modified in `bcpcl.lua`. Not all settings are listed here.

|setting|default|description|
| --- | --- | --- |
|`useAcePerm`|`false`|Toggles whether Ace permissions are required to open the menu.|
|`menuControl`|`246`|Sets which control activates the menu. Default is the 'Y' key.|
|`showGPS`|`true`|Toggles whether BaitCar blip is shown on the minimap. Only affects player that installed BaitCar system currently.|
|`alertOnEntry`|`true`|Displays text reading "BaitCar Occupied" at the bottom of the screen when a suspect has entered the BaitCar.|
|`toggleMouse`|`false`|Toggles whether menu can be controlled with the mouse.|
|`blipColor`|`1`|Changes color of radar blip for BaitCar. Default is red.|
|`blipRoute`|`true`|Toggles route to blip on minimap, only seems to display while in a vehicle.|
|`blipHeading`|`true`|Toggles whether blip shows an indicator for the direction BaitCar is facing.|
|`blipSprite`|`426`|Sets blip sprite on minimap, default is the blip for Insurgents.|

Notification text can also be changed in the config, in case you don't like my wording or wish to translate. Translating the menu will have to be done manually.

## Usage

Open the menu with the control button set in the config. Installing the BaitCar system in a vehicle will allow you to remotely disable, unlock, and rearm the BaitCar. Clicking the `Video Feed` option will display video from a dash cam viewing the interior of the vehicle. If the script breaks due to someone deleting a disabled BaitCar, use the `Reset` option to reset *ALL* BaitCar instances in the server.

## Dependencies
This script uses NativeUI for the menu, thus the [Lua version of NativeUI from FrazzIe](https://github.com/FrazzIe/NativeUILua) is required.

## Installation
Clone this repository in your `resources` folder.
Add `start BaitCarPro` to your `server.cfg`.
If using Ace Permissions add the following lines to your `server.cfg`:

`add_ace group.canBait BaitCarPro.open_menu allow`  
`add_principal identifier.steam:STEAM64HEXGOESHERE group.canBait`

Make sure to change the placeholder identifier.


## Credits

Thanks to [Xander1998](https://github.com/xander1998) for allowing me to modify his Dash Cam functions.  
Thanks to [Blü](https://github.com/bluethefurry) for allowing me to use his version checking functions.  

## Licensing

You MAY modify this resource to fit your server's needs.  
You MAY NOT release a modified version of this resource without my *express written permission*.  
You MAY NOT claim any part of this resource as your own.  
You MAY NOT remove any of the credits from the files or change my file names.  
You MAY NOT use this resource for commercial purposes.  

## Changelog:

### v1.0.0

* Initial release

