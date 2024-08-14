ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(Config.Items.Itemname1, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and hasJob(xPlayer.job.name) then
        TriggerClientEvent('NoName:Hospitalize', source)
    else
        notifyPlayer(source, _U('not_allowed'), 'error')
    end 
end)

ESX.RegisterUsableItem(Config.Items.Itemname2, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM licenses WHERE license = @license AND owner = @owner', {
        ['@license'] = 'firstaidcourse',
        ['@owner'] = identifier
    }, function(result)
        if result[1] then
            TriggerClientEvent('NoName:Hospitalize', source)
            xPlayer.removeInventoryItem(Config.Items.Morphin2, 1)
        else
            notifyPlayer(source, _U('license_required'), 'error')
        end
    end) 
end)

RegisterNetEvent('NoName:revive2')
AddEventHandler('NoName:revive2', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if xTarget then
        if xTarget.getMoney() > 0 then
            xTarget.removeMoney(xTarget.getMoney(), "Death")
        end
        
        if xTarget.getAccount('black_money').money > 0 then
            xTarget.setAccountMoney('black_money', 0, "Death")
        end

        -- Check if qs-inventory is used
        if Config.UseQSInventory then
            -- Clear inventory using qs-inventory system
            exports['qs-inventory']:ClearInventory(xTarget, Config.SaveItems)
            
            -- Remove all weapons
            local weapons = exports['qs-inventory']:GetWeaponList()
            for _, weapon in pairs(weapons) do
                xTarget.removeInventoryItem(weapon.name, 1)
            end
        else
            -- Clear inventory using default ESX system
            for _, item in pairs(xTarget.getInventory()) do
                if not isItemSaved(item.name) then
                    xTarget.removeInventoryItem(item.name, item.count)
                end
            end

            -- Remove all weapons (default ESX)
            for _, weapon in pairs(xTarget.getLoadout()) do
                xTarget.removeWeapon(weapon.name)
            end
        end

        TriggerClientEvent('saj_teleportPlayer', xTarget, Config.HospitalCoords.x, Config.HospitalCoords.y, Config.HospitalCoords.z)
        xTarget.triggerEvent('morphinscript') 
        notifyPlayer(source, _U('revive_success'), 'success')
    else
        notifyPlayer(source, _U('revive_failed'), 'error')
    end
end)

function hasJob(jobName)
    for _, job in pairs(Config.AllowedJobs) do
        if jobName == job then
            return true
        end
    end
    return false
end

function notifyPlayer(playerId, message, type)
    if Config.Notify.System == 'okokNotify' then
        TriggerClientEvent('okokNotify:Alert', playerId, 'Information', message, 5000, type)
    elseif Config.Notify.System == 'custom' then
        TriggerClientEvent(Config.Notify.CustomNotifyClientEvent, playerId, message, type)
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
