--CMM : customMoneyMethods
CMM = {
	data = nil,
	timeArray = {},
	limits = {10^3, -10^3},

	storeVal = {},
	storeOperation = {},
	storeTI = {},

	statistics = {},
	options = {},
	statDevi = {},

	CurrentTI = {}, -- TrackerInstance
	HistoryTI = {}, -- TrackerInstance

	statCalcul = nil
}

function CMM:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function CMM:loadOptions(index)
	local value = nil
	return (index == "statsMethod" and (
				GeneralM:case(OptCMM:get(index) == 1, function () value = 1 end) or
				GeneralM:case(OptCMM:get(index) == 2, function () value = 2 end)) or
			index == "incomeNature" and (
				GeneralM:case(OptCMM:get(index) == 1, function () value = "netEarning" end) or
				GeneralM:case(OptCMM:get(index) == 2, function () value = "income" end) or
				GeneralM:case(OptCMM:get(index) == 3, function () value = "spending" end)))
			and value
end

function CMM:main(array)
	self.data = array
	self.CurrentTI = TrackerInstance:new()
	self.HistoryTI = TrackerInstance:new()
	self.statDevi = Stats:new()
	self.statDevi:constr()
	for k, v in pairs(OptCMM) do 
		if type(v) ~= "function" then
			self.options[k] = self:loadOptions(k)
		end
	end
	if self.options["statsMethod"] == 1 then
		self.statCalcul = function(vals1, vals2) return {self.statDevi:rating(vals1, vals2), 1} end
elseif self.options["statsMethod"] == 2 then
		self.statCalcul = function(vals1, vals2) return {self.statDevi:plainPerformance({{vals1, vals2}}), 2} end
	end

end

function CMM:actualWeekScope(TrackerDate)
	self:setTimeArray(DateM:CurrentWeekDays(TrackerDate, 3, 7))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function CMM:weekScope(TrackerDate)
	self:setTimeArray(DateM:WeekSegmentation(TrackerDate, 3, 7))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function CMM:monthScope(TrackerDate)
	self:setTimeArray(DateM:MonthSegmentation(TrackerDate, 3, 7))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function CMM:monthPrevScope(TrackerDate)
	local timestamp = TrackerDate - (24 * 60 * 60)*(7)
	self:setTimeArray(DateM:MonthSegmentation(timestamp, 3, 7))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function CMM:initTimeArrayInterval(val)
	self:setTimeArray(self:getInterval(val))
end

function CMM:popUpStaticReport()
	local panel, incomeType = MainM.panel.mainElementAdvancedStatOp, self.options["incomeNature"]
	-- first, we need to create statistics, so we need to take the incomeType, store it and sens it to the stat function to get the result
	if panel ~= nil then
		for k, v in pairs(Const.AdvancedStatOp) do
			if GeneralM:isCommand(v[1]) then
				local isFunctionPart = GeneralM:analyseOutCommand(v[1])
				if isFunctionPart then --ok, it's outfn, we can do something else like loading other datas
					local args = GeneralM:stringifyArg(TrackerDate) --we stringify our array of values to fit in the exec
					GeneralM:executeCommand(isFunctionPart[1], isFunctionPart[2], args) --our function executed by a load
					for i, j in pairs(self:getTimeArray()) do
						self.HistoryTI:constr(self.data[self:getTimeArray(i)]) self.HistoryTI:find(incomeType)
						self:setStatistics(self.HistoryTI[incomeType], i)
					end
				elseif not isFunctionPart then
				isFunctionPart = GeneralM:analyseCommand(v[1]) --here we extract the command of the constant
				if isFunctionPart then
					local args = GeneralM:stringifyArg(self:getStatistics()) --we stringify our array of values to fit in the exec
					local data = GeneralM:executeCommand(isFunctionPart[1], isFunctionPart[2], args) --our function executed by a load
					self:setStoreVal(v[2], 1) -- the label
					self:setStoreVal(Money:ConvertGold(data), 2) -- our value
					self:setstoreOperation(data)
					panel.fontStrings[v[1] .. k]:SetText(self:getStoreVal(2))
				end
				end
			end
		end
	end

end

function CMM:popUpDataCompared()
	local panelCentral, incomeType = MainM.panel.mainElementTrackerCurrent.fontStrings, self.options["incomeNature"]
	if panelCentral ~= nil then
		local result = {self.statDevi:rating(Tracker:find(incomeType), self:getstoreOperation(1)), 1}
		local translate = self:translate(result, Tracker:find(incomeType), self:getstoreOperation(1))
		local gradient = self:processGradient(translate[3], OptStats:get("mult"))

		if translate[2] >= 0 then panelCentral["%rating6"]:SetTextColor(gradient, 1, gradient, 1)
		elseif translate[2] < 0 then panelCentral["%rating6"]:SetTextColor(1, 1, 1 - gradient, 1) end
        panelCentral["%rating6"]:SetText(translate[1])

		if #self:getstoreTI() < 1 then
			self:actualWeekScope(TrackerDate)
			self:setstoreTI(self.CurrentTI[incomeType], 1)
			for i, j in pairs(self:getTimeArray()) do
				self.HistoryTI:constr(self.data[self:getTimeArray(i)]) self.HistoryTI:find(incomeType)
				self:setstoreTI(self.HistoryTI[incomeType], i)
			end
		end

		result = self.statDevi:plainPerformance(self:getstoreTI())
        panelCentral["%sum7"]:SetText(Money:ConvertGold(result))
    end
end


function CMM:processGradient(value, div)
	local gradient = value
	local div = (gradient / math.abs(gradient)) * div
	if math.abs(gradient) > math.abs(div) then 
		div = gradient
	end 
	local value = self.statDevi:rating(gradient, div)
	local ratio = value / OptStats:get("mult")
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
		end
	end
	return {val, plainPerf, mathVal}
	
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

function CMM:resetstoreOperation()
	self.storeOperation = {}
end

function CMM:setstoreOperation(value, index)
	if index == nil then
		self.storeOperation[#self.storeOperation + 1] = value
		return
	end
	self.storeOperation[index] = value
end

function CMM:getstoreOperation(index)
	if index ~= nil then
		return self.storeOperation[index]
	end
	return self.storeOperation
end

function CMM:resetstoreTI()
	self.storeTI = {}
end

function CMM:setstoreTI(value, index)
	if index == nil then
		self.storeTI[#self.storeTI + 1] = value
		return
	end
	self.storeTI[index] = value
end

function CMM:getstoreTI(index)
	if index ~= nil then
		return self.storeTI[index]
	end
	return self.storeTI
end

function CMM:getStatistics(index)
	if index ~= nil then
		return self.statistics[index]
	end
	return self.statistics
end

function CMM:setStatistics(value, index)
	self.statistics[index] = value
end

