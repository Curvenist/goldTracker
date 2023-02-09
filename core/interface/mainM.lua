MainM = {
    options = true,
    optVal = nil,
    panel = nil,
	isShown = false,

	p = {
		w = 400,
		h = 150
	},
	c = {
		bSizX = 400 / 2,
		bSizY = 150 / 1.5,
		bPosY = (150 / 2) * (-1)
	}
}

function MainM:getHeight(Height)
	return self.p.h
end

function MainM:getWidth(Width)
	return self.p.w
end

function MainM:main()
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(___, event, addonname)
        if addonname == "goldTracker" then
			self:setupOverlay(addonname) --library

			self.panel = self:setupFrame("Bank Account")
			self.panel.texture = self:addTexture()
			self.panel:Hide()

			self.panel.buttonClose = self:appendCloseBox()

			local X, Y = {0, 0, 100}, {0, -20, 0}
			self.panel.central = self:addPanelElementItem("central", Const.TrackerCurrent, {"LEFT", self.c.bSizX, self.c.bSizY, X, Y}, "Frame")
			Y = {0, -8, 0}
			self.panel.side = self:addPanelElementItem("side", Const.TrackerPast, {"LEFT",  self.c.bSizX, self.c.bSizY, {self.c.bSizX, 0, 0}, Y}, "Frame", true)
			self.panel.arrowLeft = self:addPanelElementMethod("arrowLeft", self:buttonCall(false), {"LEFT", 0, self.c.bPosY}, "Button", "OnClick")
			self.panel.arrowRight = self:addPanelElementMethod("arrowRight", self:buttonCall(true), {"RIGHT", self:getWidth(), self.c.bPosY}, "Button", "OnClick")

        end
    end)
end

function MainM:setupOverlay(addonname)
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject(addonname, {
		text = addonname,		
		icon = "Interface\\icons\\inv_misc_bag_01",	
		OnClick = function(s, btn)
					if self.isShown then self.panel:Hide(); self.isShown = false
					elseif not self.isShown then self.panel:Show() self.isShown = true end
					return
				end
		})
		local icon = LibStub("LibDBIcon-1.0", true)
		icon:Register(addonname, miniButton)
end

function MainM:setupFrame(name)
	local panel = CreateFrame("Frame", "main")
	panel.name = name

	panel:SetFrameStrata("BACKGROUND")
	panel:SetWidth(self:getWidth())
	panel:SetHeight(self:getHeight())
	panel:EnableKeyboard()
	panel:SetPropagateKeyboardInput(true)
	panel:SetScript("OnKeyDown", function (arg, key) 
		if key == "ESCAPE" then
			self.panel:Hide(); self.isShown = false;
		end end)

	panel:SetPoint("Center", 0, 0)

	return panel
end


function MainM:addTexture()
	local t = self.panel:CreateTexture(nil, "BACKGROUND")
	t:SetAllPoints()
	t:SetColorTexture(0, 0, 0, 0.5)
	return t
end

function MainM:appendCloseBox()
	local f = CreateFrame("Button", nil, self.panel)
	f:SetSize("15", "15")
	f:SetPoint("TOPRIGHT", 0, 0)

	local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	t:SetPoint("TOP", 0, 0)
	t:SetText("x")
	f.fontString = t
	
	f:SetScript("OnClick", function () self.panel:Hide(); self.isShown = false; return end)
	return f
end

function MainM:addPanelElementItem(name, item, position, type, textSpacing)
	local f = CreateFrame(type, name, self.panel)
	f:SetSize(position[2], position[3])
	f:SetPoint(position[1], 0, 0)
	self:displayTrackerElements(position[4], position[5], item, f, textSpacing)
	return f
end

function MainM:addPanelElementMethod(name, method, position, type, script, textSpacing)
	local f = CreateFrame(type, name, self.panel)
	f:SetSize(position[2], position[3])
	f:SetPoint(position[1], 0, 0)
	f:SetScript(script, method)
	return f
end

function MainM:buttonCall(bool)
	return 
end

-- X = {x, sX, valueXPos} => sX for stepX, valueXPos is the marker for positionning the value on X abs (horizontal)
-- Y = {y, sY, valueYPos} => sy for stepY, valueYPos is the same // on Y (vertical)
-- This method sets up a system with a label : value displaying date, most common
function MainM:displayTrackerElements(X, Y, item, frame, textSpacing)
    X, Y = X or {0, 0, 100}, Y or {-20, -20, 0}
    frame = frame or self.panel
    frame.fontStrings = {}
    for k, v in ipairs(item) do 
		local key = item[k][1]
		local value = item[k][2]
		if value ~= nil then
			local linetext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			linetext:SetPoint("TOPLEFT", X[1], Y[1])
			linetext:SetText(value)
			linetext:SetJustifyH("left")
			frame.fontStrings[key .. "Text"] = linetext
		end

        local linevalue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		if textSpacing then 
			linevalue:SetSpacing(math.abs(Y[2]))
		end
		linevalue:SetJustifyH("left")
        linevalue:SetPoint("TOPLEFT", X[1] + X[3], Y[1] + Y[3])
        frame.fontStrings[key] = linevalue

		X[1] = X[1] + X[2]
        Y[1] = Y[1] + Y[2]
    end
	return frame
end
--InterfaceOptions_AddCategory(frame)


--looking for previous day or next day
-- ArrowLeft if Next is false, Arrow right if next is true
function MainM:goToAdjacentDay(Next)

end

function MainM:gotToDay(dateTimestamp)

end

-- This method shows the date for the days previous (by default) or after if we select a parameter
-- for now, we will only show arbitrary 3 data, check in Tracker
function MainM:panelSide()

end

