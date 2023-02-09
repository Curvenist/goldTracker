Tracker = TrackerInstance:new()
NewCMM = CMM:new()

function Tracker:popUpData()
	self.netEarning = self.income + self.netValueD + self.netValue - self.spending
    if MainM.panel.central.fontStrings ~= nil then
		for k, v in pairs(Const.TrackerCurrent) do v = v[1]
        	MainM.panel.central.fontStrings[v]:SetText(Money:ConvertGold(self[v]))
		end
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
		self:constr()
		self.currentMoney = self:GetMoney()
        if customMoney[TrackerDate] ~= nil then --loading existing data!
			for k, v in pairs(customMoney[TrackerDate]) do
				self[k] = customMoney[TrackerDate][k]
			end
            self:catchup()
        else --a new day
            self.dailyMoney = self:GetMoney()
            self.dailyCatch = false
        end
        if not self.dailyCatch then
            self:catchupDaily() -- for setting netValueD
            self.dailyCatch = true
        end
		self:updateNetEarning(self.income + self.netValueD + self.netValue - self.spending)

        self:popUpData()
		-- getReady for inception!!
		NewCMM:main(2, customMoney)
		NewCMM:popUpData(NewCMM.timeArray)
    end)
end


--rolling when earning / spending
function Tracker:RecordMoney()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_MONEY")
    f:SetScript("OnEvent", function()
        local amount = self.currentMoney - self:GetMoney()
        self:updateFlux(amount)
        self.currentMoney = self:GetMoney() --updating Our Current money
		self:updateNetEarning(self.income + self.netValueD + self.netValue - self.spending)
        self:popUpData()
		NewCMM:popUpData(NewCMM.timeArray)
    end)
end

--save variables
function Tracker:logoutEvent()
	self.netEarning = 0
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGOUT")
    f:SetScript("OnEvent", function()
        customMoney[TrackerDate] = self
    end)
   
end

function Tracker:GetMoney() --
    Money:SetMoney(GetMoney())
    return Money:GetMoney()
end
