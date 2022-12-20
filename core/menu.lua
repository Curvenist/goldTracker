Menu = {
    options = true,
    optVal = nil,
    panel = nil
}

function Menu:main()
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(___, event, addonname)
        if addonname == "walletTool" then
            self.panel = CreateFrame("Frame")
            self.panel.name = "Bank Account"
            self:intializeStructure()
        end
    end)
    

end

function Menu:intializeStructure()
    -- current issue with Exchange, we need to retrieve the specific instance we
    -- set up to make the code works
    local x, y = 0, -20
    -- on voit les données mais il faut un système pour que la donnée soit chargée dynamiquement, cad il faut que income & co
    -- soit chargé avec les données de l'Exchange en temps réel, et non de façon figée
    local frame = self.panel
    frame.fontStrings = {}
	-- Why Const["Exchange"] doesn't work?
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

	InterfaceOptions_AddCategory(frame)
end

