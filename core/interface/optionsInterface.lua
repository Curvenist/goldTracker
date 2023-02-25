OptInt = {
    maxIterations = 7,
    switch = {
        days = true,
        week = false,
        month = false
    },
    switchAdvanced = {
        average = true,
        deviation = false
    },
    font = "Fonts\\ARIALN.TTF",
}

function OptInt:set(property, value)
	self[property] = value
end

function OptInt:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end