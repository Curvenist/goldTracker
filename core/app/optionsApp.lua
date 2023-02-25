OptCMM = {
	incomeNature = 1,
	statsMethod = 1,
	comparison = 1
}

function OptCMM:set(property, value)
	self[property] = value
end

function OptCMM:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end

OptMoney = {

}

function OptMoney:set(property, value)
	self[property] = value
end

function OptMoney:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end

OptTracker = {

}

function OptTracker:set(property, value)
	self[property] = value
end

function OptTracker:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end

OptStats = {
	mult = 100
}

function OptStats:set(property, value)
	self[property] = value
end

function OptStats:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end


