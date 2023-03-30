function SGTM:popUpData(array)
	local instance = Tracker
	local statCalcul, incomeType = nil, self.options["incomeNature"]
	if self.options["statsMethod"] == 1 then
		statCalcul = function(vals1, vals2) return {self.statDevi:rating(vals1, vals2), 1} end
elseif self.options["statsMethod"] == 2 then
		statCalcul = function(vals1, vals2) return {self.statDevi:plainPerformance({{vals1, vals2}}), 2} end
	end
	local panel = MainM.panel
	if panel ~= nil then
		for key, value in pairs(panel) do
			if self:getTimeArray(key) ~= nil then
				local d, dd = self:getTimeArray(key), nil
				if key < #panel and OptGTM:get("comparison") == 2 then 
					dd = self:getTimeArray(key + 1)
					instance = self.data[dd]
				elseif OptGTM:get("comparison") == 2 then
					instance = self.data[d]
				end
				self.CurrentTI:constr(instance) self.CurrentTI:find(incomeType)
				self.HistoryTI:constr(self.data[d]) self.HistoryTI:find(incomeType)
				 
				local translate = self:translate(statCalcul(self.CurrentTI[incomeType], self.HistoryTI[incomeType]), self.CurrentTI[incomeType], self.HistoryTI[incomeType])
				self:setStoreVal(date("%a %d/%m", d), 1)
				self:setStoreVal(Money:ConvertGold(self.HistoryTI[incomeType]), 2)
				self:setStoreVal(translate[1], 3)

				local gradient = self:processGradient(translate[3], OptStats:get("mult"))
				local paneltext = panel[key].fontStrings[Const.History[3][1]]

				if translate[2] >= 0 then paneltext:SetTextColor(gradient, 1, gradient, 1)
				elseif translate[2] < 0 then paneltext:SetTextColor(1, 1, 1 - gradient, 1) end
				
				for k, v in pairs(Const.History) do v = v[1]
					panel[key].fontStrings[v]:SetText(self:getStoreVal(k))
				end
			end
		end
	end
end

-- for k = 1, OptInt:get("maxIterations") do
-- 	self.panel[k] = self:addPanelElementItem("side", Const.History, self:setPosition({"TOPLEFT", 2, (3/2), X, Y}), "Frame", textSize)
-- 	Y[1] = Y[1] - 20
-- end

-- self.panel.bottomDraw = self:addPanelElementItem("bottomDraw", Const.ElementDecoration[1], self:setPosition({"TOPLEFT", 2, (3/2), X, Y}), "Frame", textSize)


-- GTMoney = {
-- 	[1673478000] = {
-- 		["dailyMoney"] = 15043508958,
-- 		["dailyCatch"] = true,
-- 		["netValue"] = 0,
-- 		["currentMoney"] = 15047463093,
-- 		["income"] = 19733557,
-- 		["netDailyValue"] = 0,
-- 		["netEarning"] = 0,
-- 		["spending"] = 15779422,
-- 		["netValueD"] = 0,
-- 		["date"] = "12012023",
-- 	},
-- 	[1673737200] = {
-- 		["dailyMoney"] = 13162758745,
-- 		["dailyCatch"] = true,
-- 		["netValue"] = 0,
-- 		["currentMoney"] = 13172008615,
-- 		["income"] = 9681475,
-- 		["spending"] = 431605,
-- 		["netDailyValue"] = 0,
-- 		["netEarning"] = 0,
-- 		["netValueD"] = 0,
-- 		["date"] = "15012023",
-- 	},
-- 	[1673996400] = {
-- 		["dailyMoney"] = 13177024733,
-- 		["dailyCatch"] = true,
-- 		["date"] = "18012023",
-- 		["netValueD"] = 0,
-- 		["income"] = 148210272,
-- 		["spending"] = 29257259,
-- 		["netDailyValue"] = 0,
-- 		["netEarning"] = 0,
-- 		["currentMoney"] = 13295977746,
-- 		["netValue"] = 0,
-- 	},
-- 	[1674255600] = {
-- 		["dailyMoney"] = 13300886788,
-- 		["dailyCatch"] = true,
-- 		["date"] = "21012023",
-- 		["netValueD"] = 0,
-- 		["income"] = 45414961,
-- 		["spending"] = 11831738,
-- 		["netDailyValue"] = 0,
-- 		["netEarning"] = 0,
-- 		["currentMoney"] = 13334470011,
-- 		["netValue"] = 0,
-- 	},
-- 	[1674514800] = {
-- 		["dailyMoney"] = 14537512955,
-- 		["dailyCatch"] = true,
-- 		["date"] = "24012023",
-- 		["netValueD"] = 0,
-- 		["income"] = 2214270,
-- 		["spending"] = 12321293,
-- 		["netDailyValue"] = 0,
-- 		["netEarning"] = 0,
-- 		["currentMoney"] = 14527405932,
-- 		["netValue"] = 0,
-- 	},
-- 	[1674774000] = {
-- 		["dailyMoney"] = 0,
-- 		["dailyCatch"] = false,
-- 		["date"] = "27012023",
-- 		["income"] = 0,
-- 		["netEarning"] = 0,
-- 		["netDailyValue"] = 0,
-- 		["netValue"] = 0,
-- 		["currentMoney"] = 0,
-- 		["spending"] = 0,
-- 	},
-- }
-- dateArray = {}
-- for k, v in pairs(GTMoney) do
--     table.insert(dateArray, k)
-- end
-- table.sort(dateArray, function(a, b) return a > b end)

-- for k, v in pairs(dateArray) do
--     print(v)
-- end

-- print("-----")

-- function datePicker(datePicker, interval, vals) -- prendre un interval de date
-- datePicker, interval, vals =  datePicker or {}, interval or {}, {}

-- arrayOfDates = dateArray
-- if #datePicker ~= 0 then
--     arrayOfDates = datePicker
-- end

-- for k, v in pairs(arrayOfDates) do
--     if #interval == 2 then
--     if v <= interval[2] and v >= interval[1] then
--         table.insert(vals, v)
--     end
--     else
--         table.insert(vals, v)
--     end
-- end
-- return vals
-- end

-- function dateMathPicker(daysOfWeek, occurences) -- intéressant pour capter des dates par comparaison - tous les mercredi*


-- end


-- calcul = datePicker({}, {1673478000, 1674774000})
-- --calcul = datePicker({dateArray[2], dateArray[3], dateArray[4]})
-- --calcul = dateMathPicker({2, 3}, 5) --Every Tuesday / wednesday for 5 weeks

-- for k, v in pairs(calcul) do

--  print(os.date("%w",v))
-- end