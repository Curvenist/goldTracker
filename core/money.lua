-- Meta class

Money = {
    Money = nil,
	Trencher = {
		"k", "m", "M"
	}
}

function Money:GetMoney()
    return self.money
end
function Money:SetMoney(money)
    self.money = money
end

function Money:logarithm(value, base)
	if base then
		return math.log(value) / math.log(base)
	end
	return math.log(value)
end

function Money:TruncatedRigth(value, number)
	if value < 0 then
		value = value * -1
	end
	return math.floor((value % 1) * 10^number)
end

function Money:convertGreatVals(money, firstbase, base)
	firstbase = firstbase or 4
	base = base or #Money.Trencher
	if money ~= 0 then
		money = money / 10^firstbase
		local logarithm = math.floor(Money:logarithm(money, 10))
		local modulo = logarithm % base
		local sep = logarithm - modulo
    	return math.floor(money / 10^sep) .. "." .. Money:separator(money, base) .. Money:TruncatedRigth(money / 10^sep, 3)
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


