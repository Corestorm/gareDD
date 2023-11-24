

-- LIBRARY BY ANDRESTVZ --

function dxDrawCheckbox(x,y,w,h,color,postGUI)
    local object = {
        id = math.floor(x+y+w+h),
        x = x or 0,
        y = y or 0,
        w = w <= 100 and w or 100,
        h = h <= 50 and h or 50,
        rectangleColor =  tocolor(255,255,255,50),
        circleColor = color or tocolor(255,255,255,255),
        checkColor = color or tocolor(0,0,0,255),
        postGUI = postGUI or false,
        isActived = false,
        image = "images/recir.png",
        temp = false,
        tick = 0
    }
    addEventHandler("onClientClick", getRootElement(),
    function(button, state)
        if (button == "left" and state == "down") then
            object.temp = true
            setTimer(function() object.temp = false end,50,1);
        end
    end)
    object.saveColor = function(r,g,b,a)
        local color = tocolor(r,g,b,a)
        object.checkColor = color
    end
    object.render = function()
        local circle = object.h * 2.5 * scale
        if object.temp and isCursorHover(object.x  - (circle/2),object.y,object.w + circle, circle) then
            object.temp = false
            if not object.isActived then
                object.tick = getTickCount()
                object.isActived = true
            else
                object.tick = getTickCount()
                object.isActived = false
            end
        end
        local currentTick = getTickCount()
        object.progress = object.x
        object.progress = interpolateBetween( object.isActived and (object.progress - (circle - object.h)) or (object.progress + object.h + circle*0.5), 0, 0, object.isActived and (object.progress + object.h + circle*0.5) or (object.progress - (circle - object.h)) , 0, 0, math.min(1000, currentTick - object.tick)/1000, "Linear") 
        dxDrawImageSection(object.x, object.y, object.w, object.h, 51, 0, 105, 50, object.image, 0,0,0, object.rectangleColor, object.postGUI)
        dxDrawImageSection(object.progress, object.y - (circle - object.h)/2, circle, circle, 0, 0, 50, 51, object.image, 0,0,0, object.isActived and object.checkColor or object.circleColor, object.postGUI)
    end
    object.getStatus = function()
        return object.isActived
    end
    return object
