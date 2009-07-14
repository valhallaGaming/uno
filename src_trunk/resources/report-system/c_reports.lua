wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, lLengthCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil

function resourceStop(res)
	if (res==getThisResource()) then
		guiSetInputEnabled(false)
		showCursor(false)
	end
end
addEventHandler("onClientResourceStop", getRootElement(), resourceStop)

function resourceStart(res)
	if (res==getThisResource()) then
		bindKey("F2", "down", toggleReport)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), resourceStart)

function toggleReport()
	executeCommandHandler("report")
end

function showReportMainUI()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	if (logged==1) then
		if (wReportMain==nil) and (wHelp==nil) then
			reportedPlayer = nil
			wReportMain = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Report System", true)
			
			-- Controls within the window
			bClose = guiCreateButton(0.775, 0.05, 0.2, 0.05, "Close", true, wReportMain)
			addEventHandler("onClientGUIClick", bClose, clickCloseButton)
			
			lWelcome = guiCreateLabel(0.025, 0.1, 1.0, 0.3, "Welcome to the Report System. \n\n This system should provide you with a live admin to chat to when and where you need it \nwhether its for a general roleplay enquiry, or you wish to report a hacker.", true, wReportMain)
			guiSetFont(lWelcome, "default-bold-small")
			guiLabelSetHorizontalAlign(lWelcome, "center", true)
			
			-- Admin help related
			pHelp = guiCreateStaticImage(0.075, 0.375, 0.04, 0.05, "help.png", true, wReportMain)
			lHelp = guiCreateLabel(0.15, 0.385, 1.0, 0.1, "Request Administrator Help", true, wReportMain)
			guiSetFont(lHelp, "default-bold-small")
			lHelpAbout = guiCreateLabel(0.15, 0.42, 0.75, 0.5, "General server, roleplay, gameplay and character enquiries should be sent via this system to our team of administrators whom are here to assist you.", true, wReportMain)
			guiLabelSetHorizontalAlign(lHelpAbout, "left", true)
			
			bHelp = guiCreateButton(0.15, 0.525, 0.75, 0.1, "I require administrator assistance!", true, wReportMain)
			addEventHandler("onClientGUIClick", bHelp, adminReportUI)
			
			-- Bug help
			pBug = guiCreateStaticImage(0.075, 0.675, 0.04, 0.05, "bug.png", true, wReportMain)
			lBug = guiCreateLabel(0.15, 0.685, 1.0, 0.1, "Report a script bug", true, wReportMain)
			guiSetFont(lBug, "default-bold-small")
			lBugAbout = guiCreateLabel(0.15, 0.72, 0.75, 0.5, "Flaws, mistakes, typo's and all bugs related to the script should be reported via \n Mantis at http://bugs.valhallagaming.net.", true, wReportMain)
			guiLabelSetHorizontalAlign(lBugAbout, "left", true)
			
			guiWindowSetSizable(wReportMain, false)
			guiBringToFront(wReportMain)
			showCursor(true)
		elseif (wReportMain~=nil) then
			guiSetVisible(wReportMain, false)
			destroyElement(wReportMain)
			
			wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp = nil
			guiSetInputEnabled(false)
			showCursor(false)
		end
	end
end
addCommandHandler("report", showReportMainUI)

