local Menu = exports.vorp_menu:GetMenuData()

RegisterNetEvent("tp_menu:openMenu")
AddEventHandler("tp_menu:openMenu", function()
    OpenTeleportMenu()
end)

function OpenTeleportMenu()
    Menu.CloseAll()
    
    local elements = {
        {label = "Save(Add) New Location", value = "save_location"},
        {label = "View Saved Locations", value = "view_locations"}
    }

    Menu.Open('default', GetCurrentResourceName(), 'teleport_menu', {
        title = 'Teleport Menu',
        align = 'top-right', -- top-right
        elements = elements
    }, function(data, menu)
        if data.current.value == "save_location" then
            SaveNewLocation()
        elseif data.current.value == "view_locations" then
            ViewSavedLocations()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function SaveNewLocation()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    TriggerEvent("vorpinputs:getInput", "Save", "Enter Location Name", function(locationName)
        if locationName and locationName ~= "" then
            TriggerServerEvent("tp_menu:saveLocation", locationName, coords.x, coords.y, coords.z)
            print("Location saved: " .. locationName)
        else
            print("Location name cannot be empty")
        end
    end)
end

function ViewSavedLocations()
    TriggerServerEvent("tp_menu:getLocations")
end

RegisterNetEvent("tp_menu:showLocations")
AddEventHandler("tp_menu:showLocations", function(locations)
    Menu.CloseAll()

    local elements = {}

    if locations then
        for _, location in ipairs(locations) do
            table.insert(elements, {label = location.location_name, value = location.id})
        end

        Menu.Open('default', GetCurrentResourceName(), 'view_locations', {
            title = 'Saved Locations',
            align = 'top-right', -- top-right
            elements = elements
        }, function(data, menu)
            OpenLocationOptionsMenu(data.current.value)
        end, function(data, menu)
            menu.close()
        end)
    else
        TriggerEvent("vorp:TipRight", "No saved location found.", 3000)
    end
end)

function OpenLocationOptionsMenu(locationId)
    Menu.CloseAll()
    
    local elements = {
        {label = "Teleport to Location", value = "teleport"},
        {label = "Edit Location Name", value = "rename"},
        {label = "Delete Location", value = "delete"}
    }

    Menu.Open('default', GetCurrentResourceName(), 'location_options', {
        title = 'Location Options',
        align = 'top-right', -- top-right
        elements = elements
    }, function(data, menu)
        if data.current.value == "teleport" then
            TriggerServerEvent("tp_menu:teleportToLocation", locationId)
        elseif data.current.value == "rename" then
            RenameLocation(locationId)
        elseif data.current.value == "delete" then
            TriggerServerEvent("tp_menu:deleteLocation", locationId)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function RenameLocation(locationId)
    TriggerEvent("vorpinputs:getInput", "Edit", "Enter new location name", function(newName)
        if newName and newName ~= "" then
            TriggerServerEvent("tp_menu:renameLocation", locationId, newName)
        else
            print("Location name cannot be empty")
        end
    end)
end

RegisterNetEvent("tp_menu:teleportPlayer")
AddEventHandler("tp_menu:teleportPlayer", function(coords)
    if coords then
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
        TriggerEvent("vorp:TipRight", "You have successfully teleported.", 3000)
    else
        TriggerEvent("vorp:TipRight", "Invalid coordinates.", 3000)
    end
end)

RegisterNetEvent("tp_menu:deleteLocation")
AddEventHandler("tp_menu:deleteLocation", function(locationId)
    TriggerServerEvent("tp_menu:deleteLocation", locationId)
end)