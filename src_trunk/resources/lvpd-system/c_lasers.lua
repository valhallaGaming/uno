function showLaser()
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local weapon = getPedWeapon(value)
			
			if (weapon==24 or weapon==29 or weapon==31 or weapon==34) then
				local laser = getElementData(value, "laser")
				
				if (laser==1) then
					local sx, sy, sz = getPedWeaponMuzzlePosition(value)
					local ex, ey, ez = getPedTargetEnd(value)
					local task = getPedTask(value, "secondary", 0)

					if (task=="TASK_SIMPLE_USE_GUN") then --(task=="TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(value)) then
						local collision, cx, cy, cz, element = processLineOfSight(sx, sy, sz, ex, ey, ez, true, true, true, true, true, false, false, false)
						
						if not (collision) then
							cx = ex
							cy = ey
							cz = ez
						end
						
						dxDrawLine3D(sx, sy, sz-0.1, cx, cy, cz, tocolor(255,0,0,75), 2, false, 0)
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), showLaser)

setElementData(getLocalPlayer(), "laser", 1, false)

function toggleLaser()
	local laser = getElementData(getLocalPlayer(), "laser")
	
	if (laser==0) then
		setElementData(getLocalPlayer(), "laser", 1, false)
		outputChatBox("Your weapon laser is now ON.", 0, 255, 0)
	else
		setElementData(getLocalPlayer(), "laser", 0, false)
		outputChatBox("Your weapon laser is now OFF.", 255, 0, 0)
	end
end
addCommandHandler("toglaser", toggleLaser, false)
addCommandHandler("togglelaser", toggleLaser, false)