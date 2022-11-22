globalMethods = {}

function globalMethods:timeChecker(sdate)
    local p = "(%d%d)(%d%d)(%d+)"
    local day, month, year = sdate:match(p)

    if not ydayear then
        return false
    end
    local newDate = string.format('%s-%s-%s 00:00:00', year, month, day)
    -- time is now converted, lets check how close it from our present date

    return os.time(newDate)
end