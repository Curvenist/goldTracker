--CMM : customMoneyMethods
CMM = {
	data = customMoney,
	timeArray = {}
}
--[[
function CMM:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
]]--


-- New function, this time we're looking to show data from the previous 7 days.
-- What me may do also is : taking the week by a start of week aka wednesday, each wednesday, the interval will be set to 0
-- So my point is, we show here both the week performance by wednesday and by the 7 last days

-- How this function works, simple, we look into our date entries (besides, we will convert here all the dates to it's timestamp) and seek out from 'the day we want' the X days we'll compute!
-- now that all our entries are timestamp, going to be ez!!

function CMM:main()
	self:popUpData()
end

function CMM:popUpData()
	if MainM.panel.side1.fontStrings then
		for i = 1, 3 do
			for k, v in pairs(Const.TrackerPast) do v = v[1]
				MainM.panel["side" .. i].fontStrings[v]:SetText(Money:ConvertGold(self[v]))
			end
		end
	end
	self.netEarning = self.income + self.netValueD + self.netValue - self.spending
    
		for k, v in pairs(Const.TrackerCurrent) do v = v[1]
        	MainM.panel.central.fontStrings[v]:SetText(Money:ConvertGold(self[v]))
		end
    end
	self.netEarning = 0
end

function CMM:getInterval(day, intervalMax)
	day = day or TrackerDate
	intervalMax = intervalMax or 0

	DateM:orderArray(true, DateM:setArray(self:getData()))

	return DateM:datePicker({}, {day, intervalMax})
end

function CMM:getCluster(arrayOfDates)
	arrayOfDates = arrayOfDates or {}

	DateM:orderArray(true, DateM:setArray(self:getData()))

	return DateM:datePicker({arrayOfDates})
end

function CMM:getMathematicalDates(days, occurences)
	days = days or {}
	occurences = occurences or {}

	DateM:orderArray(true, DateM:setArray(self:getData()))

end

function CMM:getData()
	return self.data
end

function CMM:getTimeArray()
	return self.timeArray
end