fx_version 'cerulean'
game 'gta5'

author 'SimpliAj'
description 'Morphin Revive System'
version '1.0.0'

-- Client Scripts
client_scripts {
    'config.lua',
    'locales/*.lua', 
    'client.lua'
}

-- Server Scripts
server_scripts {
    '@mysql-async/lib/MySQL.lua', 
    'config.lua',
    'locales/*.lua',  
    'server.lua'
}

-- Diasble If dont Used
dependencies {
    'es_extended', 
    'qs-inventory', 
    'okokNotify'   
}
