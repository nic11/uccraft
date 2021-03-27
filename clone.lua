-- https://stackoverflow.com/a/7615129
function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local BASE_URL = 'https://raw.githubusercontent.com/nic11/uccraft/master'
local TARGET_DIR = 'uccraft'

function fetch(filePath)
    local sourcePath = BASE_URL .. '/' .. filePath
    print('get', sourcePath)

    local req = http.get(sourcePath)
    local data = req.readAll()

    local targetPath = TARGET_DIR .. '/' .. filePath
    fs.makeDir(targetPath)
    fs.delete(targetPath)
    
    local f = fs.open(targetPath, 'w')
    f.write(data)
    f.close()
end

local req = http.get(BASE_URL .. '/clone-list')
local lines = split(req.readAll(), '\n')

for i = 1, #lines do
    fetch(lines[i])
    local f = fs.open(TARGET_DIR .. '/' .. lines[i], 'r')
    print(f.readAll())
    f.close()
end
