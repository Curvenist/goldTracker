MainM = {
    options = true,
    optVal = nil,
    panel = nil,
	isShown = true,

	p = {
		w = 500,
		h = 250,
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

VProperties = {}

function VProperties:get(index)
	if index ~= nil then
		return self[index]
	end
	return self
end

function VProperties:update()
	self.container = {w = MainM:getWidth(), h = MainM:getHeight()}
	self.menuBox = {w = MainM:getWidth() / 4, h = MainM:getHeight()}
	self.mainBox = {w = (MainM:getWidth() - MainM:getWidth() / 1.5), h = MainM:getHeight()}
	self.padding = {w = MainM:getWidth() * 0.05, h = MainM:getHeight() * -0.05} -- margins are 5% of the max size
	self.textSize = {false, MainM.textSize(MainM.p.h)}
end

function VProperties:marges(index)
	self.margin = {w = self:get(index)['w'] * 0.1, h = self:get(index)['h'] * -0.1} -- this a global margin of 10%
	self.steps = {w = self:get(index)['w'] * 0, h = self:get(index)['h'] * -0.1} -- next iteration element position
	self.nextItemPos = {w = self:get(index)['w'] * 0.5, h = self:get(index)['h'] * 0} -- in case we have at least 2 values on same line, like label / value
end


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
			VProperties:update()
			self:setupOverlay(addonname) --library

			self.panel = self:setupFrame("Bank Account")
			self.panel.texture = self:addTexture()
			--self.panel:Hide()
			self.panel.buttonClose = self:appendCloseBox(VProperties.textSize)
			self.panel.buttonResize = self:appendResizeBorder(VProperties.textSize)

			--@todo here gonna add buttons for options
			VProperties:marges("menuBox")
			local X, Y, obj = {VProperties.padding.w, 0, 0}, {0, VProperties.steps.h, 0}, nil
			self.panel.menu = self:addPanelElementItem("menu", nil, self:setPosition({"TOPLEFT", VProperties.menuBox.w, VProperties.menuBox.h, X, Y}), "Frame")
			
			self.panel.menuElement = {}
			X, Y = {VProperties.padding.w, 0, VProperties.nextItemPos.w}, {0, -20, 0}
			for k, v in pairs(Const.MenuButtons) do
				Y[1] = Y[1] + Y[2]
				self.panel.menuElement[k] = self:addPanelSingleButton("menuElement" .. k, Const.MenuButtons[k], self:setPosition({"TOPLEFT", VProperties.menuBox.w, VProperties.menuBox.h, X, Y}), VProperties.textSize, {"panel", "menu"})
			end

			VProperties:marges("mainBox")
			X, Y = {100, 0, 25}, {0, -20, 0}
			self.panel.main = self:addPanelElementItem("menu", nil, self:setPosition({"TOPLEFT", VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), "Frame")

			X, Y = {VProperties.padding.w + X[1], 0 + X[2], VProperties.nextItemPos.w + X[3]}, {0 + Y[2], Y[2], Y[3]}
			for k, v in pairs(Const.MenuButtons) do
				obj = Const.MenuButtons
				local item = Const[obj[k][1]]
				local name = "mainElement" .. obj[k][1]
				if obj[k][1] == "Options" then
					local keep = Y[1]
					for k2, v2 in pairs(Const[obj[k][1]]) do
						self.panel[name .. k2] = self:addPanelElementSingleItem(name .. k2, item[k2], self:setPosition({"TOPLEFT",  VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), item[k2][3], VProperties.textSize, {"panel", "main"})
						Y[1] = Y[1] + Y[2]
						self.panel[name .. k2]:Hide()
					end
					Y[1] = keep
				else
					self.panel[name] = self:addPanelElementItem(name, item, self:setPosition({"TOPLEFT",  VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), "Frame", VProperties.textSize, {"panel", "main"})
				end
				if k ~= 1 and obj[k][1] ~= "Options" then
					self.panel[name]:Hide()
				end
			end
        end
    end)
end

function MainM:MenuButtonNavAction(switch)
	local obj = Const.MenuButtons
	switch = switch or obj[1][1]
	for k, v in pairs(obj) do
		if obj[k][1] == switch then 
			if obj[k][1] == "Options" then
				for k2 in pairs(Const[obj[k][1]]) do
					self.panel["mainElement" .. obj[k][1] .. k2]:Show()
				end
			else
			self.panel["mainElement" .. obj[k][1]]:Show()
			end
		else 
			if obj[k][1] == "Options" then
				for k2 in pairs(Const[obj[k][1]]) do
					self.panel["mainElement" .. obj[k][1] .. k2]:Hide()
				end
			else
			self.panel["mainElement" .. obj[k][1]]:Hide()
			end
		end
	end
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
		self.p.w = panel:GetWidth()
		self.p.h = panel:GetHeight()
		VProperties:update()
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
	f:SetAlpha(0.2)
	local t = f:CreateFontString(nil, "OVERLAY")
	t:SetFont(OptInt:get("font"), textSpacing[2] or 11)
	t:SetPoint("TOP", 0, 0)
	t:SetText("x")
	
	
	f.fontString = t
	
	f:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
    f:SetScript("OnLeave", function(self) self:SetAlpha(0.2) end)

	f:SetScript("OnClick", function () self.panel:Hide(); self.isShown = false; return end) 
	return f
end

function MainM:appendResizeBorder(textSpacing)
	local b = CreateFrame("Button", nil, self.panel)
	b:EnableMouse(true)
	b:SetSize(textSpacing[2], 20)
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

function MainM:addPanelElementItem(name, item, position, elemtype, textSpacing, parentFrame)
	parentFrame = (parentFrame ~= nil and #parentFrame == 2 and self[parentFrame[1]][parentFrame[2]]) or self.panel
	local f = CreateFrame("Frame", name, parentFrame)
	f:SetSize(position[2], position[3])
	f:SetPoint(position[1], 0, 0)
	self:displayMenuElements(position[4], position[5], item, f, textSpacing, name)
	return f
end

function MainM:addPanelElementSingleItem(name, item, position, elemtype, textSpacing, parentFrame)
	parentFrame = (parentFrame ~= nil and #parentFrame == 2 and self[parentFrame[1]][parentFrame[2]]) or self.panel
	local X, Y = position[4], position[5]
	local f, saved = nil, nil
	if GTConfigs[item[1]] ~= nil then
		saved = GTConfigs[item[1]]
	end
	if elemtype == "EditBox" then
		f = CreateFrame("EditBox", nil, parentFrame, "InputBoxTemplate")
		f:SetFont(OptInt:get("font"), textSpacing[2] or 11, "")
		f:SetNumeric(true)
		f:SetNumber(saved ~= nil and saved or item[4])
		f:SetFrameStrata("LOW")
		f:SetSize(15, 15)
		f:SetScript("OnEditFocusLost", function()
			GTConfigs[item[1]] = f:GetNumber()
		end)
	elseif elemtype == "CheckButton" then
		f = CreateFrame("CheckButton", name, parentFrame, "ChatConfigCheckButtonTemplate")
		if saved ~= nil then item[4] = saved end
		f:SetChecked(saved ~= nil and saved)
		f:SetSize(15, 15)
		f:SetScript("OnClick", function()
			GTConfigs[item[1]] = f:GetChecked()
		end)
	elseif elemtype == "label" then
		f = CreateFrame("Frame", name, parentFrame)
		f:SetSize(position[2], position[3])
	elseif elemtype == "dropdown" then
		f = CreateFrame("Frame", name, parentFrame, "UIDropDownMenuTemplate")
		f:SetSize(position[2], position[3])
		UIDropDownMenu_SetWidth(f, position[2] / 2)
		UIDropDownMenu_Initialize(f, function(frame, level)
			info = UIDropDownMenu_CreateInfo()
			for k, v in pairs(item[5][1]) do
				info.text, info.value, info.checked = v, k, false
				info.menuList = v
				info.func = function()
					UIDropDownMenu_SetSelectedValue(f, k)
					GTConfigs[item[1]] = UIDropDownMenu_GetSelectedValue(f, k)
				end
				UIDropDownMenu_AddButton(info)
			end
		end)
		UIDropDownMenu_SetSelectedValue(f, saved ~= nil and saved or item[4])
	end
	f:SetPoint(position[1], X[1], Y[1])
	local l = f:CreateFontString(nil, "OVERLAY")
	l:SetFont(OptInt:get("font"), textSpacing[2] or 11)
	l:SetPoint(position[1], elemtype == "label" and 0 or X[1], 0)
	l:SetText(item[2][1])

	return f
end

function MainM:addPanelSingleButton(name, item, position, textSpacing, parentFrame)
	parentFrame = (parentFrame ~= nil and #parentFrame == 2 and self[parentFrame[1]][parentFrame[2]]) or self.panel
	local X, Y = position[4], position[5]

	local f = CreateFrame("Button", name, parentFrame)
	f:SetPoint(position[1], X[1], Y[1])
	f:SetSize(100, 11)
	f:SetAlpha(0.2)
	
	local t = f:CreateFontString(nil, "OVERLAY")
	t:SetFont(OptInt:get("font"), textSpacing[2] or 11)
	t:SetPoint(position[1], X[1])
	t:SetText(item[2])
	
	f:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
    f:SetScript("OnLeave", function(self) self:SetAlpha(0.2) end)
	f:SetScript("OnClick", function () IntFns:getFn(item[1])() end) 
	f.fontString = t

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
				local linetext = nil
				linetext = frame:CreateFontString(nil, "OVERLAY")
				linetext:SetFont(OptInt:get("font"), textSpacing[2] or 11)
				linetext:SetJustifyH("left")
				linetext:SetPoint("TOPLEFT", X[1], Y[1])
				linetext:SetText(value)
				
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
	if item ~= nil then
		for k in pairs(item) do 
			if type(item[k]) == "table" then
				createElement(k, item[k][1], item[k][2])
			else
				createElement(k, item[k])
			end
		end
	end


	return frame
end
--InterfaceOptions_AddCategory(frame)

-- This function allows us to create quickly objects with a command line in the constant, like drawing a line
function MainM:elementCommand(frame, value, X, Y)
	local l = nil
	return  GeneralM:case(string.find(value, "%%drawLine") ~= nil, function ()
			l = frame:CreateLine()
			local width = (VProperties.mainBox.w)
			l:SetColorTexture(1, 1, 1, 1)
			l:SetStartPoint("TOP", X[1], Y[1])
			l:SetEndPoint("TOP", X[1] + (width * 0.8), Y[1])
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


