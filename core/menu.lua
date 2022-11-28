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
            self.panel.name = "BankOfSilvermoon"
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
    for k, v in pairs(Const) do
        local linetext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        linetext:SetPoint("TOPLEFT", x, y)
        linetext:SetText(v)
        frame.fontStrings[k .. "Text"] = linetext
        local linevalue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        linevalue:SetPoint("TOPLEFT", x + 300, y)
        frame.fontStrings[k] = linevalue
        y = y - 20
    end

	InterfaceOptions_AddCategory(frame)
end

