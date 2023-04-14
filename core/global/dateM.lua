DateM = {
	dateItems = {}
}

function DateM:timeChecker(sdate)
    local p = "(%d%d)(%d%d)(%d+)"
    local d, m, y = sdate:match(p)
    return time({
        year = y, month = m, day = d
    })
end

function DateM:convertToDateType(date) -- must be a format DayMonthYear
	if type(date) == "string" then
	local pow = #date - 4
	date = {
		year = math.floor(date % 10^pow),
		month = math.floor(date / 10^pow % 100),
		day = math.floor(date / 1e6),
		hour = 0, min = 0, sec = 0
	}
	return time(date)
end
return date
end

function DateM:ConversionAllDates()
	for k, v in pairs(GTMoney) do
		local elems = GTMoney[k]
		local key = self:convertToDateType(k)
		GTMoney[k] = nil -- set to nil the entry whith a date that is not a timestamp
		GTMoney[key] = elems
	end
	for k, v in pairs(GTMoney) do
		if type(k) == "string" then
			GTMoney[k] = nil
		end
	end
end

-- date Functions : date input must be in Timestamp

function DateM:setArray(array, arrayToFill)
	array, arrayToFill = array or {}, arrayToFill or {}
	for k, v in pairs(array) do
		table.insert(arrayToFill , k)
	end
	return arrayToFill
end

function DateM:orderArray(ascend, array)
	ascend, array = ascend or true, array or self.dateItems

	if ascend then table.sort(array, function(a, b) return a > b end)
	elseif not ascend then table.sort(array, function(a, b) return a < b end) end
	return array
end

-- datePicker = array of dates we want to pick 
-- interval = an interval with a {min, max}
function DateM:datePicker(datePicker, interval, array, vals) -- prendre un interval de date
	datePicker, interval, array, vals = datePicker or {}, interval or {}, array or self.dateItems, {}
	local arrayOfDates = array
	if #datePicker ~= 0 then
		arrayOfDates = datePicker
	end
	if #interval ~= 2 then
		for k, v in pairs(datePicker) do
			for k2, v2 in pairs(array) do
				if v2 == v then table.insert(vals, v) break end
			end
		end
	else
		for k, v in pairs(arrayOfDates) do
			if v <= interval[2] and v >= interval[1] then
				table.insert(vals, v)
			end
		end
	end
	return vals
end


-- interval[1] is timestamp
-- interval[2] is the step vector
function DateM:dateTranslationPicker(interval, array, vals)
	interval, array, vals = interval or {}, array or self.dateItems, {}
	local arrayOfDates = array
	if #interval ~= 2 then
		for k, v in pairs(arrayOfDates) do
			table.insert(vals, v)
		end
	else
		for k, v in pairs(arrayOfDates) do
			if v == interval[1] then
				vals = {}
				for l = k, 	k + interval[2], interval[2]/math.abs(interval[2]) do
					if arrayOfDates[l] ~= nil then 
						table.insert(vals, arrayOfDates[l]) 
					end
				end
				break
			end
			table.insert(vals, v)
		end
	end
	return vals
end

-- days of week = array containing the days allowed {0, 1, 3, ... , 6}
-- occurences = array containing the starting day, the fetching orientation, the date to start with
-- vals = should contain nothing
function DateM:dateMathPicker(daysOfWeek, occurences, array, vals)
    daysOfWeek, occurences, array, vals = daysOfWeek or {}, occurences or {}, array or self.dateItems, {}

	local i, vIsMet, iMax, WeekCapture = 0, false, nil, date("%W", occurences[1])

	if occurences[2] ~= nil and occurences[2] == false then 
		array = DateM:orderArray(array, true)
    end
    if occurences[3] ~= nil then
        iMax = occurences[3]
    end

    for k, v in pairs(array) do
		if v == occurences[1] then vIsMet = true end
        if vIsMet then
			if WeekCapture ~= date("%W", v) then -- WeekCaputure is the indicator of our currentWeek cusor, i is the stepper, iMax is the floor or ceil
				if iMax == 0 then break end

				if occurences[2] then i = i + 1
				elseif not occurences[2] then i = i - 1 end
				WeekCapture = date("%W", v)
			end
			if iMax == nil or math.abs(i) <= math.abs(iMax) then -- Starting to add recursive
				for l, m in pairs(daysOfWeek) do
					if date("%w", v) == tostring(m) then
						table.insert(vals, v)
					end
				end
			end
        end
    end
    return vals
