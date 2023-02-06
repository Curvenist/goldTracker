TrackerDate = DateM:convertToDateType(date("%d%m%Y"))

Tracker = {
    date = date("%d%m%Y"),
    dailyMoney = 0, -- money at the first connection
    currentMoney = 0, -- the current money we have
	netEarning = 0, -- the current earning
    income = 0, -- plain income
    spending = 0, -- plain spending
    -- net value is recorded gain or loss when the player was not connected, see @Tracker:dailyCatch()
    netValueD = 0,
    netValue = 0,
    dailyCatch = false
}

function Tracker:popUpData()
	self.netEarning = self.income + self.netValueD + self.netValue - self.spending
    if MainM.panel.central.fontStrings then
		for k, v in pairs(Const.TrackerCurrent) do v = v[1]
        	MainM.panel.central.fontStrings[v]:SetText(Money:ConvertGold(self[v]))
		end
    end
	self.netEarning = 0
end

-- New function, this time we're looking to show data from the previous 7 days.
-- What me may do also is : taking the week by a start of week aka wednesday, each wednesday, the interval will be set to 0
-- So my point is, we show here both the week performance by wednesday and by the 7 last days

-- How this function works, simple, we look into our date entries (besides, we will convert here all the dates to it's timestamp) and seek out from 'the day we want' the X days we'll compute!
-- now that all our entries are timestamp, going to be ez!!


function Tracker:getInterval(day, intervalMax)
	day = day or TrackerDate
	intervalMax = intervalMax or 0

	DateM:orderArray(true, DateM:setArray(customMoney))

	return DateM:datePicker({}, {day, intervalMax})
end

function Tracker:getCluster(arrayOfDates)
	arrayOfDates = arrayOfDates or {}

	DateM:orderArray(true, DateM:setArray(customMoney))

	return DateM:datePicker({arrayOfDates})
end

function Tracker:getMathematicalDates(days, occurences)
	days = days or {}
	occurences = occurences or {}

	DateM:orderArray(true, DateM:setArray(customMoney))

	
end

-- we will check the last TrackerDate when the player was connected
function Tracker:checkLastCoDate(TrackerDate)
    local dateTimestamp = DateM:convertToDateType(TrackerDate)
    local originDiff, comparedDiff = nil, nil
    for k,v in pairs(customMoney) do

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

-- this function usage allows us to find if there is a difference between last currentMoney recorder with the dailyMoney one, if there is, then we update the nature of income or spending (this one will be catch on netIncome)
function Tracker:catchupDaily()
    local lastDate = self:checkLastCoDate(TrackerDate)
    if TrackerDate ~= lastDate and customMoney[lastDate].currentMoney ~= self.dailyMoney then -- difference between two values, we need to catchup the netValueD! made also sure that it's diff day
        self.netValueD = self.dailyMoney - customMoney[lastDate].currentMoney
    end

end

function Tracker:catchup()
    if self.currentMoney ~= customMoney[TrackerDate].currentMoney then
        self.netValue = self.netValue + self.currentMoney - customMoney[TrackerDate].currentMoney
    end
end

function Tracker:main() -- fonction d'entrée, login started
    if customMoney == nil then -- fresh install
        customMoney = {}
    elseif customMoney[TrackerDate] == nil then
        customMoney[TrackerDate] = Tracker
	end
    self:frameAdvisor()
end

function Tracker:frameAdvisor() -- frameAdvisor is used to store all our indepedent methods of calculation
    self:loginEvent()
    self:RecordMoney()
    self:logoutEvent()
end

--rolling on start
function Tracker:loginEvent()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGIN")
    f:SetScript("OnEvent", function()
		--DateMethods:testConversionAllDates()
        self.currentMoney = self:GetMoney()
        if customMoney[TrackerDate] ~= nil then --loading existing data!
            self.dailyMoney = customMoney[TrackerDate].dailyMoney
            self.income = customMoney[TrackerDate].income
            self.spending = customMoney[TrackerDate].spending
            self.dailyCatch = customMoney[TrackerDate].dailyCatch
            self.netValue = customMoney[TrackerDate].netValue
            self.netValueD = customMoney[TrackerDate].netValueD
            self:catchup()
        else --a new day
            self.dailyMoney = self:GetMoney()
            self.income = 0
            self.spending = 0
            self.netValue = 0
            self.netValueD = 0
            self.dailyCatch = false
        end
        if not self.dailyCatch then
            self:catchupDaily() -- for setting netValueD
            self.dailyCatch = true
        end
        self:popUpData()
    end)
end


--rolling when earning / spending
function Tracker:RecordMoney()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_MONEY")
    f:SetScript("OnEvent", function()
        local amount = self.currentMoney - self:GetMoney()
        self:updateCurrencyCollector(amount)
        self.currentMoney = self:GetMoney() --updating Our Current money
        self:popUpData()
    end)
end

--save variables
function Tracker:logoutEvent()

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGOUT")
    f:SetScript("OnEvent", function()
        customMoney[TrackerDate] = Tracker
    end)
   
end

function Tracker:GetMoney() --
    Money:SetMoney(GetMoney())
    return Money:GetMoney()
end



function Tracker:updateCurrencyCollector(amount)
    if amount < 0 then
        self.income = self.income + math.abs(amount)
    elseif amount > 0 then
        self.spending = self.spending + amount
    else
        return false -- no changes
    end
    return true
end

