function giveTruckingMoney(wage)
	exports.global:givePlayerSafeMoney(source, wage)
end
addEvent("giveTruckingMoney", true)
addEventHandler("giveTruckingMoney", getRootElement(), giveTruckingMoney)

function respawnTruck(vehicle)
	removePedFromVehicle(source, vehicle)
	respawnVehicle(vehicle)
	setElementData(vehicle, "locked", 0, false)
	setVehicleLocked(vehicle, false)
	setElementVelocity(vehicle,0,0,0)
end
addEvent("respawnTruck", true)
addEventHandler("respawnTruck", getRootElement(), respawnTruck)

local truck = { [414] = true }
function checkTruckingEnterVehicle(thePlayer, seat)
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and seat == 0 and truck[getElementModel(source)] and getElementData(source,"job") == 1 and getElementData(thePlayer,"job") == 1 then
		triggerClientEvent(thePlayer, "startTruckJob", thePlayer)
	end
end
addEventHandler("onVehicleEnter", getRootElement(), checkTruckingEnterVehicle)