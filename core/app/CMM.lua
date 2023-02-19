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
	self.statDevi = Stats:new()
	self.statDevi:constr()
	self.TI1 = TrackerInstance:new()
	self.TI2 = TrackerInstance:new()
	for k, v in pairs(CMMOptions) do 
		if type(v) ~= "function" then
			self.options[k] = self:loadOptions(k)
		end
	end
	
	self:setTimeArray(DateM:setArray(self.data, self.timeArray))
	self:setTimeArray(self:getInterval(val))
	
end

function CMM:loadOptions(index)
	local value = nil
	return (index == "statsMethod" and (
				GeneralM:case(CMMOptions:get(index) == 1, function () value = 1 end) or
				GeneralM:case(CMMOptions:get(index) == 2, function () value = 2 end)) or
			index == "incomeNature" and (
				GeneralM:case(CMMOptions:get(index) == 1, function () value = "netEarning" end) or
				GeneralM:case(CMMOptions:get(index) == 2, function () value = "income" end) or
				GeneralM:case(CMMOptions:get(index) == 3, function () value = "spending" end)))
			and value
end

function CMM:popUpData(array)
	local instance = Tracker
	local statCalcul = nil
	if self.options["statsMethod"] == 1 then
		statCalcul = function(vals1, vals2) return {self.statDevi:rating(vals1, vals2), 1} end
elseif self.options["statsMethod"] == 2 then
		statCalcul = function(vals1, vals2) return {self.statDevi:plainPerformance({{vals1, vals2}}), 2} end
	end

	if MainM.panel.side ~= nil then
		for key, value in pairs(MainM.panel.side) do
			if self:getTimeArray(key) ~= nil then
				local d, dd = self:getTimeArray(key), nil
				if key < #MainM.panel.side and CMMOptions:get("comparison") == 2 then 
					dd = self:getTimeArray(key + 1)
					instance = self.data[dd]
				elseif CMMOptions:get("comparison") == 2 then
					instance = self.data[d]
				end
				self.TI1:constr(instance) self.TI1:findNetEarning()
				self.TI2:constr(self.data[d]) self.TI2:findNetEarning()
				 

				-- here we make the calcul
				local result = statCalcul(self.TI1.netEarning, self.TI2.netEarning)
				local translate = self:translate(result, self.TI1.netEarning, self.TI2.netEarning)
				
				self:setStoreVal(date("%a %d/%m", d), 1)
				self:setStoreVal(Money:ConvertGold(self.TI2.netEarning), 2)
				self:setStoreVal(translate[1], 3)

				local gradient = self:processGradient(translate[2], StatsOptions:get("mult"))
				local paneltext = MainM.panel.side[key].fontStrings[Const.TrackerPast[3][1]]

				if translate[2] >= 0 then 
					paneltext:SetTextColor(gradient, 1, gradient, 1)
				elseif translate[2] < 0 then
					paneltext:SetTextColor(1, gradient,  gradient, 1)
				end
				
				for k, v in pairs(Const.TrackerPast) do v = v[1]
					MainM.panel.side[key].fontStrings[v]:SetText(self:getStoreVal(k))
				end
				
			end
		end
	end
end

function CMM:processGradient(value, div)
	local gradient = value
	local div = (gradient / math.abs(gradient)) * div
	if math.abs(gradient) > math.abs(div) then 
		div = gradient
	end 
	local value = self.statDevi:rating(gradient, div)
	local ratio = value / StatsOptions:get("mult")
	return value ~= 0 and (1 - ratio) or 0
end

function CMM:translate(result, val1, val2, obj, val)
	local plainPerf = Money:ConvertGold(self.statDevi:plainPerformance({{val1, -val2}}))
	val = Money:orderOfComparison(result[1], {self:getLimit(1), self:getLimit(2)}, {plainPerf})
	local mathVal = self.statDevi:rating(val1, val2)
	if result[2] == 1 then
		if val ~= plainPerf and val ~= 0 then
			local decoration = self.statDevi:ratingDecoration(val1, val2)
			val = Money:Truncated(result[1], 2)
			val = string.gsub(Const.CMMDecoration[decoration[2]], "%%value", val)
		elseif val == 0 then
			val = Money:ConvertGold(self.statDevi:plainPerformance({{val1, -val2}}))
		end
		
	end
	return {val, mathVal}
	
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


