-- Meta class

Money = {
    Money = nil,
	Trencher = {
		"k", "m", "M"
	},
}

function Money:GetMoney()
    return self.money
end
function Money:SetMoney(money)
    self.money = money
end

function Money:logarithm(value, base)
	value = math.abs(value)
	if base then
		return math.log(value) / math.log(base)
	end
	return math.log(value)
end

function Money:TruncatedRigth(value, number)
	return math.floor((math.abs(value) % 1) * 10^number)
end

function Money:Truncated(value, number)
	return math.floor(value) + (math.floor((math.abs(value) % 1) * 10^number) / 10^number)
end

function Money:convertGreatVals(money, firstbase, base, decimal)
	firstbase, decimal = firstbase or 4, decimal or 2
	base = base or #Money.Trencher
	if money ~= 0 then
		money = money / 10^firstbase
		local logarithm = math.floor(Money:logarithm(money, 10))
		local modulo = logarithm % base
		local sep = logarithm - modulo
    	return math.floor(money / 10^sep) .. Money:separator(money, base) .. Money:TruncatedRigth(money / 10^decimal, 3)
	end
	return money
end

function Money:separator(money, base)
    local logarithm =math.floor(Money:logarithm(money, 10))
    local maximal = logarithm / base^2
    local common = (logarithm / base) % base
	local separator = ""
    if math.floor(common) >= 1 then
        separator = Money.Trencher[math.floor(common)]
    end
    if maximal >=1 then
        for i = 1, math.floor(maximal) do
            separator = separator .. Money.Trencher[#Money.Trencher]
        end
    end
    return separator
end

-- value must be a number! this method is an order of comparison
function Money:dataInterpretation(value, limit, opt)
	if type(value) ~= "number" then return value end
	opt[3], limit[3] = opt[3] or 1, limit[3] or limit[1]
	if opt[3] ~= 1 and opt[3] ~= 2 then
		return value
	end

	if GeneralM:case(value > limit[1], function () end) then return opt[1] 
	elseif GeneralM:case(value < limit[2], function () end) then return opt[2]
	elseif GeneralM:case(value == limit[3], function () end) then return opt[opt[3]]
	else return value end
end

function Money:GetGold()
    return math.floor(self:GetMoney() / 1e4)
end
function Money:GetSilver()
    return math.floor(self:GetMoney() / 100 % 100)
end
function Money:GetCopper()
    return self:GetMoney() % 100
end

function Money:ConvertGold(money)
    return math.floor(money / 1e4)
end
function Money:ConvertSilver(money)
    return math.floor(money / 100 % 100)
end
function Money:ConvertCopper(money)
    return money % 100
end


