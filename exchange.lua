Exchange = {
    date = nil,
    dailyMoney = nil, -- money at the first connection
    currentMoney = nil, -- the current money we have
    income = nil, -- plain income
    spending = nil, -- plain spending
    -- net value is recorded gain or loss when the player was not connected, see @Exchange:dailyCatch()
    netDailyValue = nil,
    netValue = nil,
    dailyCatch = false
}

-- we will check the last date when the player was connected
function Exchange:checkLastCoDate(date)
    local d = GlobalMethods:timeChecker(date)
    local originDiff, comparedDiff = nil, nil
    for k,v in pairs(customMoney) do
        if originDiff == nil and k ~= self.date then
            originDiff = {k, math.floor((d - GlobalMethods:timeChecker(k)) / (24 * 60 * 60))} -- seconds, math gives whole day
        elseif comparedDiff == nil and k ~= self.date then
            comparedDiff = {k, math.floor((d - GlobalMethods:timeChecker(k)) / (24 * 60 * 60))} -- seconds, math gives whole day
        end
        if originDiff ~= nil and comparedDiff ~= nil then
            if originDiff[2] > comparedDiff[2] then
             originDiff = comparedDiff
             end
             comparedDiff = nil --always clear the compare one 
        end
    end
    if originDiff == nil then 
        return self.date
     end
    return originDiff[1]
end

-- this function usage allows us to find if there is a difference between last currentMoney recorder with the dailyMoney one, if there is, then we update the nature of income or spending (this one will be catch on netIncome)
-- 24/12/2022 dang it, forgot to add income and spending to calculate netValueD
function Exchange:catchupDaily()
    local lastDate = self:checkLastCoDate(self.date)
    if self.date ~= lastDate and customMoney[lastDate].currentMoney ~= self.dailyMoney then -- difference between two values, we need to catchup the netDailyValue! made also sure that it's diff day
        self.netValueD = self.dailyMoney - self.income + self.spending - customMoney[lastDate].currentMoney
    end

end

-- 24/12/2022 dang it, forgot to add income and spending to calculate netValue
function Exchange:catchup()
    if self.currentMoney ~= customMoney[self.date].currentMoney then
        self.netValue = self.netValue + (self.currentMoney - self.income + self.spending - customMoney[self.date].currentMoney)
    end
end

function Exchange:main() -- fonction d'entrée, login started
    self.date = date("%d%m%Y")
    if customMoney == nil then -- fresh install
        customMoney = {}
    elseif customMoney[self.date] == nil then
        customMoney[self.date] = Exchange
    end
    
    self:frameAdvisor()
end

function Exchange:frameAdvisor() -- frameAdvisor is used to store all our indepedent methods of calculation
    self:loginEvent()
    self:RecordMoney()
    self:logoutEvent()
end

--rolling on start
function Exchange:loginEvent()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGIN")
    f:SetScript("OnEvent", function()
        self.currentMoney = self:GetMoney()
        
        
        if customMoney[self.date] ~= nil then --loading existing data!
            self.dailyMoney = customMoney[self.date].dailyMoney
            self.income = customMoney[self.date].income
            self.spending = customMoney[self.date].spending
            self.dailyCatch = customMoney[self.date].dailyCatch
            self.netValue = customMoney[self.date].netValue
            self.netValueD = customMoney[self.date].netValueD
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
        
        
    end)
end


--rolling when earning / spending
function Exchange:RecordMoney()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_MONEY")
    f:SetScript("OnEvent", function()
        local amount = self.currentMoney - self:GetMoney()
        self:updateCurrencyCollector(amount)
        self.currentMoney = self:GetMoney() --updating Our Current money
    end)
end

--save variables
function Exchange:logoutEvent()

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGOUT")
    f:SetScript("OnEvent", function()
        customMoney[self.date] = Exchange
    end)
   
end

function Exchange:GetMoney() --
    Money:SetMoney(GetMoney())
    return Money:GetMoney()
end



function Exchange:updateCurrencyCollector(amount)
    if amount < 0 then
        self.income = self.income + math.abs(amount)
    elseif amount > 0 then
        self.spending = self.spending + amount
    else
        return false -- no changes
    end
    return true
end

Exchange:main()