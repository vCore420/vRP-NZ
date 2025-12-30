fx_version 'cerulean'
game 'gta5'

author 'vCore'
description 'vRP NZ Core Framework'
version '0.1.0'

shared_scripts {
    'config.lua',
    'shared/utils.lua'
}

server_scripts {
    'server/main.lua',
    'server/db.lua',
    'server/utils.lua'
}

client_scripts {
    'client/main.lua',
    'client/utils.lua'
}