end

-- we will check the last TrackerDate when the player was connected
function DateM:checkLastCoDate(TrackerDate)
    local dateTimestamp = DateM:convertToDateType(TrackerDate)
    local originDiff, comparedDiff = nil, nil
    for k,v in pairs(GTMoney) do
        if originDiff == nil and k ~= TrackerDate then
            originDiff = {k, math.floor((dateTimestamp - DateM:convertToDateType(k)))} -- seconds, math gives whole day
        elseif comparedDiff == nil and k ~= TrackerDate then
            comparedDiff = {k, math.floor((dateTimestamp - DateM:convertToDateType(k)))} -- seconds, math gives whole day
        end
        if originDiff ~= nil and comparedDiff ~= nil then
            if originDiff[2] > comparedDiff[2] then
             originDiff = comparedDiff
             end
             comparedDiff = nil --always clear the compare one 
        end
    end
    if originDiff == nil then 
        return TrackerDate
     end
    return originDiff[1]
end

-- This function allows us to always bring the timestamp to the current UTC day start, useful when hour changes!
-- FTDS = force to day start
function DateM:TTC(timestamp)
	local FTDS = {
    	year =  date("%Y", timestamp),
		month =  date("%m", timestamp),
		day =  date("%d", timestamp),
		hour = 0, min = 0, sec = 0
	}
	local timediff = timestamp - (time(FTDS))
	if timediff > 0 then
		timediff = (24*60*60) - timediff
		FTDS = {
			year =  date("%Y", timestamp + timediff),
				month =  date("%m", timestamp + timediff),
				day =  date("%d", timestamp + timediff),
				hour = 0, min = 0, sec = 0
		}
	end
	return time(FTDS)
end


function DateM:CurrentWeekDays(timestamp, dayStart, nbDays, array)
	nbDays, dayStart, array = nbDays or 7, dayStart or 3, array or {}
	timestamp = timestamp or self:convertToDateType(self:timeChecker(date("%d%m%Y")))
	local currentDay = tonumber(date("%w", timestamp))
	if currentDay < dayStart then 
		currentDay = nbDays + currentDay
	end
	for i = 1, (currentDay - dayStart) do
	  array[i] = self:TTC(timestamp - (24 * 60 * 60)*i)
	end
	return array
end

--WeekSegmentation allows us isolate the previous week data
function DateM:WeekSegmentation(timestamp, dayStart, nbDays, array)
	nbDays, dayStart, array = nbDays or 7, dayStart or 3, array or {}
	timestamp = timestamp or self:convertToDateType(self:timeChecker(date("%d%m%Y")))
	local forward = 1
	if nbDays < 0 then nbDays = nbDays * -1 forward = -1 end
	local currentDay = tonumber(date("%w", timestamp))
	if currentDay < dayStart then 
		currentDay = nbDays + currentDay
	end
	if currentDay ~= dayStart then
	  timestamp = self:TTC(timestamp - (24 * 60 * 60)*(currentDay-dayStart))
	end
	for i = 1, nbDays do
	  array[i] = self:TTC(timestamp - (24 * 60 * 60)*i*forward)
	end

	return array
end

function DateM:MonthSegmentation(timestamp, dayStart, nbDays, array)
	nbDays, dayStart, array = nbDays or 7, dayStart or 3, array or {}
	timestamp = timestamp or self:convertToDateType(self:timeChecker(date("%d%m%Y")))
	
	local currentMonth = tonumber(date("%m", timestamp))
	local currentDay = tonumber(date("%w", timestamp))
	
	if currentDay < dayStart then 
		currentDay = nbDays + currentDay
	end
	if currentDay ~= dayStart then
	  timestamp = self:TTC(timestamp - (24 * 60 * 60)*(currentDay-dayStart))
	end

	local checkM, check = tonumber(date("%m", timestamp)), true
	local starting, ending = 1, 7
	currentMonth = tonumber(date("%m", self:TTC(timestamp - (24 * 60 * 60)*ending))) -- positionning ourselves in the day of the preious week
	while check == true do
		checkM = tonumber(date("%m", self:TTC(timestamp - (24 * 60 * 60)*ending)))
		
		if checkM == currentMonth then 
			for i = starting, ending do 
				array[i] = self:TTC(timestamp - (24 * 60 * 60)*i)
			end
		else
			check = false  
		end
		
		starting = ending
		ending = 7 + ending
	  end

	return array
end