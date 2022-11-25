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
            print(addonname);
            if customMoney["Options"] ~= nil then
                self.optVal = customMoney["Options"] -- in case of options checked
            end
            self:intializeData()
        end
    end)

end

function Menu:intializeData()
    self.panel = CreateFrame("Frame")
    self.panel.name = "Bank of Silvermoon"
    local x, y = 0, -20

    local line = CreateFrame("Frame", nil, self.panel)
    line:SetPoint("TOPLEFT", x, y)
    line:SetText("test")



    InterfaceOptions_AddCategory(self.panel)
end

