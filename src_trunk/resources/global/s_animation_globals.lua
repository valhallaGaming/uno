function applyAnimation(thePlayer, block, name, animtime, loop, updatePosition, forced)
	if animtime==nil then animtime=-1 end
	if loop==nil then loop=true end
	if updatePosition==nil then updatePosition=true end
	if forced==nil then forced=true end

	if isElement(thePlayer) and getElementType(thePlayer)=="player" and not getPedOccupiedVehicle(thePlayer) and getElementData(thePlayer, "freeze") ~= 1 then
		if getElementData(thePlayer, "injuriedanimation") then
			return false
		end
		toggleAllControls(thePlayer, false, true, false)
		setElementData(thePlayer, "forcedanimation", forced)
		setElementData(thePlayer, "animation", true, false)
		local setanim = setPedAnimation(thePlayer, block, name, animtime, loop, updatePosition, false)
		setTimer(setPedAnimation, 50, 2, thePlayer, block, name, animtime, loop, updatePosition, false)
		return setanim
	else
		return false
	end
end

function onSpawn()
	setPedAnimation(source)
	toggleAllControls(source, true, true, false)
	setElementData(source, "forcedanimation", false)
	setElementData(source, "animation", false, false)
end
addEventHandler("onPlayerSpawn", getRootElement(), onSpawn)

addEvent( "onPlayerStopAnimation", true )
function removeAnimation(thePlayer)
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and getElementData(thePlayer, "freeze") ~= 1 and not getElementData(thePlayer, "injuriedanimation") then
		local setanim = setPedAnimation(thePlayer)
		setElementData(thePlayer, "forcedanimation", false)
		setElementData(thePlayer, "animation", false, false)
		toggleAllControls(thePlayer, true, true, false)
		setPedAnimation(thePlayer)
		setTimer(triggerEvent, 100, 1, "onPlayerStopAnimation", thePlayer)
		return setanim
	else
		return false
	end
end