fx_version 'cerulean'
version '1.0.0'
--lua54 'yes'
games { 'gta5' }

dependencies {
    'ox_lib',
}

files {
    'bridge/framework.lua',
    'bridge/inventory.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}

shared_scripts {
    '@ox_lib/init',
    'config.lua',
}
