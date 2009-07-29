-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler~=nil) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////
local phoneState = 0
local doneDeals = 0

function timeCheck(res) -- When the resource starts check what time it is. If the time is between 1900 and 2359 spawn stevie in the steak house.
	if (res==getThisResource()) then
		
		hour, minutes = getTime()
		
		if (hour>=19) and (hour<=23) then -- If the time is between 1900 and 0000 create Stevie. Start a timer that will remove him at 0000.
			createStevie()
		else -- If the time is not between 1900 and 0000 calculate how many minutes are left start a timer to create stevie  at 1900.
			local minutesLeft = 60 - minutes
			local hoursLeft = 18 - hour
			local spawnTime = (hoursLeft*60) + minutesLeft
			stevieSpawnTimer = setTimer ( createStevie, spawnTime*60000, 1 ) -- spawn stevie at 1900
			outputDebugString("Stevie will spawn in "..spawnTime.." minutes.")			
		end
	end	
end
addEventHandler("onResourceStart", getRootElement(), timeCheck)

function createStevie()

	stevie = createPed (258, 675.89807128906, -455.46102905273, -24.4140625)
	exports.pool:allocateElement(stevie)
	setPedRotation (stevie, 180.01502990723)
	setElementInterior (stevie, 1)
	setElementDimension (stevie, 406)
	setPedFrozen(tyrese, true)
	setPedAnimation(stevie, "FOOD", "FF_Sit_Loop",  -1, true, false, true) -- Set the Peds Animation.
	setElementData(stevie, "name", "Steven Pullman")
	setElementData(stevie, "deals", 0) -- reset how many deals he has made today. Stevie will do 5 deals over the phone each day. He can't be called while he is in the game world (19:00-22:00).
	setElementData(stevie,"talk",true) -- allows the player to right click on him.
	doneDeals = 0
	
	hours,minues = getTime()
	
	local minutesLeft = 60 - minutes
	local hoursLeft = 23 - hour
	local removeTime = (hoursLeft*60) + minutesLeft
	stevieRemoveTimer = setTimer ( removeStevie, removeTime*60000, 1 ) -- remove stevie at 2200.
	outputDebugString("Stevie will leave in "..removeTime.." minutes.")
	
end

function removeStevie()
	destroyElement(stevie)
	outputDebugString("Stevie was removed.")
	stevieSpawnTimer = setTimer ( createStevie, 68400000, 1 ) -- spawn stevie at 1900	
end

function stevieIntro (thePlayer) -- When player enters the colSphere create GUI with intro output to all local players as local chat.
		
	-- Give the player the "Find Stevie" achievement.
	if(getElementData(stevie, "activeConvo")==1)then
		
		local pedX, pedY, pedZ = getElementPosition( source )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		local name = string.gsub(getPlayerName(source), "_", " ")
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("* Stevie ignores the person trying to talk to him and contiues to eat.", player,  255, 51, 102)
		end
		
	else
		
		setElementData (stevie, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
		outputDebugString("Stevie is talking.")
		
		local pedX, pedY, pedZ = getElementPosition( stevie )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("Steven Pulman says: Do you want something, pal?", player, 255, 255, 255) -- Stevies next question
		end
		
		destroyElement(chatSphere)
		talkingToStevie = source
		addEventHandler("onPlayerQuit", source, resetStevieConvoStateDelayed)
		addEventHandler("onPlayerWasted", source, resetStevieConvoStateDelayed)
	end
end
addEvent( "startStevieConvo", true )
addEventHandler( "startStevieConvo", getRootElement(), stevieIntro )

-- Quick Close
function quickClose_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	removeElementData (stevie, "activeConvo") -- set the NPCs conversation state to not active so others can begin to talk to him.
	outputDebugString("Stevie is no longer talking.")
	
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .." says: No. Sorry to bother you.", player, 255, 255, 255) -- Stevies next question
	end
	destroyElement(chatSphere)
end
addEvent( "quickCloseServerEvent", true )
addEventHandler( "quickCloseServerEvent", getRootElement(), quickClose_S )

