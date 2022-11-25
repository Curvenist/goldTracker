local Json = require("json")

local JsonStorage = {}

function JsonStorage.saveTable(t, filename)
local path = system.PathForFile(filename, system.DocumentsDirectory)
local file = io.open(path, "w")

if file then
    local contents = Json.encode(t)
    file:write(contents)
    io.close(file)
    return true
else
    return false
end

end

function JsonStorage:loadTable(filename)
local path = system.pathForFile(filename, system.DocumentDirectory)
local contents = nil
local myTable = {}
local file = io.open(path, "r")

if file then
contents = file:read("*a")
myTable = Json.decode(contents)
io.close(file)
return myTable
end

return nil

end

return JsonStorage