--GTM : GTMoneyMethods
GTM = {
	data = {},
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

function GTM:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function GTM:loadOptions(index)
	local value = nil
	return (index == "statsMethod" and (
				GeneralM:case(OptGTM:get(index) == 1, function () value = 1 end) or
				GeneralM:case(OptGTM:get(index) == 2, function () value = 2 end)) or
			index == "incomeNature" and (
				GeneralM:case(OptGTM:get(index) == 1, function () value = "netEarning" end) or
				GeneralM:case(OptGTM:get(index) == 2, function () value = "income" end) or
				GeneralM:case(OptGTM:get(index) == 3, function () value = "spending" end)))
			and value
end

function GTM:main(array)
	self.data = array
	self.CurrentTI = TrackerInstance:new()
	self.HistoryTI = TrackerInstance:new()
	self.statDevi = Stats:new()
	self.statDevi:constr()
	for k, v in pairs(OptGTM) do 
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

function GTM:actualWeekScope(TrackerDate)
	self:setTimeArray(DateM:CurrentWeekDays(TrackerDate, GTConfigs["GTstartingDay"], 7))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function GTM:weekScope(TrackerDate)
	self:setTimeArray(DateM:WeekSegmentation(TrackerDate, GTConfigs["GTstartingDay"], GTConfigs["GTmaxIterations"]))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function GTM:monthScope(TrackerDate)
	self:setTimeArray(DateM:MonthSegmentation(TrackerDate, GTConfigs["GTstartingDay"], GTConfigs["GTmaxIterations"]))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function GTM:monthPrevScope(TrackerDate)
	local timestamp = TrackerDate - (24 * 60 * 60)*(7)
	self:setTimeArray(DateM:MonthSegmentation(timestamp, GTConfigs["GTstartingDay"], GTConfigs["GTmaxIterations"]))
	DateM:datePicker(self:getTimeArray(), {}, self.data)
end

function GTM:initTimeArrayInterval(val)
	self:setTimeArray(self:getInterval(val))
end

function GTM:popUpStaticReport()
	local panel, incomeType = MainM.panel.contentAdvancedStatOp, self.options["incomeNature"]
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
					local text = GeneralM:replaceValues(v[2], {date("%d/%m", self:getTimeArray()[1]), date("%d/%m", self:getTimeArray()[#self:getTimeArray()])})
					self:setStoreVal(text, 1) -- ok, so we stored here the label with the variables, now we gonna loop into all of them
					panel.fontStrings[v[1] .. k .. "Text"]:SetText(self:getStoreVal(1))
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

function GTM:popUpDataCompared()
	local panelCentral, incomeType = MainM.panel.contentTrackerCurrent.fontStrings, self.options["incomeNature"]
	local panelReduced = MainM.minPanel.main.fontStrings
	if panelCentral ~= nil then
		local myVal = Tracker:find(incomeType)
		local result = {self.statDevi:rating(myVal, self:getstoreOperation(1)), 1}
		local translate = self:translate(result, myVal, self:getstoreOperation(1))
		local gradient = self:processGradient(translate[3], OptStats:get("mult"))
		local comparaison = self:comparaison(myVal, self:getstoreOperation(1))

		if comparaison == 1 then -- cap pos : green
			panelCentral["%rating6"]:SetTextColor(0, 1, 0, 1)
			panelReduced["%rating4"]:SetTextColor(0, 1, 0, 1)
		elseif comparaison == 2 then -- cap neg : red
			panelCentral["%rating6"]:SetTextColor(1, 0, 0, 1)
			panelReduced["%rating4"]:SetTextColor(1, 0, 0, 1)
		elseif comparaison == 3 then -- nocap pos
			panelCentral["%rating6"]:SetTextColor(1 - gradient, 1, 0, 1)
			panelReduced["%rating4"]:SetTextColor(1 - gradient, 1, 0, 1)
		elseif comparaison == 4 then -- nocap neg
			panelCentral["%rating6"]:SetTextColor(1, 1 - gradient, 0, 1)
			panelReduced["%rating4"]:SetTextColor(1, 1 - gradient, 0, 1)
		end
		
		panelCentral["%rating6"]:SetText(translate[1])
		panelReduced["%rating4"]:SetText(translate[1])
		if #self:getstoreTI() < 1 then
			self:actualWeekScope(TrackerDate)
			self:setstoreTI(myVal, 1)
			for i, j in pairs(self:getTimeArray()) do
				self.HistoryTI:constr(self.data[self:getTimeArray(i)]) self.HistoryTI:find(incomeType)
				self:setstoreTI(self.HistoryTI[incomeType], i + 1)
			end
		end
		result = self.statDevi:plainPerformance(self:getstoreTI())
        panelCentral["%sum7"]:SetText(Money:ConvertGold(result))
    end
end

function GTM:comparaison(value, compared)
if math.abs(value) >= math.abs(compared) and value >= 0 then
	return 1
elseif math.abs(value) >= math.abs(compared) and value < 0 then
	return 2
elseif math.abs(value) < math.abs(compared) and value >= 0 then
	return 3
elseif math.abs(value) < math.abs(compared) and value < 0 then
	return 4
else
	return 5
end
end


function GTM:processGradient(value, div)
	local div = (value / math.abs(value)) * div
	if math.abs(value) > math.abs(div) then -- We cap to 1
		div = value
		value = self.statDevi:rating(value, div, 1)
	end
	return value ~= 0 and math.abs(value) or 0
end

function GTM:translate(result, val1, val2, obj, val)
	local plainPerf = Money:ConvertGold(self.statDevi:plainPerformance({{val1, -val2}}))
	val = Money:orderOfComparison(result[1], {self:getLimit(1), self:getLimit(2)}, {plainPerf})
	local mathVal = self.statDevi:rating(val1, val2, 1)
	if result[2] == 1 then
		if val ~= plainPerf and val ~= 0 then
			local decoration = self.statDevi:ratingDecoration(val1, val2)
			val = Money:Truncated(result[1], 2)
			val = string.gsub(Const.GTMDecoration[decoration[2]], "%%value", val)
		end
	end
	return {val, plainPerf, mathVal}
	
end

-- if interval is negative, then we will look data in the future, if it's positive, we will look in the past BUT ONLY IF ITS ORDERED
function GTM:getInterval(interval, startDay)
	startDay = startDay or DateM:checkLastCoDate(TrackerDate)
	interval = interval or 0

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

	return DateM:dateTranslationPicker({startDay, interval}, self:getTimeArray())
end


function GTM:getIntervalDate(intervalMax, startDay)
	startDay = startDay or DateM:checkLastCoDate(TrackerDate)
	intervalMax = intervalMax or 0

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

	return DateM:datePicker({}, {startDay, intervalMax}, self:getTimeArray())
end

function GTM:getCluster(arrayOfDates)
	arrayOfDates = arrayOfDates or {}

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

	return DateM:datePicker({arrayOfDates}, self:getTimeArray())
end

function GTM:getMathematicalDates(days, occurences)
	days = days or {}
	occurences = occurences or {}

	self:setTimeArray(DateM:orderArray(true, DateM:setArray(self:getData())))

end

function GTM:getData()
	return self.data
end

function GTM:getTimeArray(index)
	if index ~= nil then
		return self.timeArray[index]
	end
	return self.timeArray
end

function GTM:setTimeArray(array)
	self.timeArray = array
end

function GTM:getLimit(index)
	if index ~= nil then
		return self.limits[index]
	end
	return self.limits
end

function GTM:setLimit(array)
	self.limits = array
end

function GTM:getMessage(index)
	if index ~= nil then
		return Const.GTMMessage[index]
	end
	return Const.GTMMessage
end


function GTM:getStoreVal(index)
	if index ~= nil then
		return self.storeVal[index]
	end
	return self.storeVal
end

function GTM:setStoreVal(value, index)
	self.storeVal[index] = value
end

function GTM:resetstoreOperation()
	self.storeOperation = {}
end

function GTM:setstoreOperation(value, index)
	if index == nil then
		self.storeOperation[#self.storeOperation + 1] = value
		return
	end
	self.storeOperation[index] = value
end

function GTM:getstoreOperation(index)
	if index ~= nil then
		return self.storeOperation[index]
	end
	return self.storeOperation
end

function GTM:resetstoreTI()
	self.storeTI = {}
end

function GTM:setstoreTI(value, index)
	if index == nil then
		self.storeTI[#self.storeTI + 1] = value
		return
	end
	self.storeTI[index] = value
end

function GTM:getstoreTI(index)
	if index ~= nil then
		return self.storeTI[index]
	end
	return self.storeTI
end

function GTM:getStatistics(index)
	if index ~= nil then
		return self.statistics[index]
	end
	return self.statistics
end

function GTM:setStatistics(value, index)
	self.statistics[index] = value
end

