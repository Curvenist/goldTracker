function SCMM:popUpData(array)
	local instance = Tracker
	local statCalcul, incomeType = nil, self.options["incomeNature"]
	if self.options["statsMethod"] == 1 then
		statCalcul = function(vals1, vals2) return {self.statDevi:rating(vals1, vals2), 1} end
elseif self.options["statsMethod"] == 2 then
		statCalcul = function(vals1, vals2) return {self.statDevi:plainPerformance({{vals1, vals2}}), 2} end
	end
	local panel = MainM.panel.side
	if panel ~= nil then
		for key, value in pairs(panel) do
			if self:getTimeArray(key) ~= nil then
				local d, dd = self:getTimeArray(key), nil
				if key < #panel and OptCMM:get("comparison") == 2 then 
					dd = self:getTimeArray(key + 1)
					instance = self.data[dd]
				elseif OptCMM:get("comparison") == 2 then
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
-- 	self.panel.side[k] = self:addPanelElementItem("side", Const.History, self:setPosition({"TOPLEFT", 2, (3/2), X, Y}), "Frame", textSize)
-- 	Y[1] = Y[1] - 20
-- end

-- self.panel.bottomDraw = self:addPanelElementItem("bottomDraw", Const.ElementDecoration[1], self:setPosition({"TOPLEFT", 2, (3/2), X, Y}), "Frame", textSize)