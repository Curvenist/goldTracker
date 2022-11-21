--[[
Intending addon :
    play music from playlist packages
    1)Pacakge form : array of ids
    2)start playlist with playPlaylist(package)
    3)any time, we can increment / randomize the music or set the number
    to get this activated : i enter the name function "playPlaylist(package)"

]]--

local bIsPlaying = false;
local bcurrentMusic = {current = 1, length = 0}
local bTimer = 0;
local bpackage = {}

local function playPlaylist(bool, i) --bool trye = randomize, false = simple
    package.getmusArray(1)
    if bool then
        bcurrentMusic.current = math.random(1, #package)
    end
    if i ~= nil then
        bcurrentMusic.current = i
    end
    bpackage = package

    --mettre en place l'event qui calcule si la musique est jouée, si elle est finie, on attend / passe à la suivante

    playNext(bcurrentMusic)
end

local function playNext(bcurrentMusic)
    bcurrentMusic.length = bpackage[bcurrentMusic.current][2]
    PlayMusic(bpackage[bcurrentMusic.current][1])

    
end

/run local music = {1067043, 1067044, 2146636, 2151743}
if bmus == nil then
     bmus = 1 
elseif bmus > 4 then
     bmus = 1 
end  
PlayMusic(music[bmus])
bmus = bmus + 1