Config = {}

function Config:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Config:popUpData()

end