-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

M('table')
local Menu = M('ui.menu')

self.RegisteredControls   = {}
self.EnabledControls      = {}
self.LastPressed          = {}
self.LastDisabledPressed  = {}
self.LastReleased         = {}
self.LastDisabledReleased = {}

self.Groups = {
  MOVE                   = 0,
  LOOK                   = 1,
  WHEEL                  = 2,
  CELLPHONE_NAVIGATE     = 3,
  CELLPHONE_NAVIGATE_UD  = 4,
  CELLPHONE_NAVIGATE_LR  = 5,
  FRONTEND_DPAD_ALL      = 6,
  FRONTEND_DPAD_UD       = 7,
  FRONTEND_DPAD_LR       = 8,
  FRONTEND_LSTICK_ALL    = 9,
  FRONTEND_RSTICK_ALL    = 10,
  FRONTEND_GENERIC_UD    = 11,
  FRONTEND_GENERIC_LR    = 12,
  FRONTEND_GENERIC_ALL   = 13,
  FRONTEND_BUMPERS       = 14,
  FRONTEND_TRIGGERS      = 15,
  FRONTEND_STICKS        = 16,
  SCRIPT_DPAD_ALL        = 17,
  SCRIPT_DPAD_UD         = 18,
  SCRIPT_DPAD_LR         = 19,
  SCRIPT_LSTICK_ALL      = 20,
  SCRIPT_RSTICK_ALL      = 21,
  SCRIPT_BUMPERS         = 22,
  SCRIPT_TRIGGERS        = 23,
  WEAPON_WHEEL_CYCLE     = 24,
  FLY                    = 25,
  SUB                    = 26,
  VEH_MOVE_ALL           = 27,
  CURSOR                 = 28,
  CURSOR_SCROLL          = 29,
  SNIPER_ZOOM_SECONDARY  = 30,
  VEH_HYDRAULICS_CONTROL = 31,
}

