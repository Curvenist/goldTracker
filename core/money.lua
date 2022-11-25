-- Meta class

Money = {
    Money = nil
}

function Money:GetMoney()
    return self.money
end
function Money:SetMoney(money)
    self.money = money
end

function Money:GetGold()
    return floor(self:GetMoney() / 1e4)
end
function Money:GetSilver()
    return floor(self:GetMoney() / 100 % 100)
end
function Money:GetCopper()
    return self:GetMoney() % 100
end

return Money


