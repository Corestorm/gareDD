
function join(source,user,pass,check)
    local options = {
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json"
        },
        postData = jsonParse({
            ["username"] = user,
            ["password"] = pass
        })
    }
    fetchRemote( "http://localhost:3000/users", options, function(res, error)
        local data = fromJSON(res) or ""
        if (user == data.username) and ( pass == data.password) then
            triggerClientEvent(source,"login:close",source)
            triggerClientEvent(source,"add:notification",source,"Welcome back","success",true)
            if check then
                saveCache(source, user, pass, check, data.id)
            end
        else
           triggerClientEvent(source,"add:notification",source,"Username or password Incorrect.","error",true)
        end
    end)
end
addEvent("login:onLogin",true)
addEventHandler("login:onLogin", root, join)

function jsonParse(t)
    return string.sub(toJSON(t),2,-2)
end

function getCache(source)
    local serial = getPlayerSerial(source)
    local hash = "CACHE/"..md5(serial)..".edf"
    if fileExists(hash) then
        local file = fileOpen(hash, true)
        local content = fileRead(file, fileGetSize(file))
		fileClose(file)
        local data = (fromJSON(base64Decode(teaDecode(content, md5(serial)))))
        triggerClientEvent(source,"login:loadcache",source,data)
    else
        return outputDebugString("[Login Cache] Not file for: " ..getPlayerName(source):gsub("#%x%x%x%x%x%x",""), 4, 255, 50, 50)
    end
    return data
end
addEvent("login:getcache",true)
addEventHandler("login:getcache", root, getCache)

function saveCache(source, us, pw, checkbox, id)
    local info = {us,pw,checkbox,id}
    local serial = getPlayerSerial(source)
    local hash = "CACHE/"..md5(serial)..".edf"
    local content = teaEncode(base64Encode(toJSON(info)), md5(serial))
    if fileExists(hash) then fileDelete(hash) end
    local file = fileCreate(hash)
    if file then 
        fileWrite(file,content)
        fileFlush(file)
        fileClose(file)
    end
end