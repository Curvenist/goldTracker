TrackerDate = DateM:convertToDateType(date("%d%m%Y"))

TrackerInstance = {
    date = date("%d%m%Y"),
    dailyMoney = 0, -- money at the first connection
    currentMoney = 0, -- the current money we have
	netEarning = 0, -- the current earning -- chose not to be recorded in data as its a process of calculation
    income = 0, -- plain income
    spending = 0, -- plain spending
    -- net value is recorded gain or loss when the player was not connected, see @Tracker:dailyCatch()
    netValueD = 0, -- netValueD is based on LASTDATE check
    netValue = 0, -- netValueD is based on CURRENTDATE check - so those values are different
    dailyCatch = false
}

function TrackerInstance:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function TrackerInstance:constr(o)
    o = o or nil
	for k, v in pairs(TrackerInstance) do 
        if type(v) ~= "function" then
            if k == "date" then
                self[k] = o ~= nil and o[k] or date("%d%m%Y")
        elseif k == "dailyCatch" then
                self[k] = o ~= nil and o[k] or false
            else
                self[k] = o ~= nil and o[k] or 0
            end
        end
    end
end

function TrackerInstance:update(index, value)
	self[index] = value
end

function TrackerInstance:find(index)
    index = index or "income"
    if index == "netEarning" then
        self[index] = self.income + self.netValueD + self.netValue - self.spending
    end
    return self[index]
end

-- this function usage allows us to find if there is a difference between last currentMoney recorder with the dailyMoney one, if there is, then we update the nature of income or spending (this one will be catch on netIncome)
function TrackerInstance:catchupDaily(date)
	date = date or TrackerDate
	local lastDate = DateM:checkLastCoDate(date)
    if date ~= lastDate and customMoney[lastDate].currentMoney ~= self.dailyMoney then -- difference between two values, we need to catchup the netValueD! made also sure that it's diff day
        self.netValueD = self.dailyMoney - customMoney[lastDate].currentMoney
	end
end

function TrackerInstance:catchup(dayDate)
	dayDate = dayDate or TrackerDate
    if self.currentMoney ~= customMoney[dayDate].currentMoney then
        self.netValue = self.netValue + self.currentMoney - customMoney[dayDate].currentMoney
    end
	
end

function TrackerInstance:updateFlux(amount)
    if amount < 0 then
        self.income = self.income + math.abs(amount)
    elseif amount > 0 then
        self.spending = self.spending + amount
    else
        return false -- no changes
    end
    return true
end