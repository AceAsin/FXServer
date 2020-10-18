print("=======================")
print("Cuff+ Script by ECLIP3S Loaded")
print("=======================")

RegisterCommand("cuff", function(source, args, raw)
    local plyID = tonumber(args[1])

    TriggerClientEvent("Handcuff", plyID)
end, false)

RegisterCommand("hu", function(source, args, raw)
    local src = source

    TriggerClientEvent("Handsup", src)
end, false)

RegisterCommand("huk", function(source, args, user)
    local src = source

    TriggerClientEvent("Handsupknees", src)
end, false)