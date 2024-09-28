fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Vectron Drugsfarms'
description 'A fivem esx drugsfarm script'
author 'Florianvhunnik'

server_scripts {
    'configuration/*.lua',
    'server/*.lua'
}

client_scripts {
    'configuration/*.lua',
    'client/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}