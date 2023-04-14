GeneralM = {
    test = nil,
	allowedOperators = {"+", "-", "*", "/", "%", "^"},
	dateItems = {},
	commands = {
		"%%",
		"%%drawLine", -- draw a line
		"%%br",
		"%%rating", 
		"%%label", -- is only a label
		"%%outfn",
		"%%fn:" -- calling a function
	},

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

--outCommands are generally used to help doing commands outside of a single processor analyseCommand, meaning you want to load some data before working on it in analyseCommand
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


--so here we go, this is the big boy function replacing values inside a text, lets go!
function GeneralM:replaceValues(text, value)
	local findReg = 
	function (text)
		local i, array = 1, {}
		if string.find(text, "%%value") then
			for w in string.gmatch(text, "%%value%d*") do
			array[i] = w
			i = i + 1
			end
		return array
		end
		return {}
	end
	local replaceReg = 
	function (text, value, i)
		return string.gsub(text, "%%value%d*", value, i)
	end

	for k, v in pairs(findReg(text)) do
		if value[k] ~= nil then
		text = replaceReg(text, value[k], 1)
		end
	end
	return text
end

--/run function t(a,b,c)  if a >= b then c = -c end return c end local r,m = GetCVar("RenderScale"),".1" if SecureCmdOptionParse"[mod:ctrl]" then m = t(r, "1", m) else m = t(r, "2", m) end; SetCVar("RenderScale", r + m); print(.. r + m );