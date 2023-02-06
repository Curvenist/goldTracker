## CustomMusic doc

This addon provides 2 actual features :

### music player
Exposes a function that allows player to play music with a given playlist

1) uses packages containing an array of objects : each object in array contains the id of the song and the length of the song
2) use function /cm playMusic(param1, bool, 1) in order to play the given playlist from the given index - reexuting refreshes data, its always incrementing if not random => bool
3) uses a minuter so that we can delay the next song or not, it won't be hardcoded, it will be given in param...

### gold accountancy
Exposes a function that records data and chart of money income and spending

1) The file starts from the ealiest hour the player has connected in the day, we use it at starter

    properties explained Tracker.lua
    eg :

        ■ date = recording date of the day
        ■ dailyMoney = money at the first connection
        ■ currentMoney = the current money the player has, whenever he is connected
        ■ income = the income of gold for the player
        ■ spending = the amount of gold spending
        ■ netDailyValue = if the daily money doesn't add up with the last day the ■ player connected, we catch up a net value (< 0 is loss, > 0 is income)
        ■ netValue = same but catching up with the same day, if the current value when player connects is different than what has been saved.
        dailyCatch = we have collected the netDailyValue (can be upgraded to netDailyValue where the value can be set to nil or has a value in)

    functions in banking system
    eg :

        ■ DailyEvolution => from day to day
        ■ WeekRecap => (Highest / lowest day perf)
        ■ WeekEvolution => (Week performance / comparison to weeks)
        ■ ?MonthRecap => (Highest / lowest day perf => same with week) => *
        ■ ?Month Evolution => (Month performance / comparison to months and weeks) => data can be kept up to 2 months, if need be, we can collect to more*

        =>* solution, gather information and compact it so may just have 1 entry (collecting global income and spending, netValue too)

## Stash code

customMoney = {
	[1673478000] = {
		["dailyMoney"] = 15043508958,
		["dailyCatch"] = true,
		["netValue"] = 0,
		["currentMoney"] = 15047463093,
		["income"] = 19733557,
		["netDailyValue"] = 0,
		["netEarning"] = 0,
		["spending"] = 15779422,
		["netValueD"] = 0,
		["date"] = "12012023",
	},
	[1673737200] = {
		["dailyMoney"] = 13162758745,
		["dailyCatch"] = true,
		["netValue"] = 0,
		["currentMoney"] = 13172008615,
		["income"] = 9681475,
		["spending"] = 431605,
		["netDailyValue"] = 0,
		["netEarning"] = 0,
		["netValueD"] = 0,
		["date"] = "15012023",
	},
	[1673996400] = {
		["dailyMoney"] = 13177024733,
		["dailyCatch"] = true,
		["date"] = "18012023",
		["netValueD"] = 0,
		["income"] = 148210272,
		["spending"] = 29257259,
		["netDailyValue"] = 0,
		["netEarning"] = 0,
		["currentMoney"] = 13295977746,
		["netValue"] = 0,
	},
	[1674255600] = {
		["dailyMoney"] = 13300886788,
		["dailyCatch"] = true,
		["date"] = "21012023",
		["netValueD"] = 0,
		["income"] = 45414961,
		["spending"] = 11831738,
		["netDailyValue"] = 0,
		["netEarning"] = 0,
		["currentMoney"] = 13334470011,
		["netValue"] = 0,
	},
	[1674514800] = {
		["dailyMoney"] = 14537512955,
		["dailyCatch"] = true,
		["date"] = "24012023",
		["netValueD"] = 0,
		["income"] = 2214270,
		["spending"] = 12321293,
		["netDailyValue"] = 0,
		["netEarning"] = 0,
		["currentMoney"] = 14527405932,
		["netValue"] = 0,
	},
	[1674774000] = {
		["dailyMoney"] = 0,
		["dailyCatch"] = false,
		["date"] = "27012023",
		["income"] = 0,
		["netEarning"] = 0,
		["netDailyValue"] = 0,
		["netValue"] = 0,
		["currentMoney"] = 0,
		["spending"] = 0,
	},
}
dateArray = {}
for k, v in pairs(customMoney) do
    table.insert(dateArray, k)
end
table.sort(dateArray, function(a, b) return a > b end)

for k, v in pairs(dateArray) do
    print(v)
end

print("-----")

function datePicker(datePicker, interval, vals) -- prendre un interval de date
datePicker, interval, vals =  datePicker or {}, interval or {}, {}

arrayOfDates = dateArray
if #datePicker ~= 0 then
    arrayOfDates = datePicker
end

for k, v in pairs(arrayOfDates) do
    if #interval == 2 then
    if v <= interval[2] and v >= interval[1] then
        table.insert(vals, v)
    end
    else
        table.insert(vals, v)
    end
end
return vals
end

function dateMathPicker(daysOfWeek, occurences) -- intéressant pour capter des dates par comparaison - tous les mercredi*


end


calcul = datePicker({}, {1673478000, 1674774000})
--calcul = datePicker({dateArray[2], dateArray[3], dateArray[4]})
--calcul = dateMathPicker({2, 3}, 5) --Every Tuesday / wednesday for 5 weeks

for k, v in pairs(calcul) do

 print(os.date("%w",v))
end



