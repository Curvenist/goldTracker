MainM = {
    options = true,
    optVal = nil,
    panel = nil,
	isShown = false,

	p = {
		w = 400,
		h = 180,
	},

	c = {
		MulW = function(s, val) return s.p.w * val end,
		MulH = function(s, val) return s.p.h * val end,

		DivW = function(s, val) if val == 0 then return s.p.w * val end return s.p.w / val end,
		DivH = function(s, val) if val == 0 then return s.p.h * val end return s.p.h / val end
	},

	textSize = function(val)
		local val = val or 0
		return (val / (val * 0.1) + 1)
	end,

	position = {
		"Center",
		function(s) return s.p.w / 2 end,
		function(s) return s.p.h / 2 end,
		{0, 0, 0},
		{0, 0, 0}
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
			--self.panel:Hide()

			self.panel.buttonClose = self:appendCloseBox()
			self.panel.buttonResize = self:appendResizeBorder()

			local X, Y = {0, 0, 100}, {0, -20, 0} -- don't forget, first is margin, second is step between loops, third is case when there is a "label" : "value" duo
			local textSize = {false, self.textSize(self.p.h)}
			self.panel.central = self:addPanelElementItem("central", Const.TrackerCurrent, self:setPosition({"LEFT", 2, (3/2), X, Y}), "Frame", textSize)
			self.panel.side = {}
			X, Y = {150, 100, 0}, {0, 0, 0}
			for k = 1, 7 do
				self.panel.side[k] = self:addPanelElementItem("side", Const.TrackerPast, self:setPosition({"LEFT", 2, (3/2), X, Y}), "Frame", textSize)
				Y[1] = Y[1] - 20
			end
			self.panel.arrowLeft = self:addPanelElementMethod("arrowLeft", self:buttonCall(false), self:setPosition({"LEFT", 0, (3/2)}), "Button", "OnClick")
			self.panel.arrowRight = self:addPanelElementMethod("arrowRight", self:buttonCall(true), self:setPosition({"RIGHT", 1, (3/2)}), "Button", "OnClick")
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

--@todo we should add options in order to change size, colors etc!

function MainM:setupFrame(name)
	local panel = CreateFrame("Frame", "main")
	panel.name = name

	panel:SetFrameStrata("BACKGROUND")
	panel:SetPoint("CENTER")
	panel:SetWidth(self:getWidth())
	panel:SetHeight(self:getHeight())
	panel:EnableKeyboard(true)
	panel:EnableMouse(true)
	panel:SetPropagateKeyboardInput(true)
	panel:SetMovable(true)
	panel:SetResizable(true)
	panel:SetResizeBounds(self.c.DivW(self, 2), self.c.DivH(self, 2), self.c.MulW(self, 2), self.c.MulH(self, 2))
	panel:SetUserPlaced(true)
	panel:RegisterForDrag("LeftButton")
	panel:SetScript("OnKeyDown", function (arg, key) 
		if key == "ESCAPE" then
			self.panel:Hide(); self.isShown = false;
		end end)
	panel:SetScript("OnDragStart", function (arg, key) 
		arg:StartMoving()
		end)
	panel:SetScript("OnDragStop", function (arg, key) 
		arg:StopMovingOrSizing()
		end)
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

function MainM:appendResizeBorder()
	local b = CreateFrame("Button", nil, self.panel)
	b:EnableMouse(true)
	b:SetSize(16,16)
	b:SetPoint("BOTTOMRIGHT")

	b:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	b:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	b:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")

	b:SetScript("OnMouseDown", function(self)
		b:GetParent():StartSizing("BOTTOMRIGHT") 
	end)
	b:SetScript("OnMouseUp", function()
		b:GetParent():StopMovingOrSizing("BOTTOMRIGHT")
	end)
	return b
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

--[[
addPanelElementItem explanation :
1 : "name"
2 : "properties helping filling data"
--------
3 : "{"PanelPosition", "Width", Height, X, Y}"
X = {"ElemWidth", "ElemIncrementOverloop", "positionOfvalueInCaseOfText"}
Y = Same as X but for Y
-------
4 : type of frame
5 : textSpacing in order of multiline
]]--

function MainM:getPosition(index)
	if index ~= nil then
	return self.position[index]
	end
	return self.position
end

function MainM:setPosition(array, object)
	object = self:getPosition()
	array[1], array[2], array[3], array[4], array[5] = 
			array[1] or self:getPosition(1),
			array[2] or self:getPosition(2),
			array[3] or self:getPosition(3),
			array[4] or self:getPosition(4),
			array[5] or self:getPosition(5)
	
	object[1] = array[1]
	object[2] = self.c.DivW(self, array[2])
	object[3] = self.c.DivH(self, array[3])
	object[4] = {array[4][1], array[4][2], array[4][3]}
	object[5] = {array[5][1], array[5][2], array[5][3]}
	return object
end

-- X = {x, sX, valueXPos} => sX for stepX, valueXPos is the marker for positionning the value on X abs (horizontal)
-- Y = {y, sY, valueYPos} => sy for stepY, valueYPos is the same // on Y (vertical)
-- This method sets up a system with a label : value displaying date, most common
function MainM:displayTrackerElements(X, Y, item, frame, textSpacing)
    local X, Y = X or {0, 0, 100}, Y or {-20, -20, 0}
    frame = frame or self.panel
    frame.fontStrings = {}
    for k, v in ipairs(item) do 
		local key = item[k][1]
		local value = item[k][2]
		if value ~= nil then
			local linetext = frame:CreateFontString(nil, "OVERLAY")
			linetext:SetFont("Fonts\\ARIALN.TTF", textSpacing[2] or 11)
			linetext:SetPoint("TOPLEFT", X[1], Y[1])
			linetext:SetText(value)
			linetext:SetJustifyH("left")
			frame.fontStrings[key .. "Text"] = linetext
		end

        local linevalue = frame:CreateFontString(nil, "OVERLAY")
		if textSpacing[1] then 
			linevalue:SetSpacing(math.abs(Y[2]))
		end
		linevalue:SetFont("Fonts\\ARIALN.TTF", textSpacing[2] or 11)
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