end
function createEditbox(text,posx,posy,width,height,color,fontsize,fontSB,fontcolor,textalignHor,textalignVer,ismasked)
    local object = {
        id = id,
        textDefault = text or "",
        text = text or "",
        x = posx or 0,
        y = posy or 0,
        width = width or 0,
        center = width*0.5 or 0,
        height = height or 0,
        color = color or tocolor(0,0,0,100),
        fontsize = fontsize or 1,
        fontSB = fontSB or "default",
        fontcolor = fontcolor or tocolor(255,255,255,255),
        textalign = textalign or "center",
        textalignVer = textalignVer or "center",
        ismasked = ismasked,
        isActive = false,
        isEnable = false,
    }
	addEventHandler("onClientCharacter", getRootElement(),function(letter)
        if letter ~= " " then
            letra = letter
        end
    end)
	addEventHandler("onClientKey", root, function(key,status)
        if status then
            if object.isActive then 
                if string.len(object.text) > 0 and key == "backspace" then
                    object.text = string.sub(object.text,1,string.len(object.text) -1) -- elimina el ultimo valor de la string
                end
            end
        end
    end)
    object.render = function ()
        if getKeyState("mouse1") then -- SI LA PERSONA CLICKEA
            if isCursorHover(object.x,object.y,object.width,object.height) then -- SI EL CURSOR ESTA DENTRO DEL RECTANGULO --
                if not object.isActive then
                    object.isActive = true
                    if object.text == object.textDefault then -- SI EL TEXTO ES IGUAL AL DEFAULT ESTE LO BORRARA AL DAR CLICK PARA PODER INGRESAR LOS DATOS
                        object.text = ""
                    end
                end
            end
            if not isCursorHover(object.x,object.y,object.width,object.height) then -- SI LA PERSONA CLICKEA FUERA DEL EDIT
                if object.isActive then
                    object.isActive = false
                end
            end
        end
        if object.isActive then -- SI ESTA CLICKEADO ESTE ESCRIBIRA LAS LETRAS
            if letra ~= nil then 
                object.text = object.text..letra
                letra = ""
            end
        end
        -- ANCHO DEL RECTANGULO MIN SERA TODO LO QUE OCUPE EL TEXTO
        object.width2 = dxGetTextWidth((object.ismasked and object.textMasked or object.text), object.fontsize,object.fontSB) + object.center
        object.height = dxGetFontHeight(object.fontsize,object.fontSB)
        -- SI EL EDIT ES OCULTO CAMBIARA EL TEXTO POR *** 
        if object.ismasked then
            object.textMasked = string.rep('*', #object.text)
        end
        object.fontH = dxGetFontHeight(object.fontsize,object.fontSB) * 1.3
        dxDrawLine(object.x + object.width * 0.25 , object.y + object.fontH, object.x + object.width * 0.75,object.y + object.fontH , object.color)
        dxDrawText(object.ismasked and object.textMasked or object.text, object.x, object.y, object.x + object.width, object.y + object.height, object.fontcolor, object.fontsize, object.fontSB, object.textalign,object.textalignVer, false, false, false, true)
    end
    object.getText = function() return object.text end
    return object
end
function createButton(text,posx,posy,width,height,color,fontsize,fontSB,fontcolor,textalignHor,textalignVer)
    local object = {
        text = text or "",
        x = posx or 0,
        y = posy or 0,
        width = width or 0,
        height = height or 0,
        color = color or tocolor(0,0,0,100),
        fontsize = fontsize or 1,
        fontSB = fontSB or "default",
        fontcolor = fontcolor or tocolor(255,255,255,255),
        textalign = textalign or "center",
        textalignVer = textalignVer or "center",
        click = false,
    }
    object.render = function ()
        dxCurvedRectangle(object.x,object.y,object.width,object.height,20*scale,object.color)
        dxDrawText(object.text, object.x,object.y, object.x + object.width, object.y + object.height, object.fontcolor, object.fontsize, object.fontSB, object.textalign,object.textalignVer, false, false, false, true)
    end
    object.isClicked = function()
        if getKeyState("mouse1") and not object.click then -- SI LA PERSONA CLICKEA
            if isCursorHover(object.x,object.y,object.width,object.height) then
                object.click = true
                object.tim()
                return true
            end
        end
        return false
    end
    object.isHovered = function()
        if isCursorHover(object.x,object.y,object.width,object.height) then
            return true
        end
        return false
    end
    object.tim = function ()
        setTimer(function() object.click = false end, 1000,1)
    end
    return object
end
function dxCurvedRectangle( x, y, w, h, border, color)
    dxDrawRectangle(x + border, y, w - border * 2, h, color)
    dxDrawRectangle(x, y + border ,border, h - border * 2, color)
    dxDrawRectangle(x+w-border, y + border ,border, h - border * 2,color)
    dxDrawCircle( x + w - border, y + border, border, 0, -90, color, color, 20)
    dxDrawCircle( x + w - border, y + h - border, border, 0, 90, color, color, 20)
    dxDrawCircle( x + border, y + border, border, -90, -180, color, color, 20)
    dxDrawCircle( x + border, y + h - border, border, -180, -270, color, color, 20)
end
function isCursorHover(pX,pY,sX,sY)
	if isCursorShowing() then
		local cX,cY,_,_,_ = getCursorPosition()
		if cX and cY then
			if cX >= pX/screen.x and cX <= (pX+sX)/screen.x and cY >= pY/screen.y and cY <= (pY+sY)/screen.y then
		        return true
		    end
		end
	end
    return false
end

