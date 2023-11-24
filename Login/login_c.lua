screen = Vector2(guiGetScreenSize())
scale, fontScale = math.min(math.max(screen.x/1600, 0.5), 1), math.min(math.max(screen.y/1600, 0.85), 1)


local login = {}


login.width, login.height = math.floor(390 * scale), math.floor(630 * scale)
login.x, login.y = math.floor( (screen.x/2) - (login.width/2) ), math.floor( (screen.y/2) - (login.height/2) )

login.fontB = dxCreateFont(":fonts/Montserrat-Bold.ttf", math.floor(25 * fontScale))
login.fontSB = dxCreateFont(":fonts/Montserrat-SemiBold.ttf", math.floor(25 * fontScale))
login.fontL = dxCreateFont(":fonts/Montserrat-Light.ttf", math.floor(15 * fontScale))
login.fontLS = dxCreateFont(":fonts/Montserrat-Light.ttf", math.floor(13 * fontScale))
login.fontSize = 1 * fontScale


login.defaultAvatar = "images/default-avatar.png"
login.avatarSize = math.floor( 120 * scale )
login.editH = math.floor( 50 * scale )
login.rememberW, login.rememberH = math.floor( 30 * scale ), math.floor( 8 * scale ) 
login.bpadding = math.floor( 10 * scale )
login.bw = login.width * 0.3 - (login.bpadding)




function login.open()
    login.opened = true
    showCursor(true)
    showChat(false)
    preRender()
    triggerServerEvent("login:getcache",localPlayer, localPlayer)
    guiSetInputMode("no_binds") 
    addEventHandler("onClientRender", root, login.render)
end

function preRender()

    username = createEditbox("username", login.x , login.y + ( login.width * 0.6), login.width, login.editH , tocolor(255,255,255,50),login.fontSize,login.fontSB,tocolor(255,255,255,255),"center","center", false)
    password = createEditbox("password", login.x , login.y + ( login.width * 0.85), login.width, login.editH , tocolor(255,255,255,50),login.fontSize,login.fontSB,tocolor(255,255,255,255),"center","center", true)
    checkbox = dxDrawCheckbox( login.x + (login.width * 0.63), login.y + (login.height * 0.695), login.rememberW, login.rememberH, tocolor(255,255,255,255), false)
    btnlogin = createButton("LOGIN", (login.x + login.width * 0.5) - login.bw - (login.bpadding * 0.5) , login.y + login.height * 0.8, login.bw, login.height * 0.07, tocolor(0,0,0,50),login.fontSize*0.7,login.fontB,tocolor(255,255,255,255),"center","center")
    btnguest = createButton("GUEST", (login.x + login.width * 0.5) + (login.bpadding * 0.5), login.y + login.height * 0.8, login.bw, login.height * 0.07, tocolor(0,0,0,50),login.fontSize*0.7,login.fontB,tocolor(255,255,255,255),"center","center")
    
end
addEvent("login:open", true)
addEventHandler("login:open", root, login.open)


function loadCache(data)
    username.text = data[1]
    password.text = data[2]
    checkbox.isActived = data[3]
end
addEvent("login:loadcache", true)
addEventHandler("login:loadcache", root, loadCache)

function login.close()

    showCursor(false)
    showChat(true)

    guiSetInputMode("allow_binds") 

    removeEventHandler("onClientRender", root, login.render)
end
addEvent("login:close", true)
addEventHandler("login:close", root, login.close)
addEventHandler("onClientResourceStart", root, login.open)

function login.render()

    dxDrawImage(0,0,screen.x,screen.y, "images/background.jpg")


    dxCurvedRectangle(login.x, login.y, login.width, login.height, 20, tocolor(255,255,255,30))
    dxDrawAvatar(login.x + (login.width * 0.5) - (login.avatarSize * 0.5), login.y + (login.height * 0.1), login.avatarSize,"images/andrestvz.png")
    dxDrawText("Remember me?", login.x + (login.width * 0.25), login.y + (login.height * 0.7), login.x + (login.width * 0.75), login.y + (login.height * 0.7), tocolor(255,255,255,255), login.fontsize, login.fontLS, "left","center", false, false, false, true)
    
    dxDrawText("Register at www.gare.gg", login.x, login.y + (login.height * 0.98), login.x + (login.width), login.y + (login.height * 0.98), tocolor(255,255,255,255), login.fontsize, login.fontLS, "center","center", false, false, false, true)
 
    username.render()
    password.render()
    checkbox.render()
    btnlogin.render()
    btnguest.render()



    if btnlogin.isHovered() then btnlogin.color = tocolor(0,0,0,150) else btnlogin.color = tocolor(0,0,0,50) end
    if btnguest.isHovered() then btnguest.color = tocolor(0,0,0,150) else btnguest.color = tocolor(0,0,0,50) end
    if btnguest.isClicked() then 
        login.close()
        triggerEvent("add:notification",localPlayer,"You play guest.","warn",true) 
        triggerEvent("add:notification",localPlayer,"Register on www.gare.gg","info",true) 
    end

    if btnlogin.isClicked() then 
        local user = username.getText()
        local pass = password.getText()
        local check = checkbox.getStatus()
        triggerServerEvent("login:onLogin",localPlayer, localPlayer,user,pass,check)
    end


end

function dxDrawAvatar(x,y,size,imagePath)
    if not login.maskShader then
		login.maskShader = dxCreateShader("fx/mask.fx")
	end
	if not login.maskTexture then
		login.maskTexture = dxCreateTexture("images/circle.png")
		dxSetShaderValue(login.maskShader, "maskTexture", login.maskTexture)
	end
	if not login.avatarTexture then
		login.avatarTexture = dxCreateTexture(imagePath or "images/default-avatar.png")
	end
	dxSetShaderValue(login.maskShader, "imageTexture", login.avatarTexture)
    return dxDrawImage(x,y,size,size,login.maskShader)
end

