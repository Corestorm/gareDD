
local screenWidth, screenHeight = guiGetScreenSize()
local rname = getResourceName(getThisResource())
local page = "http://mta/"..rname.."/index.html"



function startLogin()
	initBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, false, false)
	theBrowser = guiGetBrowser(initBrowser)
	addEventHandler("onClientBrowserCreated", theBrowser, 
		function()
			loadBrowserURL(source, page)
			showCursor(true)
			showChat(false)	
		end
	)
end
addEvent("login:start", true)
addEventHandler("login:start", root, startLogin)

function login(username,password,checkbox)
	triggerServerEvent("login:login", localPlayer, localPlayer, username, password, checkbox)
end
addEvent("playerLogin", true)
addEventHandler("playerLogin", root, login)

function register(emailR, usernameR, passwordR, repasswordR)
	triggerServerEvent("login:register", localPlayer, localPlayer, emailR, usernameR, passwordR, repasswordR)
end
addEvent("playerRegister", true)
addEventHandler("playerRegister", root, register)

function destroyLogin()
	showCursor(false)
	showChat(true)
	destroyElement(initBrowser)
end
addEvent("login:close", true)
addEventHandler("login:close", root, destroyLogin)

function sendToLogin()
	executeBrowserJavascript(theBrowser, "backLogin()")
end
addEvent("login:sendLcontainer", true)
addEventHandler("login:sendLcontainer", root, sendToLogin)
