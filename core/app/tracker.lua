Tracker = TrackerInstance:new()
NewGTM = GTM:new()
NewConfig = Config:new()

function Tracker:popUpData()
	Tracker:find("netEarning")
    if MainM.panel.mainElementTrackerCurrent.fontStrings ~= nil then
		for k, v in pairs(Const.TrackerCurrent) do v = v[1]
            if GeneralM:isNotCommand(v) then
        	    MainM.panel.mainElementTrackerCurrent.fontStrings[v .. k]:SetText(Money:ConvertGold(self[v]))
            end
		end
    end
end

function Tracker:main() -- fonction d'entrée, login started
    if GTMoney == nil then -- fresh install
        GTMoney = {}
    elseif GTMoney[TrackerDate] == nil then
        GTMoney[TrackerDate] = Tracker
	end
    if GTConfigs == nil then
        GTConfigs = OptInt
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
        if GTMoney[TrackerDate] ~= nil then --loading existing data!
			for k, v in pairs(GTMoney[TrackerDate]) do
				self[k] = GTMoney[TrackerDate][k]
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
		self:update("netEarning", self.income + self.netValueD + self.netValue - self.spending)

        self:popUpData()
        NewGTM:main(GTMoney)
        NewConfig:popUpData()
        NewGTM:popUpStaticReport()
        NewGTM:popUpDataCompared()
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
		self:update("netEarning", self.income + self.netValueD + self.netValue - self.spending)
        self:popUpData()
        NewGTM:popUpDataCompared()
    end)
end

--save variables
function Tracker:logoutEvent()
	self.netEarning = 0
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGOUT")
    f:SetScript("OnEvent", function()
        GTConfigs = GTConfigs
        GTMoney[TrackerDate] = self
    end)
   
end

function Tracker:GetMoney() --
    Money:SetMoney(GetMoney())
    return Money:GetMoney()
end
