function login(source,user,pass,check, status)

    local fetch = exports.API:callAPI("user/login", 
    {
        ["account"] = user,  
        ["password"] = pass,  
        ["getHash"] = true,  
        ["remember"] = check,
        ["serial"] = getPlayerSerial(source) or nil, 
        ["ip"] = getPlayerIP(source) or nil
    } ,"POST")
    fetchRemote(fetch.route, fetch.options, 
    function(res,error)
        local res = fromJSON(res) or ""
        if (res.user) then
            if not status then
                triggerClientEvent(source,"login:close",source)
            end
            triggerClientEvent(source,"add:notification",source,"Login successfully","success",true)
            if (res.token)then
                setElementData(source,"getToken", res.token)
                iprint(getPlayerName(source):gsub("#%x%x%x%x%x%x",""))
                iprint("Token = { "..res.token .." }")
            end
        else
            triggerClientEvent(source,"add:notification",source,res.message,"error",true)
        end
    end)

end
addEvent("login:login", true)
addEventHandler("login:login", root, login)

function register(source, email, user, pass, rpass)
    if ( string.len(pass) >= 8 )then
        if (string.len(user) >= 4) then
            if (pass == rpass)then
                local fetch = exports.API:callAPI("user", 
                {
                    ["username"] = user,  
                    ["nickname"] = getPlayerName(source):gsub("#%x%x%x%x%x%x","") or nil,  
                    ["email"] = email,  
                    ["password"] = pass,  
                    ["country"] = exports.admin:getIpCountry("186.11.18.80") or nil, 
                    ["language"] = exports.admin:getIpCountry("186.11.18.80") or nil, 
                    ["ip"] = getPlayerIP(source) or nil ,
                    ["serial"] = getPlayerSerial(source) or nil
                },"POST")
                fetchRemote(fetch.route, fetch.options, 
                function(res,error)
                    local res = fromJSON(res) or nil
                    if (res.user) then
                        triggerClientEvent(source,"add:notification",source,"Register successfully","success",true)
                        triggerClientEvent(source,"login:sendLcontainer",source)
                    else
                        triggerClientEvent(source,"add:notification",source,res.message,"error",true)
                    end
                end)
            else
                triggerClientEvent(source,"add:notification",source,"Passwords do not match","warn",true)   
            end
        else
            triggerClientEvent(source,"add:notification",source,"The username must have a minimum of 4 characters","warn",true)
        end
    else
        triggerClientEvent(source,"add:notification",source,"The password must have a minimum of 8 characters","warn",true)
    end
    return false
end
addEvent("login:register", true)
addEventHandler("login:register", root, register)




function check(player)
    local source = player and player or source
    local playerSerial = getPlayerSerial(source)
    if playerSerial and source then
        local fetch = exports.API:callAPI("userBySerial/"..playerSerial, {},"GET")
        fetchRemote(fetch.route,fetch.options,
        function(res,error)
            local res = fromJSON(res) or ""
            if (res.user) then
                if ( res.user["remember"] == true)then
                    login(source, res.user["username"], res.user["password"], res.user["remember"],true)
                else
                    triggerClientEvent(source,"login:start",source)
                end
            else
                triggerClientEvent(source,"login:start",source)
            end
        end)
    else
        triggerClientEvent(source,"add:notification",source,"No serial","error",true)
    end
end


addEventHandler("onPlayerJoin", root, check)
addEventHandler("onResourceStart", root, 
function()
    for j, player in pairs(getElementsByType("player"))do
        check(player)
    end
end)



function unRemember(source,cmd,username,password)
    if username and password then
        local fetch = exports.API:callAPI("user/login",
        {
            ["account"] = username,
            ["password"] = password,
            ["remember"] = false
        },"POST")
        fetchRemote(fetch.route,fetch.options,
        function(res,error)
            local res = fromJSON(res) or ""
            if (res.user)then
                if (res.user["remember"] == false)then
                    triggerClientEvent(source,"add:notification",source,"We will stop remembering your data.","info",true)
                end
            else
                triggerClientEvent(source,"add:notification",source,"Something went wrong, contact a developer.","error",true)
            end
        end)
    else
        triggerClientEvent(source,"add:notification",source,"Syntax error, /unremember username password","warn",true)
    end

end
addCommandHandler("unremember", unRemember)


function country(source)
    local country2 = exports.admin:getIpCountry("186.11.18.80")
    iprint(country, country2)
end
addCommandHandler("cc", country)
