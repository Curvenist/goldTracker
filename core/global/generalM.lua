GeneralM = {
    test = nil,
	allowedOperators = {"+", "-", "*", "/", "%", "^"},
	dateItems = {},
	commands = {
		"%%drawLine", -- draw a line
		"%%rating", 
		"%%label", -- is only a label
		"%%outfn",
		"%%fn:" -- calling a function
	}
}

function GeneralM:tableContains(tab, val)
    for k, v in pairs(tab) do
        if v == val then 
            return true
        end
    end
    return false
end

function GeneralM:case(tester, callback)
	if tester then
		callback()
		return true
	end
	return false
end

function GeneralM:isNotCommand(value)
	for k, v in pairs(self.commands) do
		if string.find(value, v) ~= nil then return false end
	end
	return true
end

function GeneralM:isCommand(value)
	for k, v in pairs(self.commands) do
		if string.find(value, v) ~= nil then return true end
	end
	return false
end

-- a command must look like this : %fn:module:function
-- so in the end we have module:function(args) => args can look like ({1, 2}, 3)
function GeneralM:executeCommand(mod, command, args)
	return loadstring("return " .. mod..":"..command .. "(".. args ..")")()
end

function GeneralM:analyseCommand(value)
	local i, array = 1, {}
	if string.find(value, "^%%fn") then
		for w in string.gmatch(value, "[%w]+") do
		array[i] = w
		i = i + 1
		end
	return {array[2], array[3]}
	end
	return false
end

function GeneralM:analyseOutCommand(value)
	local i, array = 1, {}
	if string.find(value, "^%%outfn") then
		for w in string.gmatch(value, "[%w]+") do
		array[i] = w
		i = i + 1
		end
	return {array[2], array[3]}
	end
	return false
end

function GeneralM:stringifyArg(arg)
	if type(arg) == "table" then --care here, requires just ONE level of table!
		return "{" .. table.concat(arg, ", ") .. "}"
	end
	if type(arg) == "number" then
		return tostring(arg)
	end
	return tostring(arg)
end