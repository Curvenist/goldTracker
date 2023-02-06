DateM = {
	dateItems = {}
}

function DateM:timeChecker(sdate)
    local p = "(%d%d)(%d%d)(%d+)"
    local d, m, y = sdate:match(p)
    return time({
        year = y,
        month = m,
        day = d
    })
end

function DateM:convertToDateType(date) -- must be a format DayMonthYear
	if type(date) == "string" then
	local pow = #date - 4
	date = {
		year = math.floor(date % 10^pow),
		month = math.floor(date / 10^pow % 100),
		day = math.floor(date / 1e6),
		hour = 0,
		min = 0,
		sec = 0
	}
	return time(date)
end
return date
end


function DateM:ConversionAllDates()
	for k, v in pairs(customMoney) do
		local elems = customMoney[k]
		local key = self:convertToDateType(k)
		customMoney[k] = nil -- set to nil the entry whith a date that is not a timestamp
		customMoney[key] = elems
	end
	for k, v in pairs(customMoney) do
		if type(k) == "string" then
			customMoney[k] = nil
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
	for k, v in pairs(arrayOfDates) do
		if #interval == 2 then
		if v <= interval[2] and v >= interval[1] then
			table.insert(vals, v)
		end
		else
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

	local i, vIsMet, iMax, WeekCapture = 0, false, nil, os.date("%W", occurences[1])

	if occurences[2] ~= nil and occurences[2] == false then 
		array = DateM:orderArray(array, true)
    end
    if occurences[3] ~= nil then
        iMax = occurences[3]
    end

    for k, v in pairs(array) do
		if v == occurences[1] then vIsMet = true end
        if vIsMet then
			if WeekCapture ~= os.date("%W", v) then -- WeekCaputure is the indicator of our currentWeek cusor, i is the stepper, iMax is the floor or ceil
				if iMax == 0 then break end

				if occurences[2] then i = i + 1
				elseif not occurences[2] then i = i - 1 end
				WeekCapture = os.date("%W", v)
			end
			if iMax == nil or math.abs(i) <= math.abs(iMax) then -- Starting to add recursive
				for l, m in pairs(daysOfWeek) do
					if os.date("%w", v) == tostring(m) then
						table.insert(vals, v)
					end
				end
			end
        end
    end
    return vals
end