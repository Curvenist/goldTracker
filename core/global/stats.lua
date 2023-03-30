Stats = {
	calculation = {}, -- just a transport for variables	
	simpleCalc = 0,
	division = {
		num = 0, denom = 0
	}
}
function Stats:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Stats:constr()
    self.calculation = {}
	self.simpleCalc = 0
	self.division = {
		num = 0, denom = 0
	}
end
-- Values are constructed as array of values, what's positive is an earning, what's negative is a spending
-- ie Values = {5, 10, -7, -2, 4}

-- REVIEWED JANUARY :
-- Vals can be both negatives and positives, depends if we're calculating : result (both profits and losses), profits, losses
-- vals = {5, 10, -5, ...} or {-10, -20, -30, ...} or {10, 20, 30, ...} etc...
-- dayX, dayY, ... are arrays of values, concatenation of array vals
-- Values format is = {dayX{Vals}, dayY(Vals), ...}
-- Also = {Vals}


function Stats:setCalculation(Value, perfn)
	self.calculation[perfn] = Value
end

function Stats:incrementCalculation(Value, perfn)
	self.calculation[perfn] = self.calculation[perfn] + Value
end

function Stats:makeCalculation(Value, operator, perfn)
	return load("self.calculation[perfn] = self.calculation[perfn]" .. operator .. Value)()
end

function Stats:getCalculation(index)
	if index ~= nil then
		return self.calculation[index]
	end
	return self.calculation
end


function Stats:setSimpleCalculation(Value)
	self.simpleCalc = Value
end

function Stats:incrementSimpleCalculation(Value)
	self.simpleCalc = self.simpleCalc + Value
end

function Stats:getSimpleCalculation()
	return self.simpleCalc
end


function Stats:setNum(Value)
	self.division.num = Value
end

function Stats:incrementNum(Value)
	self.division.num = self.division.num + Value
end

function Stats:getNum()
	return self.division.num
end


function Stats:setDenom(Value)
	self.division.denom = Value
end

function Stats:incrementDenom(Value)
	self.division.denom = self.division.denom + Value
end

function Stats:getDenom()
	return self.division.denom
end


-- end of incremental result calculation

function Stats:isPair(value)
	if math.ceil(value / 2) ~= value / 2 then
		return true
	end
	return false
end


-- data will be clustered into arrays to separate days  : {d1, d2...} will be the format
function Stats:performance(Values, index) -- a performance returns a variation between data, check review in JANUARY*
    Values, index = Values or {}, index or nil
	self:resetStats()
	self:getCalculation()
	for k, v in pairs(Values) do
		self:setCalculation(0, k)
		if type(Values[k]) == "table" then
			for ka, va in pairs(Values[k]) do
				self:incrementCalculation(va, k)
			end
		else
			self:incrementCalculation(v, k)
		end
	end
	self:getCalculation()
end

-- unCluster = we regoup values in array, ie : {{10}, {15} ...} instead of arrays {{10, 11}, {25, 30, 25} ...}
function Stats:performanceUncluster()
	self:setSimpleCalculation(0)
	for k, v in pairs(self:getCalculation()) do
		if type(self:getCalculation(k)) == "table" then
			for ka, va in pairs(self:getCalculation(k)) do
				self:incrementSimpleCalculation(va)
			end	
		else
			self:incrementSimpleCalculation(v)
		end
	end
end

-- data will be unclustered into arrays to separate days  : returns a number
function Stats:plainPerformance(Values)
	self:performance(Values)
	self:performanceUncluster()
	return self:getSimpleCalculation()
end

-- functions for basic calculating (number to number) 
-- @each returns objects

--[[
Sample idea : benefit for n
1  = 10
n - 1  = 15
n - 2 = 20

we compare ((10 / 15) - 1) * 100
]]--

function Stats:rating(numerator, denominator, mult)
    numerator, denominator, mult = numerator or {0}, denominator or {0}, mult or OptStats:get("mult") or 100
	local Values = {numerator, denominator}
	self:resetStats()

	for k, v in pairs(Values) do
		self:setCalculation(0, k) -- initialize table of values incremental array[valsn[], valsn-1[]] or just array[benefitn, benefitn-1]
		if type(Values[k]) == "table" then
			for ka, va in ipairs(Values[k]) do
				self:incrementCalculation(va, k)
			end
		else
			self:incrementCalculation(v, k)
		end
	end
	self:incrementNum(self:getCalculation(1))
	self:incrementDenom(self:getCalculation(2))

	if self:getDenom() == 0 then 
		return 0
	end

	if mult + ((self:getNum() - self:getDenom()) / math.abs(self:getDenom())) * mult > mult then
		return ((self:getNum() / self:getDenom()) * mult) - mult
	end
	return mult + (((self:getNum() - self:getDenom()) / math.abs(self:getDenom())) * mult)

end

function Stats:ratingDecoration(val1, val2, mult)
	val1, val2, mult = 
	 val1 and self:setNum(val1) or self:getNum(),
	 val2 and self:setDenom(val2) or self:getDenom(),
	 mult or OptStats:get("mult") or 100
	local i = nil
	if mult ~= 100 then i = 4 end
	if self:getNum() == 0 or self:getDenom() == 0 then 
		return {0, i or 1}
	end
	if mult + ((self:getNum() - self:getDenom()) / math.abs(self:getDenom())) * mult > mult then
		return {((self:getNum() / self:getDenom()) * mult) - mult, i or 3}
	end
	return {((self:getNum() / self:getDenom())) * mult, i or 2}
end


function Stats:average(Values)
    Values = Values or {}
	self:resetStats()
	self:performance(Values)
	self:performanceUncluster()

    return self:getSimpleCalculation() / #Values
end


function Stats:variance(Values)
    Values = Values or {}
	self:resetStats()
	self:performance(Values)
	for k, v in pairs(self:getCalculation()) do
		self:incrementSimpleCalculation((v - self:average(Values))^2) 
	end

	return (self:getSimpleCalculation() / #Values)
end

function Stats:stdDeviation(Values)
    Values = Values or {}
	self:resetStats()

    return self:variance(Values)^(1/2)
end


function Stats:minMaxPerf(Values, isMin)
    Values = Values or {}
	self:performance(Values)
	local checkVal, checkKey, i = 0, 0, 1
	for k, v in pairs(Stats:getCalculation()) do
		if i == 1 then
			checkKey, checkVal = k, v
		end
		if isMin and v < checkVal then
			checkKey, checkVal = k, v
		elseif not isMin and v > checkVal then
			checkKey, checkVal = k, v
		end
		i = i + 1
	end
    return {checkKey, checkVal}
end

function Stats:MaxPerfAdv(income, spending, netvalue)
    netvalue = netvalue or 0
    spending = spending or 0

    return result
end

function Stats:resetStats()
	self.calculation = {}
	self.simpleCalc = 0
	self.division = {
		num = 0, denom = 0
	}
end
