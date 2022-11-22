GlobalMethods = {
    test = nil
}

function GlobalMethods:timeChecker(sdate)
    local p = "(%d%d)(%d%d)(%d+)"
    local d, m, y = sdate:match(p)
    return time({
        year = y,
        month = m,
        day = d
    })
end