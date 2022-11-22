Exchange = {
    date = nil,
    dailyMoney = nil, -- money at the first connection
    currentMoney = nil, -- the current money we have
    income = nil, -- plain income
    spending = nil, -- plain spending
    netValue = nil, -- net value is recorded gain or loss when the player was not connected, see @Exchange:catchup()
    catchup = false
}

-- we will check the last date when the player was connected
function Exchange:checkLastCoDate(date)
    local d = globalMethods:timeChecker(date)
    local originDiff, comparedDiff = nil, nil
    for k,v in customMoney do
        if originDiff ~= nil then
            originDiff = {k, math.floor(os.difftime(d, globalMethods:timeChecker(k)) / (24 * 60 * 60))} -- seconds, math gives whole day
        elseif comparedDiff ~= nil then
            comparedDiff = {k, math.floor(os.difftime(d, globalMethods:timeChecker(k)) / (24 * 60 * 60))} -- seconds, math gives whole day
        end
        if originDiff ~= nil and comparedDiff ~= nil then
            if originDiff[2] > comparedDiff[2] then 
             originDiff = comparedDiff
             end
             comparedDiff = nil --always clear the compare one 
        end
    end
    return originDiff[1]
end

-- this function usage allows us to find if there is a difference between last currentMoney recorder with the dailyMoney one, if there is, then we update the nature of income or spending (this one will be catch on netIncome)
function Exchange:catchupDaily()
    local lastDate = self:checkLastCoDate(self.date)
    if customMoney[lastDate].currentMoney ~= self.dailyMoney then -- difference between two values, we need to catchup the netValue!
        self.netValue = self.dailyMoney - customMoney[lastDate].currentMoney -- if gt 0 then income, else its loss :'('
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
    self:loginEvent() -- setting up our class with values, also firing catchup once!
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
        else --a new day
            self.dailyMoney = self:GetMoney()
            self.income = 0
            self.spending = 0
        end
        if not self.catchup then
            self:catchupDaily()
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