self.Controls = {
  NEXT_CAMERA                           = 0,
  LOOK_LR                               = 1,
  LOOK_UD                               = 2,
  LOOK_UP_ONLY                          = 3,
  LOOK_DOWN_ONLY                        = 4,
  LOOK_LEFT_ONLY                        = 5,
  LOOK_RIGHT_ONLY                       = 6,
  CINEMATIC_SLOWMO                      = 7,
  SCRIPTED_FLY_UD                       = 8,
  SCRIPTED_FLY_LR                       = 9,
  SCRIPTED_FLY_ZUP                      = 10,
  SCRIPTED_FLY_ZDOWN                    = 11,
  WEAPON_WHEEL_UD                       = 12,
  WEAPON_WHEEL_LR                       = 13,
  WEAPON_WHEEL_NEXT                     = 14,
  WEAPON_WHEEL_PREV                     = 15,
  SELECT_NEXT_WEAPON                    = 16,
  SELECT_PREV_WEAPON                    = 17,
  SKIP_CUTSCENE                         = 18,
  CHARACTER_WHEEL                       = 19,
  MULTIPLAYER_INFO                      = 20,
  SPRINT                                = 21,
  JUMP                                  = 22,
  ENTER                                 = 23,
  ATTACK                                = 24,
  AIM                                   = 25,
  LOOK_BEHIND                           = 26,
  PHONE                                 = 27,
  SPECIAL_ABILITY                       = 28,
  SPECIAL_ABILITY_SECONDARY             = 29,
  MOVE_LR                               = 30,
  MOVE_UD                               = 31,
  MOVE_UP_ONLY                          = 32,
  MOVE_DOWN_ONLY                        = 33,
  MOVE_LEFT_ONLY                        = 34,
  MOVE_RIGHT_ONLY                       = 35,
  DUCK                                  = 36,
  SELECT_WEAPON                         = 37,
  PICKUP                                = 38,
  SNIPER_ZOOM                           = 39,
  SNIPER_ZOOM_IN_ONLY                   = 40,
  SNIPER_ZOOM_OUT_ONLY                  = 41,
  SNIPER_ZOOM_IN_SECONDARY              = 42,
  SNIPER_ZOOM_OUT_SECONDARY             = 43,
  COVER                                 = 44,
  RELOAD                                = 45,
  TALK                                  = 46,
  DETONATE                              = 47,
  HUD_SPECIAL                           = 48,
  ARREST                                = 49,
  ACCURATE_AIM                          = 50,
  CONTEXT                               = 51,
  CONTEXT_SECONDARY                     = 52,
  WEAPON_SPECIAL                        = 53,
  WEAPON_SPECIAL_TWO                    = 54,
  DIVE                                  = 55,
  DROP_WEAPON                           = 56,
  DROP_AMMO                             = 57,
  THROW_GRENADE                         = 58,
  VEH_MOVE_LR                           = 59,
  VEH_MOVE_UD                           = 60,
  VEH_MOVE_UP_ONLY                      = 61,
  VEH_MOVE_DOWN_ONLY                    = 62,
  VEH_MOVE_LEFT_ONLY                    = 63,
  VEH_MOVE_RIGHT_ONLY                   = 64,
  VEH_SPECIAL                           = 65,
  VEH_GUN_LR                            = 66,
  VEH_GUN_UD                            = 67,
  VEH_AIM                               = 68,
  VEH_ATTACK                            = 69,
  VEH_ATTACK2                           = 70,
  VEH_ACCELERATE                        = 71,
  VEH_BRAKE                             = 72,
  VEH_DUCK                              = 73,
  VEH_HEADLIGHT                         = 74,
  VEH_EXIT                              = 75,
  VEH_HANDBRAKE                         = 76,
  VEH_HOTWIRE_LEFT                      = 77,
  VEH_HOTWIRE_RIGHT                     = 78,
  VEH_LOOK_BEHIND                       = 79,
  VEH_CIN_CAM                           = 80,
  VEH_NEXT_RADIO                        = 81,
  VEH_PREV_RADIO                        = 82,
  VEH_NEXT_RADIO_TRACK                  = 83,
  VEH_PREV_RADIO_TRACK                  = 84,
  VEH_RADIO_WHEEL                       = 85,
  VEH_HORN                              = 86,
  VEH_FLY_THROTTLE_UP                   = 87,
  VEH_FLY_THROTTLE_DOWN                 = 88,
  VEH_FLY_YAW_LEFT                      = 89,
  VEH_FLY_YAW_RIGHT                     = 90,
  VEH_PASSENGER_AIM                     = 91,
  VEH_PASSENGER_ATTACK                  = 92,
  VEH_SPECIAL_ABILITY_FRANKLIN          = 93,
  VEH_STUNT_UD                          = 94,
  VEH_CINEMATIC_UD                      = 95,
  VEH_CINEMATIC_UP_ONLY                 = 96,
  VEH_CINEMATIC_DOWN_ONLY               = 97,
  VEH_CINEMATIC_LR                      = 98,
  VEH_SELECT_NEXT_WEAPON                = 99,
  VEH_SELECT_PREV_WEAPON                = 100,
  VEH_ROOF                              = 101,
  VEH_JUMP                              = 102,
  VEH_GRAPPLING_HOOK                    = 103,
  VEH_SHUFFLE                           = 104,
  VEH_DROP_PROJECTILE                   = 105,
  VEH_MOUSE_CONTROL_OVERRIDE            = 106,
  VEH_FLY_ROLL_LR                       = 107,
  VEH_FLY_ROLL_LEFT_ONLY                = 108,
  VEH_FLY_ROLL_RIGHT_ONLY               = 109,
  VEH_FLY_PITCH_UD                      = 110,
  VEH_FLY_PITCH_UP_ONLY                 = 111,
  VEH_FLY_PITCH_DOWN_ONLY               = 112,
  VEH_FLY_UNDERCARRIAGE                 = 113,
  VEH_FLY_ATTACK                        = 114,
  VEH_FLY_SELECT_NEXT_WEAPON            = 115,
  VEH_FLY_SELECT_PREV_WEAPON            = 116,
  VEH_FLY_SELECT_TARGET_LEFT            = 117,
  VEH_FLY_SELECT_TARGET_RIGHT           = 118,
  VEH_FLY_VERTICAL_FLIGHT_MODE          = 119,
  VEH_FLY_DUCK                          = 120,
  VEH_FLY_ATTACK_CAMERA                 = 121,
  VEH_FLY_MOUSE_CONTROL_OVERRIDE        = 122,
  VEH_SUB_TURN_LR                       = 123,
  VEH_SUB_TURN_LEFT_ONLY                = 124,
  VEH_SUB_TURN_RIGHT_ONLY               = 125,
  VEH_SUB_PITCH_UD                      = 126,
  VEH_SUB_PITCH_UP_ONLY                 = 127,
  VEH_SUB_PITCH_DOWN_ONLY               = 128,
  VEH_SUB_THROTTLE_UP                   = 129,
  VEH_SUB_THROTTLE_DOWN                 = 130,
  VEH_SUB_ASCEND                        = 131,
  VEH_SUB_DESCEND                       = 132,
  VEH_SUB_TURN_HARD_LEFT                = 133,
  VEH_SUB_TURN_HARD_RIGHT               = 134,
  VEH_SUB_MOUSE_CONTROL_OVERRIDE        = 135,
  VEH_PUSHBIKE_PEDAL                    = 136,
  VEH_PUSHBIKE_SPRINT                   = 137,
  VEH_PUSHBIKE_FRONT_BRAKE              = 138,
  VEH_PUSHBIKE_REAR_BRAKE               = 139,
  MELEE_ATTACK_LIGHT                    = 140,
  MELEE_ATTACK_HEAVY                    = 141,
  MELEE_ATTACK_ALTERNATE                = 142,
  MELEE_BLOCK                           = 143,
  PARACHUTE_DEPLOY                      = 144,
  PARACHUTE_DETACH                      = 145,
  PARACHUTE_TURN_LR                     = 146,
  PARACHUTE_TURN_LEFT_ONLY              = 147,
  PARACHUTE_TURN_RIGHT_ONLY             = 148,
  PARACHUTE_PITCH_UD                    = 149,
  PARACHUTE_PITCH_UP_ONLY               = 150,
  PARACHUTE_PITCH_DOWN_ONLY             = 151,
  PARACHUTE_BRAKE_LEFT                  = 152,
  PARACHUTE_BRAKE_RIGHT                 = 153,
  PARACHUTE_SMOKE                       = 154,
  PARACHUTE_PRECISION_LANDING           = 155,
  MAP                                   = 156,
  SELECT_WEAPON_UNARMED                 = 157,
  SELECT_WEAPON_MELEE                   = 158,
  SELECT_WEAPON_HANDGUN                 = 159,
  SELECT_WEAPON_SHOTGUN                 = 160,
  SELECT_WEAPON_SMG                     = 161,
  SELECT_WEAPON_AUTO_RIFLE              = 162,
  SELECT_WEAPON_SNIPER                  = 163,
  SELECT_WEAPON_HEAVY                   = 164,
  SELECT_WEAPON_SPECIAL                 = 165,
  SELECT_CHARACTER_MICHAEL              = 166,
  SELECT_CHARACTER_FRANKLIN             = 167,
  SELECT_CHARACTER_TREVOR               = 168,
  SELECT_CHARACTER_MULTIPLAYER          = 169,
  SAVE_REPLAY_CLIP                      = 170,
  SPECIAL_ABILITY_PC                    = 171,
  CELLPHONE_UP                          = 172,
  CELLPHONE_DOWN                        = 173,
  CELLPHONE_LEFT                        = 174,
  CELLPHONE_RIGHT                       = 175,
  CELLPHONE_SELECT                      = 176,
  CELLPHONE_CANCEL                      = 177,
  CELLPHONE_OPTION                      = 178,
  CELLPHONE_EXTRA_OPTION                = 179,
  CELLPHONE_SCROLL_FORWARD              = 180,
  CELLPHONE_SCROLL_BACKWARD             = 181,
  CELLPHONE_CAMERA_FOCUS_LOCK           = 182,
  CELLPHONE_CAMERA_GRID                 = 183,
  CELLPHONE_CAMERA_SELFIE               = 184,
  CELLPHONE_CAMERA_DOF                  = 185,
  CELLPHONE_CAMERA_EXPRESSION           = 186,
  FRONTEND_DOWN                         = 187,
  FRONTEND_UP                           = 188,
  FRONTEND_LEFT                         = 189,
  FRONTEND_RIGHT                        = 190,
  FRONTEND_RDOWN                        = 191,
  FRONTEND_RUP                          = 192,
  FRONTEND_RLEFT                        = 193,
  FRONTEND_RRIGHT                       = 194,
  FRONTEND_AXIS_X                       = 195,
  FRONTEND_AXIS_Y                       = 196,
  FRONTEND_RIGHT_AXIS_X                 = 197,
  FRONTEND_RIGHT_AXIS_Y                 = 198,
  FRONTEND_PAUSE                        = 199,
  FRONTEND_PAUSE_ALTERNATE              = 200,
  FRONTEND_ACCEPT                       = 201,
  FRONTEND_CANCEL                       = 202,
  FRONTEND_X                            = 203,
  FRONTEND_Y                            = 204,
  FRONTEND_LB                           = 205,
  FRONTEND_RB                           = 206,
  FRONTEND_LT                           = 207,
  FRONTEND_RT                           = 208,
  FRONTEND_LS                           = 209,
  FRONTEND_RS                           = 210,
  FRONTEND_LEADERBOARD                  = 211,
  FRONTEND_SOCIAL_CLUB                  = 212,
  FRONTEND_SOCIAL_CLUB_SECONDARY        = 213,
  FRONTEND_DELETE                       = 214,
  FRONTEND_ENDSCREEN_ACCEPT             = 215,
  FRONTEND_ENDSCREEN_EXPAND             = 216,
  FRONTEND_SELECT                       = 217,
  SCRIPT_LEFT_AXIS_X                    = 218,
  SCRIPT_LEFT_AXIS_Y                    = 219,
  SCRIPT_RIGHT_AXIS_X                   = 220,
  SCRIPT_RIGHT_AXIS_Y                   = 221,
  SCRIPT_RUP                            = 222,
  SCRIPT_RDOWN                          = 223,
  SCRIPT_RLEFT                          = 224,
  SCRIPT_RRIGHT                         = 225,
  SCRIPT_LB                             = 226,
  SCRIPT_RB                             = 227,
  SCRIPT_LT                             = 228,
  SCRIPT_RT                             = 229,
  SCRIPT_LS                             = 230,
  SCRIPT_RS                             = 231,
  SCRIPT_PAD_UP                         = 232,
  SCRIPT_PAD_DOWN                       = 233,
  SCRIPT_PAD_LEFT                       = 234,
  SCRIPT_PAD_RIGHT                      = 235,
  SCRIPT_SELECT                         = 236,
  CURSOR_ACCEPT                         = 237,
  CURSOR_CANCEL                         = 238,
  CURSOR_X                              = 239,
  CURSOR_Y                              = 240,
  CURSOR_SCROLL_UP                      = 241,
  CURSOR_SCROLL_DOWN                    = 242,
  ENTER_CHEAT_CODE                      = 243,
  INTERACTION_MENU                      = 244,
  MP_TEXT_CHAT_ALL                      = 245,
  MP_TEXT_CHAT_TEAM                     = 246,
  MP_TEXT_CHAT_FRIENDS                  = 247,
  MP_TEXT_CHAT_CREW                     = 248,
  PUSH_TO_TALK                          = 249,
  CREATOR_LS                            = 250,
  CREATOR_RS                            = 251,
  CREATOR_LT                            = 252,
  CREATOR_RT                            = 253,
  CREATOR_MENU_TOGGLE                   = 254,
  CREATOR_ACCEPT                        = 255,
  CREATOR_DELETE                        = 256,
  ATTACK2                               = 257,
  RAPPEL_JUMP                           = 258,
  RAPPEL_LONG_JUMP                      = 259,
  RAPPEL_SMASH_WINDOW                   = 260,
  PREV_WEAPON                           = 261,
  NEXT_WEAPON                           = 262,
  MELEE_ATTACK1                         = 263,
  MELEE_ATTACK2                         = 264,
  WHISTLE                               = 265,
  MOVE_LEFT                             = 266,
  MOVE_RIGHT                            = 267,
  MOVE_UP                               = 268,
  MOVE_DOWN                             = 269,
  LOOK_LEFT                             = 270,
  LOOK_RIGHT                            = 271,
  LOOK_UP                               = 272,
  LOOK_DOWN                             = 273,
  SNIPER_ZOOM_IN                        = 274,
  SNIPER_ZOOM_OUT                       = 275,
  SNIPER_ZOOM_IN_ALTERNATE              = 276,
  SNIPER_ZOOM_OUT_ALTERNATE             = 277,
  VEH_MOVE_LEFT                         = 278,
  VEH_MOVE_RIGHT                        = 279,
  VEH_MOVE_UP                           = 280,
  VEH_MOVE_DOWN                         = 281,
  VEH_GUN_LEFT                          = 282,
  VEH_GUN_RIGHT                         = 283,
  VEH_GUN_UP                            = 284,
  VEH_GUN_DOWN                          = 285,
  VEH_LOOK_LEFT                         = 286,
  VEH_LOOK_RIGHT                        = 287,
  REPLAY_START_STOP_RECORDING           = 288,
  REPLAY_START_STOP_RECORDING_SECONDARY = 289,
  SCALED_LOOK_LR                        = 290,
  SCALED_LOOK_UD                        = 291,
  SCALED_LOOK_UP_ONLY                   = 292,
  SCALED_LOOK_DOWN_ONLY                 = 293,
  SCALED_LOOK_LEFT_ONLY                 = 294,
  SCALED_LOOK_RIGHT_ONLY                = 295,
  REPLAY_MARKER_DELETE                  = 296,
  REPLAY_CLIP_DELETE                    = 297,
  REPLAY_PAUSE                          = 298,
  REPLAY_REWIND                         = 299,
  REPLAY_FFWD                           = 300,
  REPLAY_NEWMARKER                      = 301,
  REPLAY_RECORD                         = 302,
  REPLAY_SCREENSHOT                     = 303,
  REPLAY_HIDEHUD                        = 304,
  REPLAY_STARTPOINT                     = 305,
  REPLAY_ENDPOINT                       = 306,
  REPLAY_ADVANCE                        = 307,
  REPLAY_BACK                           = 308,
  REPLAY_TOOLS                          = 309,
  REPLAY_RESTART                        = 310,
  REPLAY_SHOWHOTKEY                     = 311,
  REPLAY_CYCLEMARKERLEFT                = 312,
  REPLAY_CYCLEMARKERRIGHT               = 313,
  REPLAY_FOVINCREASE                    = 314,
  REPLAY_FOVDECREASE                    = 315,
  REPLAY_CAMERAUP                       = 316,
  REPLAY_CAMERADOWN                     = 317,
  REPLAY_SAVE                           = 318,
  REPLAY_TOGGLETIME                     = 319,
  REPLAY_TOGGLETIPS                     = 320,
  REPLAY_PREVIEW                        = 321,
  REPLAY_TOGGLE_TIMELINE                = 322,
  REPLAY_TIMELINE_PICKUP_CLIP           = 323,
  REPLAY_TIMELINE_DUPLICATE_CLIP        = 324,
  REPLAY_TIMELINE_PLACE_CLIP            = 325,
  REPLAY_CTRL                           = 326,
  REPLAY_TIMELINE_SAVE                  = 327,
  REPLAY_PREVIEW_AUDIO                  = 328,
  VEH_DRIVE_LOOK                        = 329,
  VEH_DRIVE_LOOK2                       = 330,
  VEH_FLY_ATTACK2                       = 331,
  RADIO_WHEEL_UD                        = 332,
  RADIO_WHEEL_LR                        = 333,
  VEH_SLOWMO_UD                         = 334,
  VEH_SLOWMO_UP_ONLY                    = 335,
  VEH_SLOWMO_DOWN_ONLY                  = 336,
  VEH_HYDRAULICS_CONTROL_TOGGLE         = 337,
  VEH_HYDRAULICS_CONTROL_LEFT           = 338,
  VEH_HYDRAULICS_CONTROL_RIGHT          = 339,
  VEH_HYDRAULICS_CONTROL_UP             = 340,
  VEH_HYDRAULICS_CONTROL_DOWN           = 341,
  VEH_HYDRAULICS_CONTROL_UD             = 342,
  VEH_HYDRAULICS_CONTROL_LR             = 343,
  MAP_POI                               = 344,
  INPUT_REPLAY_SNAPMATIC_PHOTO          = 345,
}

