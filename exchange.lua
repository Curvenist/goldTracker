Exchange = {
    date = nil,
    dailyMoney = nil,
    currentMoney = nil,
    income = nil,
    spending = nil
}


function Exchange:main() -- fonction d'entrée, login started
    self.date = date("%d%m%y")
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
        else --a new day
            self.dailyMoney = self:GetMoney()
            self.income = 0
            self.spending = 0
            
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