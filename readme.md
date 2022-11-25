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

    properties explained Exchange.lua
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


    <Backdrop bgFile="Interface\DialogFrame\UI-DialogBox-Background" edgeFile="Interface\DialogFrame\UI-DialogBox-Border" tile="true">
    <TileSize>
        <AbsValue val="16" />
    </TileSize>
    <EdgeSize>
        <AbsValue val="16" />
    </EdgeSize>
    <BackgroundInsets>
        <AbsInset left="4" right="3" top="4" bottom="3" />
    </BackgroundInsets>
    </Backdrop>

        <Button name="$parent_Button">
            <Size>
                <AbsDimension x="15" y="15" />
            </Size>
            <Anchor point="CENTER"></Anchor>
            <NormalTexture file="Interface\Minimap\Tracking\OBJECTICONS">
                <TexCoords left="0" right="0.125" top="0" bottom="0.5">
            </NormalTexture>
            <HighlightTexture>
                <TexCoords left="0.125" right="0.125" top="0" bottom="0.5">
            </HighlightTexture>
        </Button>