Citizen.CreateThread(
  function()
    while not NetworkIsPlayerActive(PlayerId()) do
      Wait(0)
    end

    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do
      Wait(0)
    end

    local minimap = RequestScaleformMovie("minimap")
    while not HasScaleformMovieLoaded(minimap) do
      Wait(0)
    end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
    SetMinimapClipType(1)
    SetMinimapComponentPosition("minimap", "L", "B", -0.0045, -0.022, 0.210, 0.258888)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0, 0.032, 0.101, 0.259)
    SetMinimapComponentPosition("minimap_blur", "L", "B", 0.012, 0.022, 0.256, 0.337)

    SetRadarBigmapEnabled(true, false)
    Wait(500)
    --SetRadarBigmapEnabled(false, false)

    while true do
      Wait(0)
      SetRadarBigmapEnabled(false, false)
      BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
      ScaleformMovieMethodAddParamInt(3)
      EndScaleformMovieMethod()
    end
  end
)
