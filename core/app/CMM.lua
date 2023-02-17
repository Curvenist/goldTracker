--CMM : customMoneyMethods
CMM = {
	data = nil,
	timeArray = {},
	limits = {10^4, -10^4},
	storeVal = {},
	options = {},
	statDevi = {},
	TI1 = {},
	TI2 = {}
}

function CMM:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function CMM:main(val, array)
	self.data = array
	self.statDevi = Stats:new():constr()
	self.TI1 = TrackerInstance:new()
	self.TI2 = TrackerInstance:new()
	for k, v in pairs(CMMOptions) do if typeof(v) == "function" then break end
		self.options[k] = self:loadOptions(k)
	end
	self:setTimeArray(DateM:setArray(self.data, self.timeArray))
	self:setTimeArray(self:getInterval(val))
	
end

function CMM:loadOptions(index, vals)

	return 
		index == "compared" and (
			GeneralM:case(CMMOptions.get(index) == 1, function () return Tracker end) or
			GeneralM:case(CMMOptions.get(index) == 2, function () return self.data end)) or
		(index == "statsMethod" and vals ~= nil) and (
			GeneralM:case(CMMOptions.get(index) == 1, function () return self.statDevi:rating(vals{1}, vals{2}) end) or
			GeneralM:case(CMMOptions.get(index) == 2, function () return self.statDevi:perfomance(vals{1}, vals{2}) end)) or
		index == "incomeNature" and (
			GeneralM:case(CMMOptions.get(index) == 1, function () return "netEarning" end) or
			GeneralM:case(CMMOptions.get(index) == 2, function () return "income" end) or
			GeneralM:case(CMMOptions.get(index) == 3, function () return "spending" end))

end

function CMM:popUpData(array)
	local instance = self.options["compared"]
	if MainM.panel.side ~= nil then
		for key, value in pairs(MainM.panel.side) do
			if self:getTimeArray(key) ~= nil then
				local d = self:getTimeArray(key)
				self.TI1:constr(instance) self.TI2:constr(self.data[d]) 
				self.TI1:findNetEarning() self.TI2:findNetEarning()

				local statComp = self:translate(instance.netEarning, self.TI2.netEarning, self.statDevi)

				self:setStoreVal(date("%a %d/%m", d), 1)
				self:setStoreVal(Money:ConvertGold(self.TI2.netEarning), 2)
				
				self:setStoreVal(statComp[1], 3)

				for k, v in pairs(Const.TrackerPast) do v = v[1]
					MainM.panel.side[key].fontStrings[v]:SetText(self:getStoreVal(k))
				end

				if (statComp[2] == 1 and self:getStoreVal(3) < 0) or statComp[2] == 2 then 
					MainM.panel.side[key].fontStrings["rating"]:SetTextColor(255, 0, 0, 0.5)
			elseif (statComp[2] == 1 and self:getStoreVal(3) > 0) or statComp[2] == 3 then
					MainM.panel.side[key].fontStrings["rating"]:SetTextColor(0, 255, 0, 0.5)
				end
				
			end
		end
	end
end

function CMM:translate(val1, val2, obj, val)
	local rating = obj:rating({val1}, {val2})
	val = Money:orderOfComparison(rating[1], {self:getLimit(1), self:getLimit(2)}, {self:getMessage(1), self:getMessage(2)})
	if val ~= self:getMessage(1) and val ~= self:getMessage(2) and val ~= 0 then
		val = Money:Truncated(rating[1], 2)
		val = string.gsub(Const.CMMDecoration[rating[2]], "%%value", val)
	elseif val == 0 then
		val = Money:ConvertGold(obj:performance({val1, val2 * -1})[1])
	end
	return {val, rating[2]}
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

function CMM:getTimeArray(index)
	if index ~= nil then
		return self.timeArray[index]
	end
	return self.timeArray
end

function CMM:setTimeArray(array)
	self.timeArray = array
end

function CMM:getLimit(index)
	if index ~= nil then
		return self.limits[index]
	end
	return self.limits
end

function CMM:setLimit(array)
	self.limits = array
end

function CMM:getMessage(index)
	if index ~= nil then
		return Const.CMMMessage[index]
	end
	return Const.CMMMessage
end


function CMM:getStoreVal(index)
	if index ~= nil then
		return self.storeVal[index]
	end
	return self.storeVal
end

function CMM:setStoreVal(value, index)
	self.storeVal[index] = value
end