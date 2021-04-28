Streaming = {}

local function is_valid_hash(value, hash, funcName)
	if hash ~= 0 then
		return true
	end
	print("Unable to " .. funcName .. ": " .. tostring(value))
	return false
end

local function is_valid_string(value, funcName)
	if type(value) == "string" and value ~= "" then
		return true
	end
	print("Unable to " .. funcName .. ": " .. tostring(value))
	return false
end

local has_streamed_texture_dict_loaded = HasStreamedTextureDictLoaded
local request_streamed_texture_dict = RequestStreamedTextureDict
local get_player_name = GetPlayerName 
local get_player_from_server_id = GetPlayerFromServerId
local add_text_component_string = AddTextComponentString
local add_text_component_integer = AddTextComponentInteger
local add_text_component_float = AddTextComponentFloat
local begin_text_command_display_help = BeginTextCommandDisplayHelp
local end_text_command_display_help = EndTextCommandDisplayHelp
local begin_text_command_display_text = BeginTextCommandDisplayText
local end_text_command_display_text = EndTextCommandDisplayText
local set_text_right_justify = SetTextRightJustify
local set_text_wrap = SetTextWrap
local get_safe_zone_size = GetSafeZoneSize

function Streaming.RequestStreamedTextureDict(textureDict)
	if not is_valid_string(textureDict, "RequestStreamedTextureDict") then
		return
	end

	if not has_streamed_texture_dict_loaded(textureDict) then
		request_streamed_texture_dict(textureDict)
		while not has_streamed_texture_dict_loaded(textureDict) do
			Wait(0)
		end
	end
end

Gui = {}

function Gui.AddText(text)
	local str = tostring(text)
	local strLen = string.len(str)
	local maxStrLength = 99

	for i = 1, strLen, maxStrLength + 1 do
		if i > strLen then
			return
		end

		add_text_component_string(string.sub(str, i, i + maxStrLength))
	end
end

function Gui.DisplayHelpText(text)
	begin_text_command_display_help("STRING")
	Gui.AddText(text)
	end_text_command_display_help(0, 0, 1, -1)
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
	begin_text_command_display_text("STRING")
	Gui.AddText(text)

	if width then
		set_text_right_justify(true)
		set_text_wrap(position.x - width, position.x)
	end

	end_text_command_display_text(position.x, position.y)
end

function Gui.DrawTextEntry(entry, position, ...)
	begin_text_command_display_text(entry)

	local params = {...}
	table.iforeach(
		params,
		function(param)
			local paramType = type(param)
			if paramType == "string" then
				add_text_component_string(param)
			elseif paramType == "number" then
				if math.is_integer(param) then
					add_text_component_integer(param)
				else
					add_text_component_float(param, 2)
				end
			end
		end
	)

	end_text_command_display_text(position.x, position.y)
end

function Gui.DrawNumeric(number, position)
	Gui.DrawTextEntry("NUMBER", position, number)
end


Color = {}
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
Color.BLIP_DARK_BLUE = 34
Color.BLIP_BEIGE = 35

local blipColors = {
	{r = 254, g = 254, b = 254, a = 255},
	{r = 224, g = 50, b = 50, a = 255},
	{r = 114, g = 204, b = 114, a = 255},
	{r = 93, g = 182, b = 229, a = 255},
	{r = 240, g = 240, b = 240, a = 255},
	{r = 240, g = 200, b = 80, a = 255},
	{r = 194, g = 80, b = 80, a = 255},
	{r = 156, g = 110, b = 175, a = 255},
	{r = 255, g = 123, b = 196, a = 255},
	{r = 247, g = 159, b = 123, a = 255},
	{r = 178, g = 144, b = 132, a = 255},
	{r = 141, g = 206, b = 167, a = 255},
	{r = 113, g = 169, b = 175, a = 255},
	{r = 211, g = 209, b = 231, a = 255},
	{r = 144, g = 127, b = 153, a = 255},
	{r = 106, g = 196, b = 191, a = 255},
	{r = 214, g = 196, b = 153, a = 255},
	{r = 234, g = 142, b = 80, a = 255},
	{r = 152, g = 203, b = 234, a = 255},
	{r = 100, g = 65, b = 164, a = 255},
	{r = 144, g = 142, b = 122, a = 255},
	{r = 166, g = 117, b = 94, a = 255},
	{r = 175, g = 168, b = 168, a = 255},
	{r = 232, g = 142, b = 155, a = 255},
	{r = 187, g = 214, b = 91, a = 255},
	{r = 12, g = 123, b = 86, a = 255},
	{r = 123, g = 196, b = 255, a = 255},
	{r = 171, g = 60, b = 230, a = 255},
	{r = 206, g = 169, b = 13, a = 255},
	{r = 71, g = 99, b = 173, a = 255},
	{r = 42, g = 166, b = 185, a = 255},
	{r = 186, g = 157, b = 125, a = 255},
	{r = 201, g = 225, b = 255, a = 255},
	{r = 240, g = 240, b = 150, a = 255},
	{r = 44, g = 109, b = 184, a = 255},
	{r = 147, g = 148, b = 118, a = 255},
	[36] = {r = 147, g = 148, b = 118, a = 255}
}

function Color.GetHudFromBlipColor(blipColor)
	return blipColors[blipColor + 1]
end

SafeZone = {}
SafeZone.__index = SafeZone

SafeZone.Size = function()
	return get_safe_zone_size()
end

SafeZone.Left = function()
	return (1.0 - SafeZone.Size()) * 0.5
end
SafeZone.Right = function()
	return 1.0 - SafeZone.Left()
end

SafeZone.Top = SafeZone.Left
SafeZone.Bottom = SafeZone.Right

function math.average(t)
	local sum = 0

	table.foreach(
		t,
		function(v)
			sum = sum + v
		end
	)

	return sum / table.length(t)
end

function math.is_integer(value)
	return type(value) == "number" and not string.find(value, "%.")
end
