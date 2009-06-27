pdColShape = createColSphere(285.95932006836, 204.37188720703, 1007.201171875, 10)
exports.pool:allocateElement(pdColShape)
setElementDimension(pdColShape, 1)
setElementInterior(pdColShape, 3)

pdColShape2 = createColSphere(255.3798828125, 77.3798828125, 1003.640625, 5)
exports.pool:allocateElement(pdColShape2)
setElementDimension(pdColShape2, 681)
setElementInterior(pdColShape2, 6)

esColShape = createColSphere(1581.2067871094, 1790.4083251953, 2083.3837890625, 5)
exports.pool:allocateElement(esColShape)
setElementInterior(esColShape, 4)

--- DUTY TYPE
-- 0 = NONE
-- 1 = SWAT
-- 2 = Police
-- 3 = Cadet
-- 4 = ES
-- 5 = FIRE ES

-- ES
function lvesHeal(thePlayer, commandName, targetPartialNick, price)
	if not (targetPartialNick) or not (price) then -- if missing target player arg.
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Price of Heal]", thePlayer, 255, 194, 14)
	else
	    local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
		if not (targetPlayer) then -- is the player online?
			outputChatBox("Player not found.", thePlayer, 255, 0, 0)
	    else
		    local logged = getElementData(thePlayer, "loggedin")
	
	        if (logged==1) then
	            local theTeam = getPlayerTeam(thePlayer)
		        local factionType = getElementData(theTeam, "type")
				
				if not (factionType==4) then
				    outputChatBox("You have no basic medic skills, contact the ES.", thePlayer, 255, 0, 0)
				else
			        price = tonumber(price)
				
				    local targetPlayerName = getPlayerName(targetPlayer)
		            local x, y, z = getElementPosition(thePlayer)
		            local tx, ty, tz = getElementPosition(targetPlayer)
		        
		            if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>5) then -- Are they standing next to each other?
				        outputChatBox("You are too far away to heal '"..getPlayerName(targetPlayerName).."'.", thePlayer, 255, 0, 0)
	                else
				        local money = getElementData(targetPlayer, "money")
							
					    if (price>money) then
						    outputChatBox("The player cannot afford the heal.", thePlayer, 255, 0, 0)
				        else
							exports.global:takePlayerSafeMoney(targetPlayer, price)
					        setElementHealth(targetPlayer, 100)
					        outputChatBox("You have been healed by '" ..getPlayerName(thePlayer).. "'.", targetPlayer, 0, 255, 0)
					    end
					end
				end
			end
		end
	end
end
addCommandHandler("heal", lvesHeal, false, false)

function lvesduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, esColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==4) then
				if (duty==0) then
					outputChatBox("You are now on Medic Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their uniform from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 41, 5000) -- Pepperspray
					setPedSkin(thePlayer, 276)
					
					setElementData(thePlayer, "duty", 4)
				elseif (duty==4) then -- ES
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off Medic Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their uniform into their locker.")
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==5) then -- FIRE ES
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off Firefighter Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their firefighter gear into their locker.")
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("duty", lvesduty, false, false)

-- ES FD
function lvfdduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, esColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==4) then
				if (duty==0) then
					outputChatBox("You are now on Firefighter Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their firefighter gear from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 42, 5000) -- Fire Extinguisher
					giveWeapon(thePlayer, 9, 1) -- Chainsaw
					setPedSkin(thePlayer, 278)
					
					setElementData(thePlayer, "duty", 5)
				elseif (duty==4) then -- ES
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off Medic Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their Sgear into their locker.")
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==5) then -- FIRE ES
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off Firefighter Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their firefighter gear into their locker.")
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("firefighter", lvfdduty, false, false)

function pdarmor(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape) or isElementWithinColShape(thePlayer, pdColShape2)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				outputChatBox("You now have a new armor vest.", thePlayer, 255, 194, 14)
				setPedArmor(thePlayer, 100)
			end
		end
	end
end
addCommandHandler("armor", pdarmor)

function swatduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape) or isElementWithinColShape(thePlayer, pdColShape2)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					outputChatBox("You are now on SWAT Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their swat gear from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					
					setPedArmor(thePlayer, 100)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 24, 1000) -- Deagle / MP Handgun
					giveWeapon(thePlayer, 27, 400) -- Shotgun
					giveWeapon(thePlayer, 29, 1000) -- MP5
					giveWeapon(thePlayer, 31, 5000) -- M4
					giveWeapon(thePlayer, 34, 400) -- Sniper
					giveWeapon(thePlayer, 17, 10) -- Tear gas
					
					outputChatBox("You can use /flashbang to throw a flashbang and /glowstick to drop a glowstick.", thePlayer)
					
					setPedSkin(thePlayer, 285)
					
					setElementData(thePlayer, "duty", 1)
				elseif (duty==1) then -- SWAT
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off SWAT duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their SWAT gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==2) then
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("swat", swatduty, false, false)

function policeduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape) or isElementWithinColShape(thePlayer, pdColShape2)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					outputChatBox("You are now on Police Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their gear from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					
					setPedArmor(thePlayer, 100)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 3, 1) -- Nightstick
					giveWeapon(thePlayer, 24, 1000) -- Deagle / MP Handgun
					giveWeapon(thePlayer, 25, 400) -- Shotgun
					giveWeapon(thePlayer, 29, 1000) -- MP5
					giveWeapon(thePlayer, 41, 5000) -- Pepperspray
					
					setPedSkin(thePlayer, 282)
					
					setElementData(thePlayer, "duty", 2)
				elseif (duty==1) then -- SWAT
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off SWAT duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their SWAT gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==2) then
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("duty", policeduty, false, false)

function cadetduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape) or isElementWithinColShape(thePlayer, pdColShape2)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					outputChatBox("You are now on Cadet Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their cadet gear from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					
					setPedArmor(thePlayer, 100)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 3, 1) -- Nightstick
					giveWeapon(thePlayer, 24, 1000) -- Deagle / MP Handgun
					giveWeapon(thePlayer, 41, 5000) -- Pepperspray
					
					setPedSkin(thePlayer, 71)
					
					setElementData(thePlayer, "duty", 3)
				elseif (duty==1) then -- SWAT
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off SWAT duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their SWAT gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==2) then -- POLICE
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("cadet", cadetduty, false, false)