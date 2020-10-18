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

self.LOVE_PLAYER_GROUP = AddRelationshipGroup('LOVE_PLAYER')

SetRelationshipBetweenGroups(0, self.LOVE_PLAYER_GROUP, 'PLAYER')

ESX.SetInterval(250, function()

  local ped    = PlayerPedId()
  local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -1.0)

  self.Cache.player.ped    = ped
  self.Cache.player.coords = vector3(table.unpack(coords))

  local toRemove = {}

  for i=1, #self.Data, 1 do

    local data = self.Data[i]

    if data.pos == nil then

      print('[esx_interact] data.pos is nil => ' .. json.encode(data))

    else

      local distance = #(data.pos - self.Cache.player.coords);
      if
        (distance <= data.distance) and
        (table.findIndex(self.Cache.current , function(e) return e.__id == data.__id end) == -1)
      then

        if (data.check == nil) or data.check(self.Cache.player.ped, self.Cache.player.coords) then
          data.playing = false
          self.Cache.current[#self.Cache.current + 1] = data
        end

      elseif (distance > data.distance) then

        local idx = table.findIndex(self.Cache.current, function(e) return e.__id == data.__id end)

        if idx ~= -1 then
          toRemove[#toRemove + 1] = idx
        end

      end

    end

  end

  if #toRemove > 0 then
    self.Cache.current = table.filter(self.Cache.current, function(e) return table.indexOf(toRemove, e.__id) ~= -1 end)
  end

end)

-- Markers
Citizen.CreateThread(function()

  for i=1, #self.Cache.current, 1 do

    local curr = self.Cache.current[i]

    if curr.type == 'marker' then

      DrawMarker(
        curr.mtype,
        curr.pos.x + 0.0, curr.pos.y + 0.0, curr.pos.z + 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        curr.size.x + 0.0, curr.size.y + 0.0, curr.size.z + 0.0,
        curr.color.r, curr.color.g, curr.color.b, curr.color.a,
        curr.bobUpAndDown, curr.faceCamera, 2, curr.rotate, nil, nil, false
      )

    end

  end

  Citizen.Wait(0)

end)

-- NPCs
ESX.SetInterval(1000, function()

  for i=1, #self.Cache.current, 1 do

    local curr = self.Cache.current[i]

    if curr.type == 'npc' then

      if IsModelValid(curr.model) and IsModelInCdimage(curr.model) then

        local found = false

        local closestPed, closestDistance = ESX.Game.GetClosestPed({
          x = curr.pos.x + 0.0,
          y = curr.pos.y + 0.0,
          z = curr.pos.z + 0.0
        }, {Cache.player.ped})

        if closestPed ~= -1 then

          local model = GetEntityModel(closestPed)

          if (model == curr.model) and (closestDistance <= 10.0) then

            found = true

            if (curr.lib ~= nil) and (curr.anim ~= nil) then

              if not HasAnimDictLoaded(curr.lib) then
                RequestAnimDict(curr.lib)
              end

              if HasAnimDictLoaded(curr.lib) and (not curr.playing) then
                curr.playing = true
                TaskPlayAnim(closestPed, curr.lib, curr.anim, 8.0, -8.0, -1, 1, 1.0, false, false, false)
              end

            end

          end

        end

        if not found then

          print('Create ped : ' .. curr.model .. ' @ ' .. curr.pos.x .. ' ' .. curr.pos.y .. ' ' .. curr.pos.z)

          RequestModel(curr.model)

          while not HasModelLoaded(curr.model) do
            Citizen.Wait(0)
          end

          curr.__ped = CreatePed(26, curr.model, curr.pos.x + 0.0, curr.pos.y + 0.0, curr.pos.z + 0.0, curr.heading + 0.0, true, false)

          SetModelAsNoLongerNeeded(curr.model)

          SetPedRelationshipGroupHash(curr.__ped, self.LOVE_PLAYER_GROUP)
          SetBlockingOfNonTemporaryEvents(curr.__ped, true)
          TaskStandStill(curr.__ped, -1)
          SetEntityInvincible(curr.__ped, true)
          FreezeEntityPosition(curr.__ped, true)

        end

      else
        print('Invalid/inexistent model => ' .. curr.model)
      end

    end

  end

end)

ESX.SetInterval(250, function()

  for i=1, #self.Cache.current, 1 do

    local data     = self.Cache.current[i]
    local distance = #(data.pos - self.Cache.player.coords);

    if (distance <= data.radius) and (not self.Cache.using[data.__id]) then
      self.Cache.using[data.__id] = true
      emit('esx:interact:enter', data.name, data)
    elseif (distance > data.radius) and self.Cache.using[data.__id] then
      self.Cache.using[data.__id] = nil
      emit('esx:interact:exit', data.name, data)
    end

  end

end)
