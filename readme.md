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
    
    It always record the money i have, then each time i get income / spending, 
    I record then the sum of earnings and the sum of the spendings assides to generate the income data.

    The last value of the day recorded is the final data needed to freeze the true income

    eg : 

        thu 151122 0950 = 10000 (Xog)
        current = PLAYER_MONEY => getMoney()

        gold, quantityChange will be taken
        
        spending / earning
        income if CURRENCY_DISPLAY_UPDATE >= 0
        spending if CURRENCY_DISPLAY_UPDATE < 0
