dateExchange = date("%d%m%Y")

Exchange = {
    date = dateExchange,
    dailyMoney = 0, -- money at the first connection
    currentMoney = 0, -- the current money we have
    income = 0, -- plain income
    spending = 0, -- plain spending
    -- net value is recorded gain or loss when the player was not connected, see @Exchange:dailyCatch()
    netDailyValue = 0,
    netValue = 0,
    dailyCatch = false
}

-- we will record here all the data in the ui to check our fluctuations (called function)
--OHH YES 18:27 lundi 28 : WE FOUND THE SOLUTION TO TRACK THE ELEMENTS!
function Exchange:popUpData()
    if Menu.panel.fontStrings then
        Menu.panel.fontStrings["date"]:SetText(self.date)
        Menu.panel.fontStrings["dailyMoney"]:SetText(self.dailyMoney)
        Menu.panel.fontStrings["currentMoney"]:SetText(self.currentMoney)
        Menu.panel.fontStrings["income"]:SetText(self.income)
        Menu.panel.fontStrings["spending"]:SetText(self.spending)
        Menu.panel.fontStrings["netDailyValue"]:SetText(self.netDailyValue)
        Menu.panel.fontStrings["netValue"]:SetText(self.netValue)
    end
end



-- we will check the last dateExchange when the player was connected
function Exchange:checkLastCoDate(dateExchange)
    local d = GlobalMethods:timeChecker(dateExchange)
    local originDiff, comparedDiff = nil, nil
    for k,v in pairs(customMoney) do
        if originDiff == nil and k ~= dateExchange then
            originDiff = {k, math.floor((d - GlobalMethods:timeChecker(k)) / (24 * 60 * 60))} -- seconds, math gives whole day
        elseif comparedDiff == nil and k ~= dateExchange then
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
        return dateExchange
     end
    return originDiff[1]
end

-- this function usage allows us to find if there is a difference between last currentMoney recorder with the dailyMoney one, if there is, then we update the nature of income or spending (this one will be catch on netIncome)
function Exchange:catchupDaily()
    local lastDate = self:checkLastCoDate(dateExchange)
    if dateExchange ~= lastDate and customMoney[lastDate].currentMoney ~= self.dailyMoney then -- difference between two values, we need to catchup the netDailyValue! made also sure that it's diff day
        self.netValueD = self.dailyMoney - customMoney[lastDate].currentMoney
    end

end

function Exchange:catchup()
    if self.currentMoney ~= customMoney[dateExchange].currentMoney then
        self.netValue = self.netValue + self.currentMoney - customMoney[dateExchange].currentMoney
    end
end

function Exchange:main() -- fonction d'entrée, login started
    if customMoney == nil then -- fresh install
        customMoney = {}
    elseif customMoney[dateExchange] == nil then
        customMoney[dateExchange] = Exchange
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
        if customMoney[dateExchange] ~= nil then --loading existing data!
            self.dailyMoney = customMoney[dateExchange].dailyMoney
            self.income = customMoney[dateExchange].income
            self.spending = customMoney[dateExchange].spending
            self.dailyCatch = customMoney[dateExchange].dailyCatch
            self.netValue = customMoney[dateExchange].netValue
            self.netValueD = customMoney[dateExchange].netValueD
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
function Exchange:RecordMoney()
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
function Exchange:logoutEvent()

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGOUT")
    f:SetScript("OnEvent", function()
        customMoney[dateExchange] = Exchange
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

