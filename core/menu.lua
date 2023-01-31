Menu = {
    options = true,
    optVal = nil,
    panel = nil,
	isShown = false
}

function Menu:main()
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(___, event, addonname)
        if addonname == "walletTool" then
			self:setupOverlay(addonname) --library

			self.panel = self:setupFrame("Bank Account")
			self.panel.texture = self:addTexture()
			self.panel:Hide()

			local f = CreateFrame("Button", nil, self.panel)
			f:SetSize("15", "15")
			f:SetPoint("TOPRIGHT", 0, 0)

			local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			t:SetPoint("TOP", 0, 0)
			t:SetText("x")
			f.fontString = t
			
			f:SetScript("OnClick", function () self.panel:Hide(); self.isShown = false; return end)

			self.panel.buttonClose = f
			
			self:intializeStructure()

			
        end
    end)

end

function Menu:setupOverlay(addonname)
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

function Menu:setupFrame(name)
	local panel = CreateFrame("Frame")
	panel.name = name

	panel:SetFrameStrata("BACKGROUND")
	panel:SetWidth("400")
	panel:SetHeight("150")
	panel:EnableKeyboard()
	panel:SetPropagateKeyboardInput(true)
	panel:SetScript("OnKeyDown", function (arg, key) 
		if key == "ESCAPE" then
			self.panel:Hide(); self.isShown = false;
		end end)

	panel:SetPoint("Center", 0, 0)

	return panel
end

function Menu:addTexture()
	local t = self.panel:CreateTexture(nil, "BACKGROUND")
	t:SetAllPoints()
	t:SetColorTexture(0, 0, 0, 0.5)
	return t
end

function Menu:intializeStructure()
    -- current issue with Exchange, we need to retrieve the specific instance we
    -- set up to make the code works
    local x, y = 0, -20
    local frame = self.panel
    frame.fontStrings = {}
    for k, v in ipairs(Const.Exchange) do 
		local key = Const.Exchange[k][1]
		local value = Const.Exchange[k][2]
        local linetext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        linetext:SetPoint("TOPLEFT", x, y)
        linetext:SetText(value)
        frame.fontStrings[key .. "Text"] = linetext
        local linevalue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        linevalue:SetPoint("TOPLEFT", x + 300, y)
        frame.fontStrings[key] = linevalue
        y = y - 20
    end

	
	--InterfaceOptions_AddCategory(frame)
end

