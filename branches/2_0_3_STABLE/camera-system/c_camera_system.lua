function cameraEffect()
	fadeCamera(false, 0.5, 255, 255, 255)
	setTimer(fadeCamera, 550, 0.5, true)
end
addEvent("cameraEffect", true)
addEventHandler("cameraEffect", getRootElement(), cameraEffect)