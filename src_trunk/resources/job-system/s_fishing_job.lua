local totalCatch = 0
local fishSize = 0

-- /fish to start fishing.
function startFishing(thePlayer)
	local element = getPedContactElement(thePlayer)
	
	if not (isElement(element)) then
		outputChatBox("You must be on a boat to fish.", thePlayer, 255, 0, 0)
	else
		if not (getElementType(element)=="vehicle") then
			outputChatBox("You must be on a boat to fish.", thePlayer, 255, 0, 0)
		else
			if not (getVehicleType(element)=="Boat") then
				outputChatBox("You must be on a boat to fish.", thePlayer, 255, 0, 0)
			else
				local x, y, z = getElementPosition(thePlayer)
					
				if (x < 3000) then -- the further out to sea you go the bigger the fish you will catch.
					outputChatBox("You must be out at sea to fish.", thePlayer, 255, 0, 0)
				else
					if not(exports.global:doesPlayerHaveItem(thePlayer, 1)) then -- does the player have the fishing rod item? ***Change the ID to the fishing rod item.***
						outputChatBox("You need a fishing rod to fish.", thePlayer, 255, 0, 0)
					else
						if (catchTimer) then -- Are they already fishing?
							outputChatBox("You have already cast your line. Wait for a fish to bite.", thePlayer, 255, 0, 0)
						else
							if (totalCatch >= 2000) then
								outputChatBox("#FF9933The boat can't hold any more fish. #FF66CCSell#FF9933 the fish you have caught before continuing.", thePlayer, 255, 104, 91, true)
							else
								--local biteTimer = math.random(60000,300000)
								local biteTimer = math.random(1000,60000)
								local catchTimer = setTimer (catchFish, biteTimer, 1, thePlayer) -- A fish will bite within 1 and 5 minutes.
								exports.global:sendLocalMeAction(thePlayer,"casts a fishing line.")
										
								if not (colSphere) then -- If the /sellfish marker isnt already being shown...
									blip = createBlip( 2248.8425292969, 576.97155761719, 7.7802104949951, 0, 2, 255, 0, 255, 255 )
									marker = createMarker( 2248.8425292969, 576.97155761719, 7.7802104949951, "cylinder", 2, 255, 0, 255, 150 )
									colsphere = createColSphere (2248.8425292969, 576.97155761719, 7.7802104949951, 3)
									
									setElementVisibleTo(blip, getRootElement(), false)
									setElementVisibleTo(blip, thePlayer, true)
									setElementVisibleTo(marker, getRootElement(), false)
									setElementVisibleTo(marker, thePlayer, true)

									outputChatBox("#FF9933When you are done fishing you can sell your catch at the fish monger ((#FF66CCblip#FF9933 added to radar)).", thePlayer, 255, 104, 91, true)
									outputChatBox("#FF9933To sell your catch enter /sellfish in the #FF66CCmarker#FF9933.)).", thePlayer, 255, 104, 91, true)
								end
							end
						end
					end
				end
			end
		end
	end
end	
addCommandHandler("fish", startFishing, false, false)

function catchFish(thePlayer)
	local lineSnap = math.random(1,10)
	if (lineSnap > 9) then
		exports.global:takePlayerItem(thePlayer, 1) -- replace item ID with fishing rod.
		exports.global:sendLocalMeAction(thePlayer,"snaps their fishing line.")
		outputChatBox("Your fishing rod has broken. You need to buy a new one to continue fishing.", thePlayer, 255, 0, 0)
	else
		local x, y, z = getElementPosition(thePlayer)
		if ( y > 4500) then -- the further out to sea you go the bigger the fish you will catch.
			fishSize = math.random(100, 300)
		elseif (x > 5500) then 
			fishSize = math.random(100, 300)
		elseif (x > 4500) then
			fishSize = math.random(75, 150)
		elseif (x > 3500) then	
			fishSize = math.random(25, 100)
		else
			fishSize = math.random(1, 50)
		end
		
		exports.global:sendLocalMeAction(thePlayer,"catches a fish weighing ".. fishSize .."lbs.")
		totalCatch = totalCatch + fishSize
		outputChatBox("You have "..totalCatch.."lbs of fish caught so far.", thePlayer, 255, 194, 14)
	end
end
function currentCatch(thePlayer)
	outputChatBox("You have "..totalCatch.."lbs of fish caught so far.", thePlayer, 255, 194, 14)
end
addCommandHandler("totalcatch", currentCatch, false, false)

function unloadCatch(thePlayer)
	if (isElementWithinColShape(thePlayer, colsphere)) then
		local profit = math.floor(totalCatch)/2
		exports.global:sendLocalMeAction(thePlayer,"sells" .. totalCatch .."lbs of fish.")
		exports.global:givePlayerSafeMoney(thePlayer, profit)
		outputChatBox("You made $".. profit .." from the fish you caught." ,thePlayer, 255, 104, 91)
		totalCatch = 0
		destroyElement(blip)
		destroyElement(marker)
		destroyElement(colsphere)
		blip=nil
		marker=nil
		colsphere=nil
	else
		outputChatBox("You need to be at the fish mongers to sell your catch.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("sellFish", unloadCatch, false, false)