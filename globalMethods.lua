GlobalMethods = {
    test = nil
}

function GlobalMethods:timeChecker(sdate)
    local p = "(%d%d)(%d%d)(%d+)"
    local d, m, y = sdate:match(p)
    -- time is now converted, lets check how close it from our present date
    return time({
        year = y,
        month = m,
        day = d
    })
end