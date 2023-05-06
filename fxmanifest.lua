shared_script '@AC/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'rdr3', 'gta5' }
author 'rambo'
description 'Fake Playes'
version '1.0'
client_scripts {
    'client/*.lua',
}

server_scripts {
	'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}
