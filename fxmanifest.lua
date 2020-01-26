fx_version "adamant"
game "gta5"

name "GGCommon"
description "Static Gun Game features"
author "Remco Troost (d0p3t)"
url "https://github.com/d0p3t/ggcommon"

dependency "screenshot-basic"

client_scripts {
    "discord_rp.lua",
    "ped_opts.lua",
    "scenarios.lua",
    "cl_gui.lua",
    "cl_scoreboard.lua",
    "cl_utils.lua"
}

server_scripts {
    "sv_*.lua"
}

server_export "Log"
server_export "Screenshot"
server_export "SentryIssue"