self.RegisterControl = function(group, id)
  if table.indexOf(self.RegisteredControls[group], id) == -1 then
    self.RegisteredControls[group][#self.RegisteredControls[group] + 1] = id
  end
end

self.UnregisterControl = function(group, id)
  if table.indexOf(self.RegisteredControls[group], id) ~= -1 then
    table.remove(self.RegisteredControls[group], table.indexOf(self.RegisteredControls[group], id))
  end
end

self.EnableControl = function(group, id)
  self.EnabledControls[group][id] = self.EnabledControls[group][id] + 1
end

self.DisableControl = function(group, id)
  self.EnabledControls[group][id] = self.EnabledControls[group][id] - 1
end

self.IsControlRegistered = function(group, id)
  return table.indexOf(self.RegisteredControls[group], id) ~= -1
end

self.IsControlPressed = function(group, id)
  return self.IsControlEnabled(group, id) and (IsControlPressed(group, id))
end

self.IsDisabledControlPressed = function(group, id)
  return (not self.IsControlEnabled(group, id)) and (IsDisabledControlPressed(group, id))
end

self.IsControlEnabled = function(group, id)
  return self.EnabledControls[group][id] >= 0
end

for k1, group in pairs(self.Groups) do

  self.RegisteredControls[group]   = {}
  self.EnabledControls[group]      = {}
  self.LastPressed[group]          = {}
  self.LastDisabledPressed[group]  = {}
  self.LastReleased[group]         = {}
  self.LastDisabledReleased[group] = {}

  for k2, id in pairs(self.Controls) do
    self.EnabledControls[group][id]      = 0
    self.LastPressed[group][id]          = -1
    self.LastDisabledPressed[group][id]  = -1
    self.LastReleased[group][id]         = -1
    self.LastDisabledReleased[group][id] = -1
  end

end

self.On = function(event, group, id, cb)

  return on('esx:input:' .. event .. ':' .. group .. ':'  .. id, cb)

end

self.InitESX = function()

  self.RegisterControl(self.Groups.MOVE, self.Controls[Config.InventoryKey])
  self.On('released', self.Groups.MOVE, self.Controls[Config.InventoryKey], function(lastPressed)

    if (not ESX.IsDead) and (not Menu.IsOpen('default', 'es_extended', 'inventory')) then
      ESX.ShowInventory()
    end

  end)

end
