backupBlip = nil
backupPlayer = nil

function removeBackup(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if (backupPlayer~=nil) then
			destroyElement(backupBlip)
			removeEventHandler("onPlayerQuit", backupPlayer, destroyBlip)
			removeEventHandler("savePlayer", backupPlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = nil
			outputChatBox("Backup system reset!", thePlayer, 255, 194, 14)
		else
			outputChatBox("Backup system did not need reset.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("resettowbackup", removeBackup, false, false)

function towtruck(thePlayer, commandName)
	local theTeam = getTeamFromName("McJones Towing")
	local thePlayerTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(thePlayerTeam, "type")
	
	if (factionType==3 or getTeamName(thePlayerTeam) == "McJones Towing") then
		if (backupBlip) and (backupPlayer~=thePlayer) then -- in use
			outputChatBox("There is already a TowTruck request beacon in use.", thePlayer, 255, 194, 14)
		elseif not (backupBlip) then -- make backup blip
			backupPlayer = thePlayer
			local x, y, z = getElementPosition(thePlayer)
			backupBlip = createBlip(x, y, z, 0, 3, 255, 0, 0, 255, 255, 32767)
			exports.pool:allocateElement(backupBlip)
			attachElements(backupBlip, thePlayer)
			
			addEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			addEventHandler("savePlayer", thePlayer, destroyBlip)
			
			setElementVisibleTo(backupBlip, getRootElement(), false)
			
			for key, value in ipairs(getPlayersInTeam(theTeam)) do
				outputChatBox("An Officer requires a Tow Truck. Please respond ASAP!", value, 255, 194, 14)
				setElementVisibleTo(backupBlip, value, true)
			end
			
			
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				
				if (getPlayerTeam(value)~=theTeam) then
					setElementVisibleTo(backupBlip, value, false)
				end
			end
		elseif (backupBlip) and (backupPlayer==thePlayer) then -- in use by this player
			for key, value in ipairs(getPlayersInTeam(theTeam)) do
				outputChatBox("The Officer no longer requires a Tow Truck. Resume normal patrol", value, 255, 194, 14)
			end
			
			destroyElement(backupBlip)
			removeEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			removeEventHandler("savePlayer", thePlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = nil
		end
	end
end
addCommandHandler("towtruck", towtruck, false, false)
addEvent("savePlayer", false)

function destroyBlip()
	local theTeam = getPlayerTeam(source)
	for key, value in ipairs(getPlayersInTeam(theTeam)) do
		outputChatBox("The Officer no longer requires a Tow Truck. Resume normal patrol", value, 255, 194, 14)
	end
	destroyElement(backupBlip)
	removeEventHandler("onPlayerQuit", thePlayer, destroyBlip)
	removeEventHandler("savePlayer", thePlayer, destroyBlip)
	backupPlayer = nil
	backupBlip = nil
end