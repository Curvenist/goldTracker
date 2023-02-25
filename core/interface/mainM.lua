MainM = {
    options = true,
    optVal = nil,
    panel = nil,
	isShown = true,

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
		"CENTER",
		function(s, x) return s.p.w / x end,
		function(s, x) return s.p.h / x end,
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
			local textSize = {false, self.textSize(self.p.h)}

			self.panel = self:setupFrame("Bank Account")
			self.panel.texture = self:addTexture()
			--self.panel:Hide()

			self.panel.buttonClose = self:appendCloseBox(textSize)
			self.panel.buttonResize = self:appendResizeBorder()

			-- don't forget, first is margin, second is step between loops, third is case when there is a "label" : "value" duo
			local X, Y = {0, 0, 100}, {0, -20, 0} 
			
			self.panel.central = self:addPanelElementItem("central", Const.TrackerCurrent, self:setPosition({"TOPLEFT", 2, 1.5, X, Y}), "Frame", textSize)
			
			X, Y = {150, 0, 100}, {0, -20, 0}

			self.panel.side = self:addPanelElementItem("side", Const.AdvancedStatOp, self:setPosition({"TOPLEFT", 2, 1.5, X, Y}), "Frame", textSize)

			self.panel.arrowLeft = self:addPanelElementMethod("arrowLeft", self:buttonCall(false), self:setPosition({"LEFT", 0, 1.5}), "Button", "OnClick")
			self.panel.arrowRight = self:addPanelElementMethod("arrowRight", self:buttonCall(true), self:setPosition({"RIGHT", 1, 1.5}), "Button", "OnClick")
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
	panel:SetPoint("CENTER", 0, 0)

	return panel
end


function MainM:addTexture()
	local t = self.panel:CreateTexture(nil, "BACKGROUND")
	t:SetAllPoints()
	t:SetColorTexture(0, 0, 0, 0.5)
	return t
end

function MainM:appendCloseBox(textSpacing)
	local f = CreateFrame("Button", nil, self.panel)
	f:SetSize(textSpacing[2], textSpacing[2])
	f:SetPoint("TOPRIGHT", 0, 0)

	local t = f:CreateFontString(nil, "OVERLAY")
	t:SetFont(OptInt:get("font"), textSpacing[2] or 11)
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
	self:displayMenuElements(position[4], position[5], item, f, textSpacing, name)
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
-- in order of array : width, height, X, Y
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
function MainM:displayMenuElements(X, Y, item, frame, textSpacing, name)
    local X, Y = X or {0, 0, 100}, Y or {-20, -20, 0}
    frame = frame or self.panel
    frame.fontStrings = {}
	frame.elems = {}
	local createElement = function (increment, key, value) 
		frame.elems[name] = self:elementCommand(frame, key, X, Y)
		if type(frame.elems[name]) ~= "table" then
			if value ~= nil then
				local linetext = frame:CreateFontString(nil, "OVERLAY")
				linetext:SetFont(OptInt:get("font"), textSpacing[2] or 11)
				linetext:SetPoint("TOPLEFT", X[1], Y[1])
				linetext:SetText(value)
				linetext:SetJustifyH("left")
				frame.fontStrings[key .. increment .. "Text"] = linetext
			end

			local linevalue = frame:CreateFontString(nil, "OVERLAY")
			if textSpacing[1] then 
				linevalue:SetSpacing(math.abs(Y[2]))
			end
			linevalue:SetFont(OptInt:get("font"), textSpacing[2] or 11)
			linevalue:SetJustifyH("left")
			linevalue:SetPoint("TOPLEFT", X[1] + X[3], Y[1] + Y[3])
			frame.fontStrings[key .. increment] = linevalue
		end
		X[1] = X[1] + X[2]
        Y[1] = Y[1] + Y[2]
	end
	for k in pairs(item) do 
		if type(item[k]) == "table" then
			createElement(k, item[k][1], item[k][2])
		else
			createElement(k, item[k])
		end
	end


	return frame
end
--InterfaceOptions_AddCategory(frame)

-- This function allows us to create quickly objects with a command line in the constant, like drawing a line
function MainM:elementCommand(frame, value, X, Y)
	local l, width = nil, (self.p.w / 3)

	return  GeneralM:case(string.find(value, "%%drawLine") ~= nil, function ()
			l = frame:CreateLine()
			l:SetColorTexture(1, 1, 1, 1)
			l:SetStartPoint("TOP", X[1] - (width * 0.60), Y[1])
			l:SetEndPoint("TOP", X[1] + (width * 0.20), Y[1])
			l:SetThickness(1)
		 end) and l
end

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


