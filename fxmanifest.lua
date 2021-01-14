fx_version "cerulean"
game "gta5"

name "GGCommon"
description "Gamemode independant features for the Gun Game server"
author "Remco Troost (d0p3t)"
url "https://github.com/d0p3t/ggcommon"

dependency "screenshot-basic"

client_scripts {
  "client/*.lua"
}

server_scripts {
  "server/*.lua"
}

files {
  "client/lib/Newtonsoft.Json.dll",
  "client/lib/index.html",
  "client/lib/audio/**/*.ogg",
  "client/lib/*.min.css",
  "client/lib/*.css",
  "client/lib/*.min.js"
}

ui_page "client/lib/index.html"

server_export "PrintLog"
server_export "Log"
server_export "Screenshot"
server_export "SentryIssue"
