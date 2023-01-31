--[[
Name: LibMath
Revision: $Rev: 7 $
Author(s): Humbedooh
Description: Extended math library for Lua
License: MIT
]]

local rev = tonumber(("$Rev: 7 $"):match("(%d+)")) or 5000
if _G.__LibMath and _G.__LibMath.revision >= rev then return end
_G.__LibMath = { revision = rev}

-----------------------------------------------------------------------
-- [[ UPVALUES ]]--
-----------------------------------------------------------------------
local function assertx(...) local f = {...} for n=1, #f do assert(f[n]) end return ... end
local _G = _G
local upper, lower, sub, tonumber, type, error, select, floor, ceil, log, sqrt, pow, tan, cos, sin, pairs, sort, tinsert =
assertx(_G.string.upper, _G.string.lower, _G.string.sub, _G.tonumber, _G.type, _G.error,
 _G.select, _G.math.floor, _G.math.ceil, _G.math.log, _G.math.sqrt, _G.math.pow,
 _G.math.tan, _G.math.cos, _G.math.sin, _G.pairs, _G.table.sort, _G.table.insert)


-----------------------------------------------------------------------
--[[ MATH SET ]]--
-----------------------------------------------------------------------

--- Returns the sum of all numbers passed
-- @usage local sum = math.sum(1,2,3,4) assert(sum == 10) -- 1+2+3+4 = 10
function math.sum(...)
    local val = 0
    for k, v in pairs({...}) do
        val = val + (tonumber(v) or 0);
    end
    return val;
end

--- Returns the average (mean value) of the numbers passed.
-- @usage local avg = math.avg(1,2,3,4,5) assert(avg == 3) -- (1+2+3+4+5)/5 = 3
function math.avg(...)
    local val = 0;
    local num = 0;
    for k, v in pairs({...}) do
        val = val + (tonumber(v) or 0);
        if ( tonumber(v) ~= nil ) then
            num = num + 1;
        end
    end
    return val/num;
end

--- Returns the most frequently occurring number among those passed.
-- @usage local mode = math.mode(1,2,1,3,1,4) assert(mode == 1)
function math.mode(...)
    local vals = {...};
    local mode = {};
    sort(vals);
    for k, v in pairs(vals) do
        mode[v] = (mode[v] or 0) + 1;
    end
    local n = 0;
    local m = 0;
    for k, v in pairs(mode) do
        if ( v > n ) then n = v; m = k; end
    end
    return m;
end

