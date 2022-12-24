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

--[[
	Values constuct must be an object and following an array of values
	Values : {
		"Positives" : {income},
		"Negatives" : {spending},
		"NetValues" : {netValues}
	}

]]--

-- functions for basic calculating (number to number) 
-- @each returns objects

function Stats:rating(Values) 
    Values = Values or {}

    return result
end

function Stats:performance(Values)
    Values = Values or {}

	return result
end

function Stats:average(Values)
    Values = Values or {}
    return result
end

function Stats:variance(Values)
    Values = Values or {}

	return result
end

function Stats:stdDeviation(Values)
    Values = Values or {}

    return result
end




function Stats:minPerf(Values)
    Values = Values or {}

    return result
end

function Stats:MaxPerf(Values)
    Values = Values or {}


    return result
end

-- functions for advanded calculating (dataObj to dataObj)

function Stats:ratingAdv(Values)
    Values = Values or {}


    return result
end

function Stats:averageAdv(Values)
    Values = Values or {}


    return result
end

function Stats:stdDerivationAdv(Values)
    Values = Values or {}


    return result
end


function Stats:minPerfAdv(Values)
    Values = Values or {}


    return result
end

function Stats:MaxPerfAdv(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0

    return result
end