-- Statement 2
function statement2_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5)
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Can I take a seat?", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Steven Pullman says: Sure, sit down. Have you tried the food here? It's f****** unbelievable.", player, 255, 255, 255) -- Stevies next question
	end
	destroyElement (chatSphere)
	
	-- Set players position and anim so they are sitting opposite Stevie. Freeze them so they can't move until they end the conversation
	setElementPosition (source, 675.81127929688, -457.45016479492, -24.406700134277)
	setPedRotation (source, 11.667144775391)
	exports.global:applyAnimation(source, "INT_OFFICE", "OFF_Sit_Watch", -1, false, false, true)
	
end
addEvent( "statement2ServerEvent", true )
addEventHandler( "statement2ServerEvent", getRootElement(), statement2_S )

-- Statement 3
function statement3_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	resetStevieConvoStateDelayed()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: I'm a vegetarian. The thought of those poor animals suffering for you to stuff your face makes me sick.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Hey f*** you, pal. You don't like it, go save a whale or some shit.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end	
addEvent( "statement3ServerEvent", true )
addEventHandler( "statement3ServerEvent", getRootElement(), statement3_S )

-- statement 4
function statement4_S()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Yeah I heard it's good. I was just about to order something.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Get the Angus rib-eye. You won't regret it. Where's my manners...", player, 255, 255, 255)
		outputChatBox("* Steven Pullman wipes his hands on a napkin and offers "..name.." a hand shake.", player, 255, 51, 102)
		outputChatBox("Steven Pullman says: The name's Stevie.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement4ServerEvent", true )
addEventHandler( "statement4ServerEvent", getRootElement(), statement4_S )

