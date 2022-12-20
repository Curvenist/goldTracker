-- stats refers to methods calculating data over days / weeks / months

DAY = "1"
WEEK = "2"
MONTH = "3"
YEAR = "4"

Stats = {
    result = {
        t = nil, -- enum DAY / WEEK etc
        r = nil,
    }

}

function Stats:main()
    
end

function Stats:performance(income, spending, netvalue) -- a performance returns a variation between data
    spending = spending or 0
    netvalue = netvalue or 0
    -- income - spending + netvalue
    local calc = income - spending + netvalue
    self.result = {
        t = 1,
        r = calc
    }
    return self.result
end

-- functions for basic calculating (number to number) 
-- @each returns objects

function Stats:rating(income, spending, netvalue) 
    netvalue = netvalue or 0
    spending = spending or 0
    local calc = self:performance(income, spending, netvalue)
    return result
end

function Stats:average(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0

    return result
end

function Stats:stdDerivation(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0

    return result
end


function Stats:minPerf(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0

    return result
end

function Stats:MaxPerf(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0


    return result
end

-- functions for advanded calculating (dataObj to dataObj)

function Stats:ratingAdv(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0


    return result
end

function Stats:averageAdv(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0


    return result
end

function Stats:stdDerivationAdv(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0


    return result
end


function Stats:minPerfAdv(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0


    return result
end

function Stats:MaxPerfAdv(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0

    return result
end