GeneralM = {
    test = nil,
	allowedOperators = {"+", "-", "*", "/", "%", "^"},
	dateItems = {},
	commands = {
		"%%drawLine",
		"%%hardSpace"
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
		if self:case(string.find(value, v) ~= nil, function () end) then return false end
	end
	return true
end