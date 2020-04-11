Streaming = {}

local function is_valid_hash(value, hash, funcName)
	if hash ~= 0 then return true end
	print('Unable to '..funcName..': '..tostring(value))
	return false
end

local function is_valid_string(value, funcName)
	if type(value) == 'string' and value ~= '' then return true end
	print('Unable to '..funcName..': '..tostring(value))
	return false
end

function Streaming.RequestStreamedTextureDict(textureDict)
	if not is_valid_string(textureDict, 'RequestStreamedTextureDict') then return end

	if not HasStreamedTextureDictLoaded(textureDict) then
		RequestStreamedTextureDict(textureDict)
		while not HasStreamedTextureDictLoaded(textureDict) do Citizen.Wait(0) end
	end
end

Gui = { }


function Gui.GetPlayerName(serverId, color, lowercase)
	if Player.ServerId() == serverId then
		if lowercase then
			return 'you'
		else
			return 'You'
		end
	else
		if not color then
			if Player.IsCrewMember(serverId) then color = '~b~'
			elseif serverId == World.ChallengingPlayer or serverId == World.BeastPlayer or serverId == World.HotPropertyPlayer or MissionManager.IsPlayerOnMission(serverId) then color = '~r~'
			else color = '~w~' end
		end

		return color..'<C>'..GetPlayerName(GetPlayerFromServerId(serverId))..'</C>~w~'
	end
end


function Gui.OpenMenu(id)
	if not WarMenu.IsAnyMenuOpened() and Player.IsActive() then WarMenu.OpenMenu(id) end
end


function Gui.AddText(text)
	local str = tostring(text)
	local strLen = string.len(str)
	local maxStrLength = 99

	for i = 1, strLen, maxStrLength + 1 do
		if i > strLen then
			return
		end

		AddTextComponentString(string.sub(str, i, i + maxStrLength))
	end
end


function Gui.DisplayHelpText(text)
	BeginTextCommandDisplayHelp('STRING')
	Gui.AddText(text)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end


function Gui.DisplayNotification(text, pic, title, subtitle, icon)
	BeginTextCommandThefeedPost('STRING')
	Gui.AddText(text)

	if pic then
		EndTextCommandThefeedPostMessagetext(pic, pic, false, icon or 4, title or '', subtitle or '')
	else
		EndTextCommandThefeedPostTicker(true, true)
	end
end


function Gui.DisplayPersonalNotification(text, pic, title, subtitle, icon)
	BeginTextCommandThefeedPost('STRING')
	Gui.AddText(text)
	ThefeedNextPostBackgroundColor(200)

	if pic then
		EndTextCommandThefeedPostMessagetext(pic, pic, false, icon or 4, title or '', subtitle or '')
	else
		EndTextCommandThefeedPostTicker(true, true)
	end
end


function Gui.DrawRect(position, width, height, color)
	DrawRect(position.x, position.y, width, height, color.r, color.g, color.b, color.a or 255)
end


function Gui.SetTextParams(font, color, scale, shadow, outline, center)
	SetTextFont(font)
	SetTextColour(color.r, color.g, color.b, color.a or 255)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow()
	end

	if outline then
		SetTextOutline()
	end

	if center then
		SetTextCentre(true)
	end
end


function Gui.DrawText(text, position, width)
	BeginTextCommandDisplayText('STRING')
	Gui.AddText(text)

	if width then
		SetTextRightJustify(true)
		SetTextWrap(position.x - width, position.x)
	end

	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DrawTextEntry(entry, position, ...)
	BeginTextCommandDisplayText(entry)

	local params = { ... }
	table.iforeach(params, function(param)
		local paramType = type(param)
		if paramType == 'string' then
			AddTextComponentString(param)
		elseif paramType == 'number' then
			if math.is_integer(param) then
				AddTextComponentInteger(param)
			else
				AddTextComponentFloat(param, 2)
			end
		end
	end)

	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DrawNumeric(number, position)
	Gui.DrawTextEntry('NUMBER', position, number)
end


function Gui.DisplayObjectiveText(text)
	BeginTextCommandPrint('STRING')
	Gui.AddText(text)
	EndTextCommandPrint(1, true)
end


function Gui.DrawPlaceMarker(x, y, z, radius, r, g, b, a)
	DrawMarker(1, x, y, z, 0, 0, 0, 0, 0, 0, radius, radius, radius, r, g, b, a, false, nil, nil, false)
