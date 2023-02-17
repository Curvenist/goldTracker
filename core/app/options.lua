CMMOptions = {
	incomeNature = 1,
	statsMethod = 1,
	comparison = 2
}

function CMMOptions:set(property, value)
	self[property] = value
end

function CMMOptions:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end

MoneyOptions = {

}

function MoneyOptions:set(property, value)
	self[property] = value
end

function MoneyOptions:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end

TrackerOptions = {

}

function TrackerOptions:set(property, value)
	self[property] = value
end

function TrackerOptions:get(property)
	if property ~= nil then
		return self[property]
	end
	return self
end

