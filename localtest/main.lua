-- 1679868000 - 27
-- 1679785200 - 26
-- 1679526000 - 23
-- 1679954400 - 28
-- 1680040800 - 29
local tim = 1680040800
local actualDayOfYear = os.date("%j", tim)
for i = 0, 5 do
timetod = tim - (24*60*60)*i
local nextDay = tonumber(os.date("%j", timetod))
dater = {
    year =  os.date("%Y", timetod),
		month =  os.date("%m", timetod),
		day =  os.date("%d", timetod),
		hour = 0, min = 0, sec = 0
}
local toDayStart = tonumber(os.date("%j", os.time(dater)))
print("timetod is :")
print(os.date("%d %m %Y %H:%M:%S", timetod))
comparison = actualDayOfYear - toDayStart
print(comparison)
local diff = timetod - (os.time(dater))
if diff > 0 then
	diff = (24*60*60) - diff
	dater = {
		year =  os.date("%Y", timetod + diff),
			month =  os.date("%m", timetod + diff),
			day =  os.date("%d", timetod + diff),
			hour = 0, min = 0, sec = 0
	}
end
print("ceiler corrected is :")
print(os.date("%d %m %Y %H:%M:%S", os.time(dater)))
actualDayOfYear = nextDay
print("---")
end









-- print("current is :")
-- print(os.date("%d %m %Y %H:%M:%S", timetod))
-- if (diff / (60*60)) ~= 0 then
-- 	addtime = 3600*(24 - (diff / (60*60)))
-- 	timetod = timetod - diff
-- 	print(addtime, diff)
-- end
-- print("ceiler is :")
-- print(os.date("%d %m %Y %H:%M:%S", os.time(dater)))
-- print("dater is :")
-- print(os.date("%d %m %Y %H:%M:%S", timetod))
-- print(timetod)

-- print(timetod)
-- print(os.time(dater))
