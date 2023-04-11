

IntFns = {
    TrackerCurrent = function () MainM:MenuButtonNavAction("TrackerCurrent") end,
    Options = function () MainM:MenuButtonNavAction("Options") end,
    AdvancedStatOp = function () MainM:MenuButtonNavAction("AdvancedStatOp") end
    --{"graph", "Graphique"}
}


function IntFns:getFn(index)
    return self[index]
end

