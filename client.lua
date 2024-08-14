ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("NoName:Hospitalize")
AddEventHandler("NoName:Hospitalize", function(source)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 3.0 then
        notifyPlayer(_U('no_nearby'), 'error')
    else
        local closestPlayerPed = GetPlayerPed(closestPlayer)
        local health = GetEntityHealth(closestPlayerPed)

        if health == 0 and math.random(1,100) > 10 then
            local playerPed = GetPlayerPed(-1)
            notifyPlayer(_U('access_granted'), 'success')

            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            Citizen.Wait(10000)
            ClearPedTasks(playerPed)
            
            TriggerServerEvent('NoName:revive2', GetPlayerServerId(closestPlayer))

            ESX.SetPlayerData('loadout', {})
        else
            notifyPlayer(_U('access_failed'), 'error')
        end
    end
end)

RegisterNetEvent('saj_teleportPlayer')
AddEventHandler('saj_teleportPlayer', function(x, y, z)
    local ped = GetPlayerPed(-1)

    SetEntityCoords(ped, Config.HospitalCoords.coords.x, Config.HospitalCoords.coords.y, Config.HospitalCoords.coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(Config.HospitalCoords.coords.x, Config.HospitalCoords.coords.y, Config.HospitalCoords.coords.z, true, true, false)
    notifyPlayer(_U('teleported'), 'success')
end)

function notifyPlayer(message, type)
    if Config.Notify.System == 'okokNotify' then
        exports['okokNotify']:Alert('Information', message, 3000, type)
    elseif Config.Notify.System == 'custom' then
        TriggerEvent(Config.Notify.CustomNotifyClientEvent, message, type)
    end
end

-- Load the correct locale based on config
local function _U(entry)
    local locale = Config.Locale
    if Locales[locale] and Locales[locale][entry] then
        return Locales[locale][entry]
    else
        return entry -- If the entry does not exist, return the key itself
    end
end