-- Statement 5
function statement5_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	resetStevieConvoStateDelayed()
	
	exports.global:sendLocalMeAction( source,"leaves Stevie's hand lingering in the air.")
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	for i, player in ipairs( targetPlayers ) do
		outputChatBox("Steven Pullman says: I was just being polite but if you want to be an ass about it how about you leave me to eat in peace.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end	
addEvent( "statement5ServerEvent", true )
addEventHandler( "statement5ServerEvent", getRootElement(), statement5_S )

-- Statement 6
function statement6_S()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox("* "..name.." shakes Stevie's hand.", player, 255, 51, 102)
		outputChatBox("Steven Pullman says: Me and the boys from the freight depot come down here every week.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Football and steaks make a damn good combination don't you think?", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement6ServerEvent", true )
addEventHandler( "statement6ServerEvent", getRootElement(), statement6_S )

-- Statement 7
function statement7_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	resetStevieConvoStateDelayed() -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name.." says: Are you kidding me? I've been a Beavers fan my whole life!", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: What?! The Beavers?", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: You're lucky I don't punch your lights out right here and now you piece-a beaver scum.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Look... now you made me lose my appetite.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement7ServerEvent", true )
addEventHandler( "statement7ServerEvent", getRootElement(), statement7_S )

-- Statement 8
function statement8_S()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox( name.." says: I never really liked football.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Yeah, maybe it isn't to everyone's taste. So what do you do?", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement8ServerEvent", true )
addEventHandler( "statement8ServerEvent", getRootElement(), statement8_S )

-- Statement 9
function statement9_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox( name.." says: Over worked and underappreciated. You know how it is.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Tell me about it! They got me bustin' my ass at the freight yard for change.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: See it's people like you and me that need to help each other out.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Tell you what, here's my card. You ever need anything I can help you out with, just give me a call.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	-- Give the player the "A friend of Stevie" achievement.
	
end
addEvent( "statement9ServerEvent", true )
addEventHandler( "statement9ServerEvent", getRootElement(), statement9_S )

-- Success
function stevieSuccess_S()
	
	exports.global:removeAnimation(source)
	
	resetStevieConvoStateDelayed() -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	exports.global:sendLocalMeAction( source,"takes Stevie's business card.")
	
	-- Give the player an item. Name = "Business card"  Description = "Steven Pullman, L.V. Freight Depot, Tel: 081016"  !NEEDS NEW ITEM!
	exports.global:givePlayerItem(source, 55, 1) -- change the ID.
	
	-- set the players "stevie" stat to "1" meaning they have met him and successfully made it through the conversation.
	mysql_query(handler, "UPDATE characters SET stevie='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1") -- NOT WORKING
end
addEvent( "stevieSuccessServerEvent", true )
addEventHandler( "stevieSuccessServerEvent", getRootElement(), stevieSuccess_S )

-- Close Button
function CloseButtonClick_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	resetStevieConvoStateDelayed() -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Is that the time? I have to go.", player, 255, 255, 255, false)
		outputChatBox("Steven Pullman says: You take it easy. Maybe I'll run into you again some time.", player, 255, 255, 255, false)
	end
	destroyElement (chatSphere)
end
addEvent( "CloseButtonClickServerEvent", true )
addEventHandler( "CloseButtonClickServerEvent", getRootElement(), CloseButtonClick_S )

function resetStevieConvoState()
	setElementData(stevie,"activeConvo", 0)
end


function resetStevieConvoStateDelayed()
	if talkingToStevie then
		removeEventHandler("onPlayerQuit", talkingToStevie, resetStevieConvoStateDelayed)
		removeEventHandler("onPlayerWasted", talkingToStevie, resetStevieConvoStateDelayed)
		talkingToStevie = nil
	end
	setTimer(resetStevieConvoState, 360000, 1)
end

------------------------------------------------------------------------------------
------------------------------ telephone conversation ------------------------------
------------------------------------------------------------------------------------

function startPhoneCall(thePlayer)
	if not(exports.global:doesPlayerHaveItem(thePlayer, 2)) then -- does the player have a cell phone?
		outputChatBox("You need a cellphone to call someone.", thePlayer, 255, 0, 0)
	else
		local calling = getElementData(thePlayer, "calling")
		if (calling) then -- Using phone already.
			outputChatBox("You are already using your phone.", thePlayer, 255, 0, 0)
		else
			local money = getElementData(thePlayer, "money")
			if (money<10) then
				outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
			else
				if(stevie)then -- If stevie is currently spawned (i.e., if it's between 1900 and 2200).   -- disabled while testing.
					outputChatBox("The phone you are trying to call is switched off.", thePlayer, 255, 0, 0)
				else
					if (phoneState==1) then -- is someone already speaking to stevie?
						outputChatBox("The number you are trying to call is engaged.", thePlayer, 255, 0, 0)
					else
						phoneState = 1
						setElementData(thePlayer, "calling", "stevie")
						exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 1.0, 1.0, 0.0, false, false, true)
						toggleAllControls(thePlayer, true, true, true)
						setTimer(startPhoneAnim, 1000, 2, thePlayer)
						-- are they a friend?
						local query = mysql_query(handler, "SELECT stevie FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(thePlayer)) .."'")
						local steviesFriend = tonumber(mysql_result(query, 1, 1))
						mysql_free_result(query)
						-- are they in law enforcement?
						local theTeam = getPlayerTeam(thePlayer)
						local factionType = getElementData(theTeam, "type")
						
						if not(steviesFriend==1) or (factionType==2) then
							setTimer( endCall, 6000, 1, thePlayer)
							outputChatBox("#081016 [Cellphone]: Yeah?", thePlayer)
							setTimer(outputChatBox, 3000, 1, "#081016 [Cellphone]: How did you get this number? ", thePlayer)
							setTimer(outputChatBox, 6000, 1, "#081016 [Cellphone]: Sorry you must have the wrong number, pal.", thePlayer)
							setTimer(outputChatBox, 6000, 1, "They hung up.", thePlayer)
							phoneState = 0
						else
							if(doneDeals >= 5) then
								triggerClientEvent ( thePlayer, "outOfDeals", getRootElement() ) -- Trigger Client side function to create GUI.
							else
								triggerClientEvent ( thePlayer, "showPhoneConvo", getRootElement(), factionType ) -- Trigger Client side function to create GUI.
								addEventHandler ( "onPlayerQuit", thePlayer, endCall )
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler ( "081016", startPhoneCall )

function startPhoneAnim() -- taken from phone res.
	exports.global:applyAnimation(source, "ped", "phone_talk", 1.0, 1.0, 0.0, true, true, true)
end

-------------------------
-- Declining phone deal. --
-------------------------
function declineDeal_S ()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name.. " says: Maybe another time.", player, 255, 255, 255)
	end			
	destroyElement (chatSphere)
	outputChatBox("((Steven Pullman)) #081016 [Cellphone]: Sure thing.", source)
	
	endCall(source)
	
end
addEvent( "declineSteviePhoneDeal", true )
addEventHandler( "declineSteviePhoneDeal", getRootElement(), declineDeal_S )

------------------------------
-- Accepting phone deal --
------------------------------

-- The item spawn locations. Stack the items 3 high to give 15 items in total.
locations = { } 
locations[1] = { 1610, 889.6044921875, 9.701148033142 } 
locations[2] = { 1313.4462890625, 1144.5, 9.8203125 }
locations[3] = { 1125, 1892.029296875, 9.8203125 }
locations[4] = { 1628.8, 1033.72, 9.91 }
locations[5] = { 1754.33, 682.533, 9.914 }

function acceptDeal_S( dealNumber )
	
	if(dealNumber==1)then -- work out the cost of the selected deal.
		cost = 7500
	elseif(dealNumber==2)then
		cost = 1000
	elseif(dealNumber==3)then
		cost = 15000
	elseif(dealNumber==4)then
		cost = 1000
	end
	
	local money = getElementData(source, "money")
	if (money<cost) then -- can the player afford the deal?
		outputChatBox("((Steven Pullman)) #081016 [Cellphone]: Call me when you've got some money.", source)
		outputChatBox("You can't afford to pay Stevie for the deal.", source, 255, 0, 0)
		endCall()
	else
	
		exports.global:takePlayerSafeMoney(source, cost) -- pay the money.
		outputChatBox("You have sent Stevie $".. cost .." for the deal.", source, 0, 255, 0)
		
		if (doneDeals==0)then
			local x, y, z = locations[1][1], locations[1][2], locations[1][3]
			
			stevieBlip = createBlip(x, y, z, 0, 2, 255, 127, 255)
			stevieMarker = createMarker(x, y, z, "cylinder", 2, 255, 127, 255, 150)
			stevieCol = createColSphere(x, y, z, 2)
				
			exports.pool:allocateElement(stevieBlip)
			exports.pool:allocateElement(stevieMarker)
			exports.pool:allocateElement(stevieCol)
				
			setElementVisibleTo(stevieBlip, getRootElement(), false) -- everyone can see the marker. Only the caller sees the blip.
			setElementVisibleTo(stevieBlip, source, true)
			
			setElementData(stevieCol, "dealNumber", dealNumber)
			
			addEventHandler("onColShapeHit", stevieCol, giveGoods)		
		elseif (doneDeals==1)then			
			local x, y, z = locations[2][1], locations[2][2], locations[2][3]
				
			stevieBlip2 = createBlip(x, y, z, 0, 2, 255, 127, 255)
			stevieMarker2 = createMarker(x, y, z, "cylinder", 2, 255, 127, 255, 150)
			stevieCol2 = createColSphere(x, y, z, 2)
			
			exports.pool:allocateElement(stevieBlip2)
			exports.pool:allocateElement(stevieMarker2)
			exports.pool:allocateElement(stevieCol2)
			
			setElementVisibleTo(stevieBlip2, getRootElement(), false) -- everyone can see the marker. Only the caller sees the blip.
			setElementVisibleTo(stevieBlip2, source, true)
			
			setElementData(stevieCol2, "dealNumber", dealNumber)
			
			addEventHandler("onColShapeHit", stevieCol2, giveGoods)			
		elseif (doneDeals==2)then				
			local x, y, z = locations[3][1], locations[3][2], locations[3][3]
			
			stevieBlip3 = createBlip(x, y, z, 0, 2, 255, 127, 255)
			stevieMarker3 = createMarker(x, y, z, "cylinder", 2, 255, 127, 255, 150)
			stevieCol3 = createColSphere(x, y, z, 2)
			
			exports.pool:allocateElement(stevieBlip3)
			exports.pool:allocateElement(stevieMarker3)
			exports.pool:allocateElement(stevieCol3)
			
			setElementVisibleTo(stevieBlip3, getRootElement(), false) -- everyone can see the marker. Only the caller sees the blip.
			setElementVisibleTo(stevieBlip3, source, true)
			
			setElementData(stevieCol3, "dealNumber", dealNumber)
			
			addEventHandler("onColShapeHit", stevieCol3, giveGoods)
		elseif (doneDeals==3)then
			local x, y, z = locations[4][1], locations[4][2], locations[4][3]
			
			stevieBlip4 = createBlip(x, y, z, 0, 2, 255, 127, 255)
			stevieMarker4 = createMarker(x, y, z, "cylinder", 2, 255, 127, 255, 150)
			stevieCol4 = createColSphere(x, y, z, 2)
			
			exports.pool:allocateElement(stevieBlip4)
			exports.pool:allocateElement(stevieMarker4)
			exports.pool:allocateElement(stevieCol4)
			
			setElementVisibleTo(stevieBlip4, getRootElement(), false) -- everyone can see the marker. Only the caller sees the blip.
			setElementVisibleTo(stevieBlip4, source, true)
			
			setElementData(stevieCol4, "dealNumber", dealNumber)
			
			addEventHandler("onColShapeHit", stevieCol4, giveGoods)					
		elseif (doneDeals==4)then					
			local x, y, z = locations[5][1], locations[5][2], locations[5][3]
			stevieBlip5 = createBlip(x, y, z, 0, 2, 255, 127, 255)
			stevieMarker5 = createMarker(x, y, z, "cylinder", 2, 255, 127, 255, 150)
			stevieCol5 = createColSphere(x, y, z, 2)
			
			exports.pool:allocateElement(stevieBlip5)
			exports.pool:allocateElement(stevieMarker5)
			exports.pool:allocateElement(stevieCol5)
			
			setElementVisibleTo(stevieBlip5, getRootElement(), false) -- everyone can see the marker. Only the caller sees the blip.
			setElementVisibleTo(stevieBlip5, source, true)
			
			setElementData(stevieCol5, "dealNumber", dealNumber)
			
			addEventHandler("onColShapeHit", stevieCol5, giveGoods)						
		end
		endCall() -- end the call.
		doneDeals = doneDeals + 1
	end
end
addEvent( "acceptSteviePhoneDeal", true )
addEventHandler( "acceptSteviePhoneDeal", getRootElement(), acceptDeal_S )

-- { isWeapon, item/weapon ID, Value/Ammo }
deal1={}
deal1[1] = { true, 23, 100 }	-- silenced pistol
deal1[3] = { true, 25, 30 }		-- shotgun
deal1[2] = { true, 28, 250 }	-- Uzi
deal1[4] = { true, 32, 250 }	-- tec 9

deal2={}
deal2[1] = { false, 19, 1 }		-- MP3
deal2[2] = { false, 54, 1 }		-- Ghettoblaster
deal2[3] = { false, 6, 1 }		-- radio
deal2[4] = { false, 2, 1 }		-- cellphone

deal3={}
deal3[1] = { true, 30, 500 }	-- AK47
deal3[2] = { false, 29, 1 }		-- Door ram
deal3[3] = { false, 6, 1 }		-- radio
deal3[4] = { true, 34, 10 }		-- Sniper rifle
deal3[5] = { true, 16, 6 }		-- grenade
deal3[6] = { true, 39, 4 }		-- satchel
deal3[7] = { false, 16, 287 }	-- uniform
deal3[8] = { true, 29, 500 }	-- MP5
deal3[9] = { true, 31, 400 }	-- M4
deal3[10] = { true, 17, 6 }		-- teargas

deal4={}
deal4[1] = { false, 32, 1 }		-- Lysergic acid
deal4[2] = { false, 33, 1 }		-- PCP
deal4[3] = { false, 31, 1 }		-- Cocaine Alcaloid


function giveGoods(thePlayer, dealNumber)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not(veh)then
		outputChatBox("You'll need a vehicle to carry all these items", thePlayer, 255, 0, 0)
	else
		
		local deal = getElementData(source, "dealNumber")
		
		if(source==stevieCol)then
			destroyElement(stevieBlip)
			destroyElement(stevieMarker)
			destroyElement(stevieCol)
			stevieBlip = nil
			stevieMarker = nil
			stevieCol = nil
		end
		if(source==stevieCol2)then
			destroyElement(stevieBlip2)
			destroyElement(stevieMarker2)
			destroyElement(stevieCol2)
			stevieBlip2 = nil
			stevieMarker2 = nil
			stevieCol2 = nil
		end
		if(source==stevieCol3)then
			destroyElement(stevieBlip3)
			destroyElement(stevieMarker3)
			destroyElement(stevieCol3)
			stevieBlip3 = nil
			stevieMarker3 = nil
			stevieCol3 = nil
		end
		if(source==stevieCol4)then
			destroyElement(stevieBlip4)
			destroyElement(stevieMarker4)
			destroyElement(stevieCol4)
			stevieBlip4 = nil
			stevieMarker4 = nil
			stevieCol4 = nil
		end
		if(source==stevieCol5)then
			destroyElement(stevieBlip5)
			destroyElement(stevieMarker5)
			destroyElement(stevieCol5)
			stevieBlip5 = nil
			stevieMarker5 = nil
			stevieCol5 = nil
		end
		
		-- give the player the items.
		giveItemsTimer = setTimer(givePlayerStevieItems, 2000, 21, thePlayer, veh, deal)
		exports.global:sendLocalMeAction(thePlayer,"loads the car up with packages.")
		outputChatBox("((Wait while the vehicle is loaded with the items.))", thePlayer)
		local x,y,z = getElementPosition(veh)
		collectionCol = createColSphere(x, y, z, 4)
	end
end

function givePlayerStevieItems(thePlayer, veh, deal)
	if not(isElementWithinColShape(veh, collectionCol)) then
		outputChatBox("You didn't wait to load the vehicle!", thePlayer, 255, 0, 0)
		if(giveItemsTimer)then
			killTimer(giveItemsTimer)
		end
	else
		if not(exports.global:doesVehicleHaveSpaceForItem(veh))then
			outputChatBox("The vehicle is full.", thePlayer, 255, 0, 0)
			destroyElement(collectionCol)
			collectionCol = nil
			if(giveItemsTimer)then
				killTimer(giveItemsTimer)
			end
		else
			if(deal==1)then
				local rand = math.random(1,4) -- select a random item to give the player.
				
				local isWeapon = deal1[rand][1]
				local itemID = deal1[rand][2]
				local value = deal1[rand][3]
				if(isWeapon==true)then
					exports.global:giveVehicleItem(veh, 9000+itemID, value)
				else
					exports.global:giveVehicleItem(veh, itemID, value)
				end
			elseif(deal==2)then
				local rand = math.random(1,4) -- select a random item to give the player.
				
				local isWeapon = deal2[rand][1]
				local itemID = deal2[rand][2]
				local value = deal2[rand][3]
				if(isWeapon==true)then
					exports.global:giveVehicleItem(veh, 9000+itemID, value)
				else
					exports.global:giveVehicleItem(veh, itemID, value)
				end
			elseif(deal==3)then
				local rand = math.random(1,10) -- select a random item to give the player.
				
				local isWeapon = deal3[rand][1]
				local itemID = deal3[rand][2]
				local value = deal3[rand][3]
				if(isWeapon==true)then
					exports.global:giveVehicleItem(veh, 9000+itemID, value)
				else
					exports.global:giveVehicleItem(veh, itemID, value)
				end
			elseif(deal==4)then
				local rand = math.random(1,3) -- select a random item to give the player.
				
				local isWeapon = deal4[rand][1]
				local itemID = deal4[rand][2]
				local value = deal4[rand][3]
				if(isWeapon==true)then
					exports.global:giveVehicleItem(veh, 9000+itemID, value)
				else
					exports.global:giveVehicleItem(veh, itemID, value)
				end
			end
		end
	end
end

---------------------
-- ending the call --
---------------------
function endCall(thePlayer) -- to cancel the phone animation and reset the phone states.
	if not (thePlayer) then
		thePlayer = source
	end
	exports.global:removeAnimation(thePlayer)
	toggleAllControls(thePlayer, true, true, true)
	removeElementData(thePlayer, "calling")
	exports.global:takePlayerSafeMoney(thePlayer, 10)
	phoneState = 0
	removeEventHandler ( "onPlayerQuit", thePlayer, endCall )
end
