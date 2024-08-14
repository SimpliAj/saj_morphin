Config = {}

-- Define item names
Config.Items = {
    Itemname1 = 'morphin', -- Allowed Jobs
    Itemname2 = 'morphin2' -- requires license firstaidcourse
}

-- Define allowed jobs
Config.AllowedJobs = {'justiz', 'rettung', 'ambulance', 'fire'}

-- Notification settings
Config.Notify = {
    System = 'okokNotify', -- Options: 'okokNotify', 'custom', 'none'
    CustomNotifyClientEvent = 'myCustomNotifyClientEvent', -- Custom client-side notify trigger
    CustomNotifyServerEvent = 'myCustomNotifyServerEvent'  -- Custom server-side notify trigger
}

Config.Locale = 'de' -- Set the default locale (e.g., 'de' for German, 'en' for English)


-- Coordinates for teleport
Config.HospitalCoords = {x = -1874.0320, y = -322.4919, z = 49.4426}


-- INVENTORY SETTINGS
Config.UseQSInventory = true -- Set to 'true' to use qs-inventory, 'false' to use default ESX inventory

Config.SaveItems = {
    'id_card',
    'phone'
}


