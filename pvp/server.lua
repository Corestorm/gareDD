local cc = "#8667EB"
local prefix = cc.."[Gare]#ffffff "
local pvps = {}

function sendPvp(player, cmd, target, rounds, cash)
  if target and rounds and cash then
    if not pvps[player] then
      local target = findPlayerByName(target)
      if target ~= player then
        if not pvps[player] and not pvps[target] then
          if tonumber(rounds) > 0 and tonumber(rounds) < 4 then
            local playercash = 50000
            local targetcash = 50000
            if tonumber(cash) > 999 then
              if not pvps[target] then
                if playercash > tonumber(cash) and targetcash > tonumber(cash) then
                local mydimension = getElementDimension(player)
                local targetdimension = getElementDimension(target)
                  if mydimension == targetdimension then
                  pvps[target] = {['dimension'] = mydimension, ['sender'] = player, ['rounds'] = rounds, ['roundswon'] = 0, ['reward'] = cash, ['state'] = "none"}
                  pvps[player] = {['dimension'] = mydimension, ['sender'] = target, ['rounds'] = rounds, ['roundswon'] = 0, ['reward'] = cash, ['state'] = "none"}
                  outputChatBox(prefix.."PVP request was sent to "..getPlayerName(target).."#ffffff.",player,255,255,255,true)
                  outputChatBox(prefix.."You received a PVP request from "..getPlayerName(player).."#ffffff.Use"..cc.."/rpvp accept #ffffffor" ..cc.."/rpvp deny#ffffff.",target,255,255,255,true)
                  setTimer(pvpTimer,10000,1,player,target)
                  end
                else
                outputChatBox(prefix.."You or target does not have enough cash.",player,255,255,255,true)          
                end
              else
              outputChatBox(prefix.."Your opponent already has a PVP request.",player,255,255,255,true)  
              end
            else
            outputChatBox(prefix.."You have to bet at least 1000 on PVP.",player,255,255,255,true)   
            end
          else
          outputChatBox(prefix.."Round count has to be between 1-3.",player,255,255,255,true)   
          end 
        else
        outputChatBox(prefix.."Your opponent already has a PVP request",player,255,255,255,true)    
        end
      else
      outputChatBox(prefix.."You can not send a PVP request to yourself.",player,255,255,255,true)  
      end  
    end
  else   
  outputChatBox(prefix.."Usage: /pvp playername 3 1000.",player,255,255,255,true)   
  end
end  
addCommandHandler("pvp",sendPvp)

function pvpTimer(player,target)
pvps[player] = nil
pvps[target] = nil
outputChatBox(prefix..getPlayerName(target).."#ffffff did not accept your PVP request!",player,255,0,0,true)
outputChatBox(prefix.."PVP request from "..getPlayerName(player).." #ffffffgot cancelled because you did not reply in 10 seconds.",target,255,0,0,true)
end

function idio(player,cmd)
pvps[player] = {['dimension'] = mydimension, ['sender'] = findPlayerByName("ert"), ['rounds'] = 3, ['roundswon'] = 0, ['reward'] = 1000, ['state'] = "accept"}
pvps[findPlayerByName("ert")] = {['dimension'] = mydimension, ['sender'] = player, ['rounds'] = 3, ['roundswon'] = 0, ['reward'] = 1000, ['state'] = "accept"}
end
addCommandHandler("idio",idio)

function replyPvp(player, cmd, value) 
  if pvps[player] then
    if value == "accept" then
    local target = pvps[player].sender
      if target then
      pvps[player].state = "accept"
      pvps[target].state = "accept"
      outputChatBox(prefix.."PVP request from "..getPlayerName(target).."#ffffff was accepted.",player,255,0,0,true)
      end
    elseif value == "deny" then
    local target = pvps[player].sender
    outputChatBox(prefix.."PVP request from "..getPlayerName(target).."#ffffff was declined.",player,255,0,0,true)
    pvps[player] = nil
    pvps[target] = nil
    end
  end
end
addCommandHandler("rpvp",replyPvp)

function startedPvp()
local player = source
if pvps[player] then
  if pvps[player].state == "accept" then
    local target = pvps[player].sender  
    local roundswon = pvps[player].roundswon + pvps[target].roundswon
    outputChatBox(prefix.."You lost a pvp round against "..getPlayerName(target).."#ffffff.", player, 255,255,255,true)
    outputChatBox(prefix.."You won a pvp round against "..getPlayerName(player).."#ffffff", target, 255,255,255,true)
    if pvps[player].rounds == roundswon then
    endPvp(player, target)
    end
    pvps[target].roundswon = pvps[target].roundswon + 1
  end
end
end
addEventHandler("onPlayerWasted",root,startedPvp)

function endPvp(player, target)
  if pvps[player].roundswon > pvps[target].roundswon then
  outputChatBox(prefix..getPlayerName(player).. " won the PVP against "..getPlayerName(target)..cc.." ("..pvps[player].roundswon..":"..pvps[target].roundswon..")",root,255,255,255,true)
  elseif pvps[target].roundswon > pvps[player].roundswon then
  outputChatBox(prefix..getPlayerName(target).. " won the PVP against "..getPlayerName(player)..cc.." ("..pvps[target].roundswon..":"..pvps[player].roundswon..")",root,255,255,255,true)
  end
pvps[player] = nil
pvps[target] = nil
end    


function playerQuit()
  if pvp[source] then
  local target = pvp[source].sender
    if target then
      outputChatBox("You won the PVP against "..getPlayerName(source).." #ffffffbecause they left the server.", target,255,255,255,true)
      pvps[target] = nil
      pvps[source] = nil
    end  
  end
end
addEventHandler("onPlayerQuit",root,playerQuit)  

    function findPlayerByName (name)
    local player = getPlayerFromName(name)
    if player then return player end
    for i, player in ipairs(getElementsByType("player")) do
        if string.find(string.gsub(getPlayerName(player):lower(),"#%x%x%x%x%x%x", ""), name:lower(), 1, true) then
            return player
        end
    end
return false
end