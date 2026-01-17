fx_version 'bodacious'
game 'common'
author 'Max1337'


client_scripts {
    'html/js/client.js',
    'client/client.lua',
    'client/screen.lua',
}
server_scripts {
    'html/js/server.js',
    'server/server.lua'
}

files {
    'html/index.html'
}

ui_page 'html/index.html'

exports {
    'UploadScreenshot'
}