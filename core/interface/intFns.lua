

IntFns = {
    TrackerCurrent = function () MainM:MenuButtonNavAction("TrackerCurrent") end,
    Options = function () MainM:MenuButtonNavAction("Options") end,
    AdvancedStatOp = function () MainM:MenuButtonNavAction("AdvancedStatOp") end
    --{"graph", "Graphique"}
}

DropDownObj = {"Middle", "Right", "Left"}

function IntFns:getFn(index)
    return self[index]
end

function IntFns:CreateRadioDropDown(f, items)
    --need to create :
    --a frame hosting the selected value, the usual is left, middle, right
    --a frame hosting the button on the right
    --a frame hosting the list, we'll make it simple for now, no border
    --iterate throught to create objets
    local frame = f:CreateFrame("")
end

function IntFns:ModifyDropDownTemplate(f)

    f.Text:SetFont(OptInt:get("font"), 11, "")
    
    f.Left:SetColorTexture(0, 0, 0, 0.5)
    f.Middle:SetColorTexture(0, 0, 0, 0.5)
    f.Right:SetColorTexture(0, 0, 0, 0.5)
    
    f.Left:SetPoint("TOPLEFT", 0, 0)
    f.Middle:SetPoint("TOP", 0, 0)
    f.Right:SetPoint("TOP", 0, 0)
    
    f.Left:SetSize(0, 15)
    f.Middle:SetSize(80, 15)
    f.Right:SetSize(0, 15)
    
    

    for k, v in pairs(f) do
        print(k, v)
    end
    print("---")

    
    f.Button:SetPoint("TOPLEFT", 85, 0)
    f.Button:SetSize(15, 15)
    UIDropDownMenu_JustifyText(f, "LEFT")
    f.Text:SetPoint("TOPLEFT", 0, -2)

end