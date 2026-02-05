fx_version 'cerulean'
version '1.0.0'
--lua54 'yes'
games { 'gta5' }

dependencies {
    'community_bridge',
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}

shared_scripts {
    'config.lua',
}
