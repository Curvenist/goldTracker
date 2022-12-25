Stats = {
	calculation = 0, -- just a transport for variables
	compareCalculation = {}
}
function Stats:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
  end

function Stats:main()
    
end
-- Values are constructed as array of values, what's positive is an earning, what's negative is a spending
-- ie Values = {5, 10, -7, -2, 4}



function Stats:setCalculation(Value)
	self.calculation = Value
end

function Stats:incrementCalculation(Value)
	self.calculation = self.calculation + Value
end

function Stats:getCalculation()
	return self.calculation
end

function Stats:setCompareCalculation(Value, perfn)
	self.compareCalculation[perfn] = Value
end

function Stats:incrementCompareCalculation(Value, perfn)
	self.compareCalculation[perfn] = self.compareCalculation[perfn] + Value
end

function Stats:getCompareCalculation()
	return self.compareCalculation
end

function Stats:isPair(value)
	if math.ceil(value / 2) ~= value / 2 then
		return true
	end
	return false
end

function Stats:performance(Values) -- a performance returns a variation between data
    Values = Values or {}
	self:setCalculation(0)
	for k, v in pairs(Values) do
		if type(Values[k]) == "table" then
			for ka, va in ipairs(Values[k]) do
				self:incrementCalculation(va)
			end
		else
			self:incrementCalculation(v)
		end
	end
	return
end

-- functions for basic calculating (number to number) 
-- @each returns objects

function Stats:rating(Values) 
    Values = Values or {}
	local rating = {
		num = 0, denom = 0
	}
	for k, v in pairs(Values) do
		self:setCompareCalculation(0, k)
		if type(Values[k]) == "table" then
			for ka, va in ipairs(Values[k]) do
				self:incrementCalculation(va, k)
			end
		else
			self:incrementCalculation(v, k)
		end
	end
	local i = 1
	for k, v in pairs(self:getCompareCalculation()) do
		if self:isPair(i) then
			rating.denom = rating.denom + self:getCompareCalculation()[k]
		else
			rating.num = rating.num + self:getCompareCalculation()[k]
		end
		i = i + 1
	end
	return ((rating.num / rating.denom) - 1) * 100
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