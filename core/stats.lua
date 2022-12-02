-- stats refers to methods calculating data over days / weeks / months


Stats = {
    ratingData = {
        performing = nil,
        ratingPerf = nil,
        ratingAverage = nil,
        ratingStdDerivation = nil,
        ratingMinPerf = nil,
        ratingMaxPerf = nil,
    }
    
    
}

function Stats:main()

end

function Stats:performance(income, spending, netvalue) -- a performance returns a variation between data
    spending = spending or 0
    netvalue = netvalue or 0

    return 
end

-- functions for basic calculating (number to number)

function Stats:rating(income, spending, netvalue)

end

function Stats:average(income, spending, netvalue)

end

function Stats:stdDerivation(income, spending, netvalue)

end


function Stats:minPerf(income, spending, netvalue)

end

function Stats:MaxPerf(income, spending, netvalue)

end

-- functions for advanded calculating (dataObj to dataObj)

function Stats:ratingAdv(income, spending, netvalue)

end

function Stats:averageAdv(income, spending, netvalue)

end

function Stats:stdDerivationAdv(income, spending, netvalue)

end


function Stats:minPerfAdv(income, spending, netvalue)

end

function Stats:MaxPerfAdv(income, spending, netvalue)

end