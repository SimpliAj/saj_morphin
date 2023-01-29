ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local wasDead = false
local webhookUrl = "https://discordapp.com/api/webhooks/your_webhook_id/your_webhook_token"


RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(player)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = player
    }, function(result)
      if result[1].is_dead == 1 then
        wasDead = true
        TriggerClientEvent('esx_ambulancejob:setDead', source)
      end
    end)
  end)
end)

AddEventHandler('playerDropped', function()
  if wasDead then
    MySQL.Async.execute("UPDATE users SET is_dead = 1 WHERE identifier = @identifier", {
      ['@identifier'] = player
    })
    local name = GetPlayerName(source)
    local message = json.encode({content = name .. " combat logged and was killed"})
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', message, { ['Content-Type'] = 'application/json' })
  end
end)

AddEventHandler('esx:onPlayerDeath', function()
  wasDead = true
  local player = source
  MySQL.Async.execute("UPDATE users SET is_dead = 1 WHERE identifier = @identifier", {
    ['@identifier'] = player
  })
end)

-- UPDATE CHECKER

local version = '0.0.1'
local currentScript = 'No Emotes In Vehicles'

PerformHttpRequest("https://api.github.com/repos/SimpliAj/anticombatlogg_saj/releases/latest", function(err, text, headers)
    if err == 200 then
        local data = json.decode(text)
        if data.tag_name ~= version then
            print(currentScript .. ' is outdated, version ' .. data.tag_name .. ' is now available to download.')
        else
            print(currentScript .. ' is up to date.')
        end
    else
        print('Error checking for updates to ' .. currentScript .. ' (' .. err .. ')')
    end
end, "GET")
