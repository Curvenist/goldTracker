GeneralM = {
    test = nil,
	allowedOperators = {"+", "-", "*", "/", "%", "^"},
	dateItems = {}
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


--[[
	local i = 1
	
	for k = 1, 1 do
		if case(i == 1, 
			function () i = 2; print(i) end)
		then break end
		if case(i >= 2, 
			function () i = 3; print(i) end)
		then end
		if case(i == 3,
			function () print("test") end)
		then break end
		if case("default", 
			function () print("default type") end)
		then break end
	end
	
	print("fin")
]]--
		