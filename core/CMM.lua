--CMM : customMoneyMethods
CMM = {
	data = nil,
	timeArray = {},
	limits ={10^3, -10^3},
	message = {"Perf Sup!", "Perf Inf!"}
}

function CMM:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function CMM:main(val, array)
	self.data = array
	self:setTimeArray(DateM:setArray(self.data, self.timeArray))
	self:setTimeArray(self:getInterval(val))
end

function CMM:popUpData(array)
	local calc = Stats:new()
	calc:constr()
	if MainM.panel.side.fontStrings ~= nil then
		for k, v in pairs(Const.TrackerPast) do v = v[1]
			-- instead of putting a single line text, we will add our linebreak in order to create only one node of next!
			local line = ""
			local rating = 0
			for ki, vi in pairs(array) do
				self.data[vi].netEarning = self.data[vi].income + self.data[vi].netValueD + self.data[vi].netValue - self.data[vi].spending
				rating = self:translate(Tracker.netEarning, self.data[vi].netEarning, calc)
				line = line .. date("%a - %d/%m/%y", vi) .. " : " .. Money:ConvertGold(self.data[vi].netEarning) .. " : " .. rating .."\n"
			end
			MainM.panel.side.fontStrings[v]:SetText(line)
		end
	end
end

function CMM:translate(val1, val2, obj, val)
	val = Money:Truncated(obj:rating({val1}, {val2}), 2)
	val = Money:dataInterpretation(val, {self:getLimit(1), self:getLimit(2)}, {self:getMessage(1), self:getMessage(2)})
	if val == 0 then 
		val = Money:ConvertGold(obj:performance({val1, val2 * -1})[1])
	end
	return val
end

-- if interval is negative, then we will look data in the future, if it's positive, we will look in the past BUT ONLY IF ITS ORDERED
function CMM:getInterval(interval, startDay)
	startDay = startDay or DateM:checkLastCoDate(TrackerDate)
	interval = interval or 0

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

	return DateM:dateTranslationPicker({startDay, interval}, self:getTimeArray())
end

function CMM:getIntervalDate(intervalMax, startDay)
	startDay = startDay or DateM:checkLastCoDate(TrackerDate)
	intervalMax = intervalMax or 0

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

	return DateM:datePicker({}, {startDay, intervalMax}, self:getTimeArray())
end

function CMM:getCluster(arrayOfDates)
	arrayOfDates = arrayOfDates or {}

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

	return DateM:datePicker({arrayOfDates}, self:getTimeArray())
end

function CMM:getMathematicalDates(days, occurences)
	days = days or {}
	occurences = occurences or {}

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

end

function CMM:getData()
	return self.data
end

function CMM:getTimeArray()
	return self.timeArray
end

function CMM:setTimeArray(array)
	self.timeArray = array
end

function CMM:getLimit(value)
	if value ~= nil then
		return self.limits[value]
	end
	return self.limits
end

function CMM:setLimit(array)
	self.limits = array
end

function CMM:getMessage(value)
	if value ~= nil then
		return self.message[value]
	end
	return self.message
end

function CMM:setMessage(array)
	self.limits = array
end