--- Returns the median (the number in the middle of all the numbers sorted numerically)
-- @usage local med = math.median(1,5,2,4,3) assert(med == 3)
function math.median(...)
    local vals = {...};
    sort(vals);
    return vals[floor((#vals/2) + 0.5)] or 0;
end

--- Returns the k-th largest value among the numbers passed
-- @usage local largest = math.large(1,7,2,3,6,4,9,5) assert(largest == 9)
function math.large(k, ...)
    local vals = {...};
    sort(vals);
    return vals[#vals-(k-1)] or 0;
end
--- Returns the k-th smallest value among the numbers passed
-- @usage local smallest = math.small(4,5,3,6,2,8,1) assert(smallest == 1)
function math.small(k, ...)
    local vals = {...};
   sort(vals);
    return vals[k] or 0;
end

--- Returns the sum of all numbers that passes the statement (fx. ">25")
-- @usage local sum = math.sumif(">2.5", 1,2,3,4,5,6,7) assert(sum == 25)
function math.sumif(statement, ...)
    local vals = {...};
	local ret = 0;
	if ( type(statement) == "string" ) then
		local i = 1;
		if ( sub(statement,2,2) == "=" ) then i = 2; end
		local sign, number = sub(statement,1,i), tonumber(sub(statement,i+1));
		for k, v in pairs(vals) do
			if ( sign == '=' and v == number ) then ret = ret + v; end
			if ( sign == '>' and v > number ) then ret = ret + v; end
			if ( sign == '<' and v < number ) then ret = ret + v; end
			if ( sign == '>=' and v >= number ) then ret = ret + v; end
			if ( sign == '<=' and v <= number ) then ret = ret + v; end
			if ( sign == '!=' and v ~= number ) then ret = ret + v; end
		end
	end
	return ret;
end

--- Returns the total number of numbers passed that fits the statement (fx. ">= 4")
-- @usage local goodEggs = math.countif("<=4", 1,2,3,4,5,6) assert(goodEggs == 4)
function math.countif(statement, ...)
    local vals = {...};
	local ret = 0;
	if ( type(statement) == "string" ) then
		local i = 1;
		if ( sub(statement,2,2) == "=" ) then i = 2; end
		local sign, number = sub(statement,1,i), tonumber(sub(statement,i+1));
		for k, v in pairs(vals) do
			if ( sign == '=' and v == number ) then ret = ret + 1; end
			if ( sign == '>' and v > number ) then ret = ret + 1; end
			if ( sign == '<' and v < number ) then ret = ret + 1; end
			if ( sign == '>=' and v >= number ) then ret = ret + 1; end
			if ( sign == '<=' and v <= number ) then ret = ret + 1; end
			if ( sign == '!=' and v ~= number ) then ret = ret + 1; end
		end
	end
	return ret;
end

--- Returns -1 for numbers less than zero, +1 for numbers greater than zero and 0 for zero.
-- @usage local sign = math.sign(math.pi/-3000) assert(sign == -1)
function math.sign(val)
    return ( val > 0 and 1 ) or ( val < 0 and -1 ) or 0;
end

--- Returns the total number of values passed
-- @usage local count = math.count(1,2,3,4,5,6) assert(count == 6)
function math.count (...)
	return select("#", ...) or 0;
end

--- Returns the logarithm of the specified number to either ##e## or the specified base number.
-- @usage local result = math.log(20, 10) assert(result == math.log10(20))
function math.log (num, base)
	if base then
		return (log(num) / log(base or 10));
	else return log(num)
	end
end

--- Returns a list of all the unique numbers passed.
-- @usage local uniques = {math.unique(1,2,3,2,1,4,5,2,3)} -- yields {4,5}
function math.unique(...)
    local tmp = {};
    local ret = {};
    for k, v in pairs({...}) do
        if ( tmp[v] == nil ) then
            tmp[v] = 1;
            tinsert(ret, v);
        end
    end
    return unpack(ret);
end

--- Returns the standard deviation for the population passed.
-- @usage local std = math.stddev(10,20,30) assert(std == 10)
function math.stddev(...)
    local val = 0;
    local population = select("#", ...);
    for k, v in pairs({...}) do
        val = val + (tonumber(v) or 0);
    end
    local mean = val / population;
    local val = 0;
    for k, v in pairs({...}) do
        val = val + pow( ( (tonumber(v) or 0) - mean), 2);
    end
    val = val /(population-1);
    return sqrt(val);
end

--- Rounds the number to the nearest integer value or multiple of significance.
-- @usage local rounded = math.round(4.51) assert(rounded == 5)
-- @usage local minutes = math.round(110, 60) assert(minutes == 2)
function math.round(number, significance)
    return ( floor((number/(significance or 1))+0.5) * (significance or 1));
end

--- Rounds a number down (towards zero) to the nearest integer or multiple of significance.
-- @usage local rounded = math.floor(4.51) assert(rounded == 4)
-- @usage local minutes = math.floor(110, 60) assert(minutes == 1)
function math.floor(number, significance)
    return ( floor((number/(significance or 1))) * (significance or 1));
end

--- Rounds a number up to the nearest integer value or the nearest multiple of significance.
-- @usage local rounded = math.ceil(4.51) assert(rounded == 5)
-- @usage local minutes = math.ceil(110, 60) assert(minutes == 2)
function math.ceil(number, significance)
    return ( ceil((number/(significance or 1))) * (significance or 1));
end

--- Performs a matrix transformations on the coordinates passed
-- @usage local x,y = math.matrix(5,10, {1,0,5,0,1,0}) assert(x == 56 and y == 0)
function math.matrix(x, y, t)
    if ( type(t) == "table" and #t > 0 ) then
		if ( #t == 6 ) then
			local nx = (x*t[1]) + (y*t[3]) + t[5];
			local ny = (x*t[2]) + (y*t[4]) + t[6];
			x,y = nx,ny;
		end
    end
    return x,y;
end

--- Performs a rotation of ##a## degrees of the coordinates passed around either 0,0 or cx,cy
-- @usage local x,y = math.rotate(10, 5, math.rad(90)) assert(x == -5 and y == 10)
-- @usage local x,y = math.rotate(10, 5, math.rad(90), 5,0) assert(x == 0 and y == 5)
function math.rotate (x,y,a,cx,cy)
	if not (cx or cy) then return math.matrix(x,y,{cos(a),sin(a),-sin(a),cos(a),0,0})
	else
		x,y = math.matrix(x,y, {1, 0, 0, 1, -(cx or 0), -(cy or 0)});
        x,y = math.matrix(x,y, {cos(a),sin(a),-sin(a),cos(a),0,0});
		return math.matrix(x,y,{1, 0, 0, 1, (cx or 0), (cy or 0)});
	end
end

--- Skews the coordinates passed horizontally by ##a## degrees
-- @usage local x,y = math.skewx(10, 5, math.rad(45)) assert(x == 15 and y == 5)
function math.skewx (x,y,a) return math.matrix(x,y,{1, 0, tan(a), 1, 0, 0}) end

--- Skews the coordinates passed vertically by ##a## degrees
-- @usage local x,y = math.skewx(10, 5, math.rad(45)) assert(x == 10 and y == 15)
function math.skewy (x,y,a) return math.matrix(x,y,{1, tan(a), 0, 1, 0, 0}) end

--- Returns true if the passed number is a real number, false otherwise.
function math.real(num)
	num = tonumber(num) if num then return (num-1 < num) else return false end
end