end


function Gui.StartEvent(name, message)
	PlaySoundFrontend(-1, 'MP_5_SECOND_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', name..' has started', message)
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	end)

	FlashMinimapDisplay()
end


function Gui.StartChallenge(name)
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', name, '')
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	end)
end


function Gui.StartMission(name, message)
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', name, message or '')
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()

		Gui.DisplayHelpText('Other players have been alerted to your activity. They can come after you to earn reward.')
	end)

	FlashMinimapDisplay()
end


function Gui.FinishMission(name, success, reason)
	if success then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	elseif Player.IsActive() then PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

	if not reason then return end

	local status = success and 'COMPLETED' or 'FAILED'
	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', string.upper(name)..' '..status, reason)
	scaleform:RenderFullscreenTimed(7000)
	scaleform:Delete()
end

Color = { }
Color.__index = Color


Color.BLIP_WHITE = 0
Color.BLIP_RED = 1
Color.BLIP_GREEN = 2
Color.BLIP_BLUE = 3
Color.BLIP_YELLOW = 5
Color.BLIP_ORANGE = 17
Color.BLIP_PURPLE = 19
Color.BLIP_GREY = 20
Color.BLIP_BROWN = 21
Color.BLIP_PINK = 23
Color.BLIP_LIGHT_BLUE = 26
Color.BLIP_DARK_BLUE = 38


local blipColors = {
	{ r = 254, g = 254, b = 254, a = 255 },
	{ r = 224, g = 50, b = 50, a = 255 },
	{ r = 114, g = 204, b = 114, a = 255 },
	{ r = 93, g = 182, b = 229, a = 255 },
	{ r = 240, g = 240, b = 240, a = 255 },
	{ r = 240, g = 200, b = 80, a = 255 },
	{ r = 194, g = 80, b = 80, a = 255 },
	{ r = 156, g = 110, b = 175, a = 255 },
	{ r = 255, g = 123, b = 196, a = 255 },
	{ r = 247, g = 159, b = 123, a = 255 },
	{ r = 178, g = 144, b = 132, a = 255 },
	{ r = 141, g = 206, b = 167, a = 255 },
	{ r = 113, g = 169, b = 175, a = 255 },
	{ r = 211, g = 209, b = 231, a = 255 },
	{ r = 144, g = 127, b = 153, a = 255 },
	{ r = 106, g = 196, b = 191, a = 255 },
	{ r = 214, g = 196, b = 153, a = 255 },
	{ r = 234, g = 142, b = 80, a = 255 },
	{ r = 152, g = 203, b = 234, a = 255 },
	{ r = 178, g = 98, b = 135, a = 255 },
	{ r = 144, g = 142, b = 122, a = 255 },
	{ r = 166, g = 117, b = 94, a = 255 },
	{ r = 175, g = 168, b = 168, a = 255 },
	{ r = 232, g = 142, b = 155, a = 255 },
	{ r = 187, g = 214, b = 91, a = 255 },
	{ r = 12, g = 123, b = 86, a = 255 },
	{ r = 123, g = 196, b = 255, a = 255 },
	{ r = 171, g = 60, b = 230, a = 255 },
	{ r = 206, g = 169, b = 13, a = 255 },
	{ r = 71, g = 99, b = 173, a = 255 },
	{ r = 42, g = 166, b = 185, a = 255 },
	{ r = 186, g = 157, b = 125, a = 255 },
	{ r = 201, g = 225, b = 255, a = 255 },
	{ r = 240, g = 240, b = 150, a = 255 },
	[39] = { r = 44, g = 109, b = 184, a = 255}, -- Lazy bitch
}


function Color.GetHudFromBlipColor(blipColor)
	return blipColors[blipColor + 1]
end

SafeZone = { }
SafeZone.__index = SafeZone

SafeZone.Size = function() return GetSafeZoneSize() end

SafeZone.Left = function() return (1.0 - SafeZone.Size()) * 0.5 end
SafeZone.Right = function() return 1.0 - SafeZone.Left() end

SafeZone.Top = SafeZone.Left
SafeZone.Bottom = SafeZone.Right

function math.average(t)
	local sum = 0

	table.foreach(t, function(v) sum = sum + v end)

	return sum / table.length(t)
end


function math.is_integer(value)
	return type(value) == 'number' and not string.find(value, '%.')
end