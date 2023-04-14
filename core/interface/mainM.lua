MainM = {
	options = true,
    optVal = nil,
    panel = nil,
	isShown = {container = true, reduced = true},

    p = {
		w = 300,
		h = 160,
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

function MainM:loadStyle()
    local font = CreateFont("DSnormal")
    font:SetFont(OptInt:get("font"), 11, "")
end

VProperties = {}

function VProperties:get(index)
	if index ~= nil then
		return self[index]
	end
	return self
end

function VProperties:update()
    self.interface = {w = MainM:getWidth(), h = MainM:getHeight() * 2} --in the interface panel
	self.container = {w = MainM:getWidth(), h = MainM:getHeight()}
	self.menuBox = {w = MainM:getWidth() / 4, h = MainM:getHeight()}
	self.mainBox = {w = (MainM:getWidth() - (MainM:getWidth() / 1.5)), h = MainM:getHeight()}
	self.padding = {w = MainM:getWidth() * 0.05, h = MainM:getHeight() * -0.05} -- margins are 5% of the max size
	self.reduced = {w = MainM:getWidth() / 4, h = MainM:getHeight() / 2}
	self.textSize = {false, MainM.textSize(MainM.p.h)}
end

function VProperties:marges(index)
	self.margin = {w = self:get(index)['w'] * 0.1, h = self:get(index)['h'] * -0.1} -- this a global margin of 10%
	self.steps = {w = self:get(index)['w'] * 0, h = self:get(index)['h'] * -0.1} -- next iteration element position
	self.nextItemPos = {w = self:get(index)['w'] * 0.8, h = self:get(index)['h'] * 0} -- in case we have at least 2 values on same line, like label / value
end

function MainM:dynamicArrayExtent(obj, frame)
    GTFr = frame or self
	local arr = ""
	for k, v in pairs(obj) do
		arr = arr .. "[\"" .. v .. "\"]"
	end
	return loadstring("return GTFr" .. arr)()
end

function MainM:main()
	self:loadStyle()
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(___, event, addonname)
        if addonname == "goldTracker" then
			VProperties:update()
			self:setupOverlay(addonname)

			-- todo : we should really think about squasing all the options there. Remember, firt we need a frame setup then adding the element to the frame
			self.minPanel = self:setupFrame("reduced", "reduced", {false, true, true})
			self.minPanel.texture = self:addTexture({"minPanel"})
			self.minPanel.buttonResize = self:appendResizeBorder({"minPanel"})
			VProperties:marges("mainBox")
			X, Y = {0, 0, 100}, {0, -20, 0}
			self.minPanel.main = self:addPanelElementItem("reducedData", Const.TrackerReduced, self:setPosition({"TOPLEFT",  VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), "Frame", {"minPanel"})
			self.minPanel:Hide()

			self.panel = self:setupFrame("main", "container", {true, true, true})
			self.panel.texture = self:addTexture({"panel"})
			self.panel.buttonClose = self:appendCloseBox()
			self.panel.buttonResize = self:appendResizeBorder({"panel"})

			--@todo here gonna add buttons for options
			VProperties:marges("menuBox")
			local X, Y, obj = {VProperties.padding.w, 0, 0}, {0, VProperties.steps.h, 0}, nil
			self.panel.menu = self:addPanelElementItem("menu", nil, self:setPosition({"TOPLEFT", VProperties.menuBox.w, VProperties.menuBox.h, X, Y}), "Frame")
			
			self.panel.menuElement = {}
			X, Y = {VProperties.padding.w, 0, VProperties.nextItemPos.w}, {0, -20, 0}
			for k, v in pairs(Const.MenuButtons) do
				Y[1] = Y[1] + Y[2]
				self.panel.menuElement[k] = self:addPanelSingleButton("menuElement" .. k, Const.MenuButtons[k], self:setPosition({"TOPLEFT", VProperties.menuBox.w, VProperties.menuBox.h, X, Y}), {"panel", "menu"})
			end

			-- MainBOX PART, be sure to create a scrollFrame first
			VProperties:marges("mainBox")
			X, Y = {100, 0, 25}, {0, -20, 0}
			self.panel.main = self:addPanelElementItem("menu", nil, self:setPosition({"TOPLEFT", VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), "ScrollFrame")
			

			X, Y = {VProperties.padding.w + X[1], 0 + X[2], VProperties.nextItemPos.w + X[3]}, {0 + Y[2], Y[2], Y[3]}
			for k, v in pairs(Const.MenuButtons) do
				obj = Const.MenuButtons
				local item = Const[obj[k][1]]
				local name = "content" .. obj[k][1]
				if obj[k][1] == "Options" then
					local keep = Y[1]
					for k2, v2 in pairs(Const[obj[k][1]]) do
						self.panel[name .. k2] = self:addPanelElementSingleItem(name .. k2, item[k2], self:setPosition({"TOPLEFT",  VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), item[k2][3], {"panel", "main"})
						self.panel[name .. k2]:Hide()
						Y[1] = Y[1] + Y[2]
					end
					Y[1] = keep
				else
					self.panel[name] = self:addPanelElementItem(name, item, self:setPosition({"TOPLEFT",  VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), "Frame", {"panel", "main"})
				end
				if obj[k][1] ~= "Options" then
					if k ~= 1 then
						self.panel[name]:Hide()
					end
					if self.panel[name]:IsShown() then
						self:AppendScroll(self.panel.main, self.panel[name])
					end
				end
			
					
			end
        end
    end)
end

function MainM:AppendScroll(parentFrame, childFrame)
	parentFrame:SetVerticalScroll(0)
	parentFrame:SetHorizontalScroll(0)
	parentFrame:SetScrollChild(childFrame)
end

function MainM:MenuButtonNavAction(switch)
	local obj = Const.MenuButtons
	switch = switch or obj[1][1]
	for k, v in pairs(obj) do
		local item = obj[k][1]
		if item == switch then 
			if item == "Options" then
				for k2 in pairs(Const[item]) do
					self.panel["content" .. item .. k2]:Show()
				end
			else
			self.panel["content" .. item]:Show()
			self:AppendScroll(self.panel.main, self.panel["content" .. item])
			end
		else 
			if item == "Options" then
				for k2 in pairs(Const[item]) do
					self.panel["content" .. item .. k2]:Hide()
				end
			else
			self.panel["content" .. item]:Hide()
			end
		end
	end
end

function MainM:setupOverlay(addonname)
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject(addonname, {
		text = addonname,		
		icon = "Interface\\icons\\inv_misc_bag_01",	
		OnClick = function(s, btn)
					if self.panel:IsShown() then self.panel:Hide();
					elseif not self.panel:IsShown() then self.panel:Show() end
					return
				end
		})
	local icon = LibStub("LibDBIcon-1.0", true)
	icon:Register(addonname, miniButton)
end

--@todo we should add options in order to change size, colors etc!

function MainM:setupFrame(name, obj, options)
	local width, height = VProperties[obj].w, VProperties[obj].h
	local panel = CreateFrame("Frame", name)
	panel:SetFrameStrata("BACKGROUND")
	panel:SetPoint("CENTER")
	panel:SetWidth(width)
	panel:SetHeight(height)
	panel:EnableKeyboard(true)
	panel:EnableMouse(true)
	panel:SetPropagateKeyboardInput(true)
	
	panel:RegisterForDrag("LeftButton")
	if options[1] == true then -- escape close
		panel:SetScript("OnKeyDown", function (arg, key) 
		if key == "ESCAPE" then
			panel:Hide();
		end 
		end)
	end
	if options[2] == true then -- draggable
		panel:SetMovable(true)
		panel:SetScript("OnDragStart", function (arg, key) 
			arg:StartMoving()
		end)
		panel:SetScript("OnDragStop", function (arg, key) 
			arg:StopMovingOrSizing()
			self.p.w = panel:GetWidth()
			self.p.h = panel:GetHeight()
			VProperties:update()
		end)
		panel:SetUserPlaced(true)
	end
	if options[3] == true then -- resize
		panel:SetResizable(true)
		panel:SetResizeBounds(width / 2, height / 2, width * 2, height * 2)
	end
	panel:SetPoint("CENTER", 0, 0)
	return panel
end


function MainM:addTexture(frame, hB)
	frame = (frame ~= nil and #frame >= 1 and self:dynamicArrayExtent(frame, self)) or self.panel
	local t = frame:CreateTexture(nil, "BACKGROUND")
	t:SetAllPoints()
	t:SetColorTexture(0, 0, 0, 0.3)
	if type(hB) == "table" then
		self:addBorder(frame, hB)
	end
	return t
end

function MainM:addBorder(frame, hB)
	local fbord = CreateFrame("Frame", nil, frame)
	fbord:SetAllPoints(frame)
	fbord:SetFrameStrata("BACKGROUND")
	fbord:SetFrameLevel(1)
	if hB[1] == 1 then -- how setpoint work, we always start as diagonal to bottom left to top rigth, we just need to swap to correct position
		fbord.top = fbord:CreateTexture(nil, "BORDER")
		fbord.top:SetPoint("BOTTOMLEFT", fbord, "TOPLEFT", 0, 1)
		fbord.top:SetPoint("TOPRIGHT", fbord, "TOPRIGHT", 0, 0)
		fbord.top:SetColorTexture(0.7, 0.7, 0.7, 1)
	end	
	if hB[2] == 1 then
		fbord.right = fbord:CreateTexture(nil, "BORDER")
		fbord.right:SetPoint("BOTTOMLEFT", fbord, "BOTTOMRIGHT", 0, 1)
		fbord.right:SetPoint("TOPRIGHT", fbord, "TOPRIGHT", 1, 0)
		fbord.right:SetColorTexture(0.7, 0.7, 0.7, 1)
	end
	if hB[3] == 1 then
		fbord.bot = fbord:CreateTexture(nil, "BORDER")
		fbord.bot:SetPoint("BOTTOMLEFT", fbord, "BOTTOMLEFT", 1, 0)
		fbord.bot:SetPoint("TOPRIGHT", fbord, "BOTTOMRIGHT", 0, 1)
		fbord.bot:SetColorTexture(0.7, 0.7, 0.7, 1)
	end
	if hB[4] == 1 then
		fbord.left = fbord:CreateTexture(nil, "BORDER")
		fbord.left:SetPoint("BOTTOMLEFT", fbord, "BOTTOMLEFT", 0, 0)
		fbord.left:SetPoint("TOPRIGHT", fbord, "TOPLEFT", 1, 0)
		fbord.left:SetColorTexture(0.7, 0.7, 0.7, 1)
	end
	return fbord
end

function MainM:appendCloseBox(frame)
	frame = (frame ~= nil and #frame >= 1 and self:dynamicArrayExtent(frame, self)) or self.panel
	--frame = (frame ~= nil and #frame == 1 and self[frame[1]]) or self.panel
	local f = CreateFrame("Button", nil, self.panel)
	f:SetSize(15, 15)
	f:SetPoint("TOPRIGHT", 0, 0)
	f:SetNormalTexture("Interface\\buttons\\ui-panel-hidebutton-up")
	f:SetHighlightTexture("Interface\\buttons\\ui-panel-minimizebutton-Highlight")
	f:SetPushedTexture("Interface\\buttons\\ui-panel-hidebutton-down")
	f:SetScript("OnClick", function () frame:Hide() return end) 
	return f
end

function MainM:appendResizeBorder(frame)
	frame = (frame ~= nil and #frame >= 1 and self:dynamicArrayExtent(frame, self)) or self.panel
	--frame = (frame ~= nil and #frame == 1 and self[frame[1]]) or self.panel
	local b = CreateFrame("Button", nil, frame)
	b:EnableMouse(true)
	b:SetSize(15, 15)
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

function MainM:addPanelElementItem(name, item, position, elemtype, parentFrame)
	parentFrame = (parentFrame ~= nil and #parentFrame >= 1 and self:dynamicArrayExtent(parentFrame, self)) or self.panel
	--parentFrame = (parentFrame ~= nil and #parentFrame == 2 and self[parentFrame[1]][parentFrame[2]]) or self.panel
	local f = nil
	local X, Y = position[4], position[5]
	if elemtype == "Frame" then
		f = CreateFrame("Frame", name, parentFrame)
		f:SetSize(position[2], position[3])
		f:SetPoint(position[1], 0, 0)
		self:displayMenuElements(position[4], position[5], item, f, name)
	elseif elemtype == "ScrollFrame" then -- if we have a scroll frame, make sure our next element is child of if in order to append the SetChildProperty to the parentFrame
		f = CreateFrame("ScrollFrame", nil, parentFrame)
		f:SetPoint("TOPLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", 0, 0)
		f:SetScript("OnMouseWheel", function(_, delta)
			local val = f:GetVerticalScroll() + delta * Y[2]
			if val < 0 then
				val = 0
			elseif val > f:GetVerticalScrollRange() then
				val = f:GetVerticalScrollRange()
			end
			f:SetVerticalScroll(val)
		end)
	end
	return f
end

function MainM:addPanelElementSingleItem(name, item, position, elemtype, parentFrame)
	parentFrame = (parentFrame ~= nil and #parentFrame >= 1 and self:dynamicArrayExtent(parentFrame, self)) or self.panel
	--parentFrame = (parentFrame ~= nil and #parentFrame == 2 and self[parentFrame[1]][parentFrame[2]]) or self.panel
	local X, Y = position[4], position[5]
	local f, saved = nil, nil
	if GTConfigs[item[1]] ~= nil then
		saved = GTConfigs[item[1]]
	end
	if elemtype == "EditBox" then
		f = CreateFrame("EditBox", nil, parentFrame, "InputBoxTemplate")
		f:SetFont(OptInt:get("font"), 11, "")
		f:SetNumeric(true)
		f:SetNumber(saved ~= nil and saved or item[4])
		f:SetAutoFocus(false)
		f:SetSize(15, 10)
		f:SetScript("OnEditFocusGained", function(s) 
		end)
		f:SetScript("OnEditFocusLost", function(s)
			GTConfigs[item[1]] = s:GetNumber()
			s:ClearFocus()
			s:HighlightText(0, 0)
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
		-- IntFns:CreateRadioDropDown(f, item[5][1])

		UIDropDownMenu_Initialize(f, function(frame, level)
			info = UIDropDownMenu_CreateInfo()
			for k, v in pairs(item[5][1]) do
				info.text, info.value, info.checked = v, k, false
				info.menuList = v
				info.minWidth = 80
				info.func = function()
					UIDropDownMenu_SetText(f, v)
					UIDropDownMenu_SetSelectedValue(f, k)
					GTConfigs[item[1]] = UIDropDownMenu_GetSelectedValue(f, k)
				end
				UIDropDownMenu_AddButton(info)
			end

		end)
		UIDropDownMenu_SetSelectedValue(f, saved ~= nil and saved or item[4])
		IntFns:ModifyDropDownTemplate(f)
	end
	f:SetPoint(position[1], X[1] + X[1], Y[1])
	local l = f:CreateFontString(nil, "OVERLAY", "DSnormal")
	l:SetPoint(position[1], -X[1], 0)
	l:SetText(item[2][1])

	return f
end

function MainM:addPanelSingleButton(name, item, position, parentFrame)
	parentFrame = (parentFrame ~= nil and #parentFrame >= 1 and self:dynamicArrayExtent(parentFrame, self)) or self.panel
	--parentFrame = (parentFrame ~= nil and #parentFrame == 2 and self[parentFrame[1]][parentFrame[2]]) or self.panel
	local X, Y = position[4], position[5]

	local f = CreateFrame("Button", name, parentFrame)
	f:SetPoint(position[1], X[1], Y[1])
	f:SetSize(100, 15)
	f:SetAlpha(0.2)
	
	local t = f:CreateFontString(nil, "OVERLAY", "DSnormal")
	t:SetPoint(position[1], X[1])
	t:SetText(item[2])
	
	f:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
    f:SetScript("OnLeave", function(self) self:SetAlpha(0.2) end)
	f:SetScript("OnClick", function () IntFns:getFn(item[1])() end) 
	f.fontString = t

	return f
end


function MainM:addPanelElementMethod(name, method, position, type, script)
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
function MainM:displayMenuElements(X, Y, item, parentFrame, name)
    local X, Y = X or {0, 0, 100}, Y or {-20, -20, 0}
    parentFrame = parentFrame or self.panel
    parentFrame.fontStrings = {}
	parentFrame.elems = {}

	local createElement = function (increment, key, value) 
		parentFrame.elems[name] = self:elementCommand(parentFrame, key, X, Y)
		if type(parentFrame.elems[name]) ~= "table" then
			if value ~= nil then
				local linetext = nil
				linetext = parentFrame:CreateFontString(nil, "OVERLAY", "DSnormal")
				linetext:SetJustifyH("left")
				linetext:SetPoint("TOPLEFT", X[1], Y[1])
				linetext:SetText(value)
				parentFrame.fontStrings[key .. increment .. "Text"] = linetext
			end
				local linevalue = parentFrame:CreateFontString(nil, "OVERLAY", "DSnormal")
				linevalue:SetJustifyH("left")
				linevalue:SetPoint("TOPLEFT", X[1] + X[3], Y[1] + Y[3])
				parentFrame.fontStrings[key .. increment] = linevalue
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
	return parentFrame
end


-- This function allows us to create quickly objects with a command line in the constant, like drawing a line
function MainM:elementCommand(frame, value, X, Y)
	local l = nil
	return  GeneralM:case(string.find(value, "%%drawLine") ~= nil, function ()
			l = frame:CreateLine()
			local width = (VProperties.mainBox.w)
			l:SetColorTexture(0.7, 0.7, 0.7, 1)
			l:SetStartPoint("TOP", X[1], Y[1])
			l:SetEndPoint("TOP", X[1] + width, Y[1])
			l:SetThickness(1) end) or
			GeneralM:case(string.find(value, "%%br") ~= nil, function ()
				l = frame:CreateFontString(nil, "OVERLAY")
				l:SetPoint("TOPLEFT", X[1], Y[1])
			end)
			
			and l
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





-- self.interface = self:setupFrame("interface", "interface", {false, false, false})
-- self.interface.name = Const.CommonTranslations[3][2]
-- VProperties:marges("mainBox")
-- X, Y = {0, 0, 100}, {0, -20, 0}
-- for k, v in pairs(Const.Options) do
-- 	self.interface["option" .. k] = self:addPanelElementSingleItem("interface", Const.Options[k], self:setPosition({"TOPLEFT",  VProperties.mainBox.w, VProperties.mainBox.h, X, Y}), Const.Options[k][3], {"interface"})
-- 	Y[1] = Y[1] + Y[2]
-- end
-- InterfaceOptions_AddCategory(self.interface)