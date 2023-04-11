OptInt = {
    GTmaxIterations = 7,
    GTstartingDay = 3,
    GTmaxIterationsLimit = 30,
    GTupdateShow = true,
    GTupdateTimer = 5,
    GTupdateShowType = 1, -- 0 is normal window, 1 is reduced data
    GTsquashData = true,
    GTsquashDataType = 1,
    GTsquashDataTrigger = 30, -- days
    GTremoveOldData = 120, --days
    GTtriggeronce = false,

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