local VORPcore = exports.vorp_core:GetCore()
local oxmysql = exports['oxmysql']

RegisterCommand(Config.Command, function(source)
    local user = VORPcore.getUser(source)
    if not user then return end
    
    local character = user.getUsedCharacter
    
    if Config.EveryoneCanUse or character.group == Config.AdminGroup then
        TriggerClientEvent('tp_menu:openMenu', source)
    else
        TriggerClientEvent("vorp:TipRight", source, "You are not authorized to use this command", 3000)
    end
end, false)

RegisterServerEvent("tp_menu:saveLocation")
AddEventHandler("tp_menu:saveLocation", function(locationName, x, y, z)
    local _source = source
    local identifier = GetPlayerIdentifier(_source, 0) --Steam HEX

    oxmysql:insert("INSERT INTO tp_menu_locations (identifier, location_name, x, y, z) VALUES (?, ?, ?, ?, ?)", 
        {identifier, locationName, x, y, z}, function(id)
        if id then
            TriggerClientEvent("vorp:TipRight", _source, "Location saved", 3000)
        else
            print("Failed to save location")
        end
    end)
end)

RegisterServerEvent("tp_menu:getLocations")
AddEventHandler("tp_menu:getLocations", function()
    local _source = source
    local identifier = GetPlayerIdentifier(_source, 0)

    oxmysql:execute("SELECT * FROM tp_menu_locations WHERE identifier = ?", {identifier}, function(locations)
        if locations then
            TriggerClientEvent("tp_menu:showLocations", _source, locations)
        else
            TriggerClientEvent("vorp:TipRight", _source, "No saved location found", 3000)
        end
    end)
end)

RegisterServerEvent("tp_menu:teleportToLocation")
AddEventHandler("tp_menu:teleportToLocation", function(locationId)
    local _source = source

    oxmysql:execute("SELECT x, y, z FROM tp_menu_locations WHERE id = ?", {locationId}, function(result)
        if result and result[1] then
            local coords = vector3(result[1].x, result[1].y, result[1].z)
            TriggerClientEvent("tp_menu:teleportPlayer", _source, coords)
        else
            TriggerClientEvent("vorp:TipRight", _source, "No location found", 3000)
        end
    end)
end)

RegisterServerEvent("tp_menu:renameLocation")
AddEventHandler("tp_menu:renameLocation", function(locationId, newName)
    local _source = source

    oxmysql:execute("UPDATE tp_menu_locations SET location_name = ? WHERE id = ?", {newName, locationId}, function(result)
        if result and result.affectedRows > 0 then
            TriggerClientEvent("vorp:TipRight", _source, "Location successfully updated", 3000)
        end
    end)
end)

RegisterServerEvent("tp_menu:deleteLocation")
AddEventHandler("tp_menu:deleteLocation", function(locationId)
    local _source = source
    
    oxmysql:execute("DELETE FROM tp_menu_locations WHERE id = ?", {locationId}, function(result)
        if result and result.affectedRows > 0 then
            TriggerClientEvent("vorp:TipRight", _source, "Location successfully deleted", 3000)
        end
    end)
end)