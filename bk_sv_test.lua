function table.length(t)
	local length = 0
	for _ in pairs(t) do length = length + 1 end
	return length
end

function table.foreach(t, func)
    for k, v in pairs(t) do
        func(v, k)
    end
end

function table.filter(t, func)
    local result = {}

    table.foreach(
        t,
        function(v, k)
            if func(v, k) then
                result[k] = v
            end
        end
    )

    return result
end

local validTypes = {
    ["triple"] = 3,
    ["mega"] = 4,
    ["spree"] = 5,
    ["monster"] = 6,
    ["ludicrous"] = 7,
    ["holy"] = 10
}

local validAudio =
    table.filter(
    validTypes,
    function(amount)
        return amount == 11
    end
)

if table.length(validAudio) == 0 then print('hooo') else
    table.foreach(validAudio, function(v,k) print('hii') print(v,k) end)
    print('hee')
 end

math.randomseed(os.time())

local function chooseRandom(tbl)
    
    -- Insert the keys of the table into an array
    local keys = {}

    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end

    -- Get the amount of possible values
    local max = #keys
    local number = math.random(1, max)
    local selectedKey = keys[number]

    -- Return the value
    return selectedKey, tbl[selectedKey]
end

--local key, value = chooseRandom(validAudio)
--print(key, value)
