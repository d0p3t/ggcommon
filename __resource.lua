resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

description "Static Gun Game features"
author "Remco Troost (d0p3t)"

dependency 'screenshot-basic'

client_scripts {
    "discord_rp.lua",
    "ped_opts.lua",
    "scenarios.lua"
}

server_scripts {
    "sv_ss.lua",
    "sv_tests.lua",
    "sv_utils.lua"
}

server_export "Log"