-- Admin Report UI
function adminReportUI(button, state)
	local report = getElementData(getLocalPlayer(), "report")
	
	if (report) then
		outputChatBox("You already have a pending report with ID #" .. report .. ". Please wait before submitting another.", getLocalPlayer(), 255, 0, 0)
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	else
		if (source==bHelp) and (button=="left") and (state=="up") then
			if (wHelp==nil) then
				destroyElement(wReportMain)
				wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, reportedPlayer = nil
				
				guiSetInputEnabled(true)
				
				wHelp = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Request administrator help", true)
				
				-- Controls within the window
				bClose = guiCreateButton(0.775, 0.05, 0.2, 0.05, "Close", true, wHelp)
				addEventHandler("onClientGUIClick", bClose, clickCloseButton)
				
				lPlayerName = guiCreateLabel(0.025, 0.15, 1.0, 0.3, "Player you wish to report (or yourself) (Partial Name):", true, wHelp)
				guiSetFont(lPlayerName, "default-bold-small")
				
				tPlayerName = guiCreateEdit(0.525, 0.14, 0.25, 0.05, "Firstname_Lastname", true, wHelp)
				
				lNameCheck = guiCreateLabel(0.525, 0.2, 1.0, 0.3, "Player not found or multiple were found.", true, wHelp)
				guiSetFont(lNameCheck, "default-bold-small")
				guiLabelSetColor(lNameCheck, 255, 0, 0)
				addEventHandler("onClientGUIChanged", tPlayerName, checkNameExists)
				
				lReport = guiCreateLabel(0.025, 0.3, 1.0, 0.3, "Report Information:", true, wHelp)
				guiSetFont(lPlayerName, "default-bold-small")
				
				tReport = guiCreateMemo(0.225, 0.29, 0.75, 0.5, "A short description of the report.", true, wHelp)
				guiMemoSetReadOnly(tReport, true)
				addEventHandler("onClientGUIChanged", tReport, checkReportLength)
				
				lLengthCheck = guiCreateLabel(0.4, 0.81, 1.0, 0.3, "Length: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150 Characters.", true, wHelp)
				guiLabelSetColor(lLengthCheck, 0, 255, 0)
				guiSetFont(lLengthCheck, "default-bold-small")
				
				bSubmitReport = guiCreateButton(0.4, 0.875, 0.2, 0.05, "Submit Report", true, wHelp)
				addEventHandler("onClientGUIClick", bSubmitReport, submitReport)
				guiSetEnabled(bSubmitReport, false)
			end
		end
	end
end

function submitReport(button, state)
	if (source==bSubmitReport) and (button=="left") and (state=="up") then
		triggerServerEvent("clientSendReport", getLocalPlayer(), reportedPlayer, tostring(guiGetText(tReport))) 
		
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

function checkReportLength(theEditBox)
	guiSetText(lLengthCheck, "Length: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150 Characters.")

	if (tonumber(string.len(tostring(guiGetText(tReport))))-1>150) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		guiSetEnabled(bSubmitReport, false)
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1>130) then
		guiLabelSetColor(lLengthCheck, 255, 255, 0)
		guiSetEnabled(bSubmitReport, true)
	else
		guiLabelSetColor(lLengthCheck,0, 255, 0)
		guiSetEnabled(bSubmitReport, true)
	end
end
	

function checkNameExists(theEditBox)
	local found = nil
	local count = 0
	
	local players = getElementsByType("player")
	for key, value in ipairs(players) do
		local username = string.lower(tostring(getPlayerName(value)))
		if (string.find(username, string.lower(tostring(guiGetText(theEditBox))))) and (guiGetText(theEditBox)~="") then
			count = count + 1
			found = value
			break
		end
	end
	
	if (count>1) then
		guiSetText(lNameCheck, "Multiple Found.")
		guiLabelSetColor(lNameCheck, 255, 255, 0)
		guiMemoSetReadOnly(tReport, true)
		guiSetEnabled(bSubmitReport, false)
	elseif (count==1) then
		guiSetText(lNameCheck, "Player Found.")
		guiLabelSetColor(lNameCheck, 0, 255, 0)
		reportedPlayer = found
		guiMemoSetReadOnly(tReport, false)
		guiSetEnabled(bSubmitReport, true)
	elseif (count==0) then
		guiSetText(lNameCheck, "Player not found or multiple were found.")
		guiLabelSetColor(lNameCheck, 255, 0, 0)
		guiMemoSetReadOnly(tReport, true)
		guiSetEnabled(bSubmitReport, false)
	end
end

-- Close button
function clickCloseButton(button, state)
	if (source==bClose) and (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end