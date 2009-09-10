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
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

----------------------[KEY BINDS]--------------------
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		setElementData(arrayPlayer, "friends.visible", 0, false)
		if not(isKeyBound(arrayPlayer, "o", "down", toggleFriends)) then
			bindKey(arrayPlayer, "o", "down", toggleFriends)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "o", "down", toggleFriends)
	
	setElementData(source, "friends.visible", 0, false)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function toggleFriends(source)
	local logged = getElementData(source, "gameaccountloggedin")
	
	if logged == 1 then
		local visible = getElementData(source, "friends.visible")
		
		if visible == 0 then -- not already showing
			local accid = tonumber(getElementData(source, "gameaccountid"))
			
			-- load friends list
			local result = mysql_query( handler, "SELECT f.friend, a.username, a.friendsmessage, a.yearday, a.year, a.country, a.os, ( SELECT COUNT(*) FROM achievements b WHERE b.account = a.id ) FROM friends f LEFT JOIN accounts a ON f.friend = a.id WHERE f.id = " .. accid )
			if result then
				local friends = { }
				for result, row in mysql_rows(result) do
					local id = tonumber( row[1] )
					local account = row[2]
					
					if account == mysql_null( ) then -- account doesn't exist any longer, drop friends
						mysql_free_result( mysql_query( handler, "DELETE FROM friends WHERE id = " .. id .. " OR friend = " .. id ) )
					else
						-- Last online
						local time = getRealTime()
						local years = (1900+time.year)
						local yearday = time.yearday

						local fyearday = tonumber( row[4] ) -- YEAR DAY
						local fyear = tonumber( row[5] ) -- YEAR
						
						local player = nil
						for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
							if isElement(value) and getElementData(value, "gameaccountid") == id then
								player = value
								break
							end
						end
						
						local state = "Offline"
						local name = nil
						
						if player then
							state = "Online"
							name = getPlayerName( player ):gsub("_", " ")
						elseif years ~= fyear then
							state = "Last Seen: Last Year"
						elseif yearday == fyearday then
							state = "Last Seen: Today"
						elseif yearday - fyearday == 1 then
							state = "Last Seen: Yesterday"
						else
							state = "Last Seen: " .. yearday - fyearday .. " days ago"
						end
							
						friends[ #friends + 1 ] = { id, account, row[3], row[6], state, name, row[7], tonumber( row[8] ) }
					end
				end
				
				mysql_free_result( result )
				
				local friendsmessage = ""
				local result = mysql_query( handler, "SELECT friendsmessage FROM accounts WHERE id = " .. accid )
				if result then
					friendsmessage = mysql_result( result, 1, 1 )
					if friendsmessage == mysql_null( ) then
						friendsmessage = ""
					end
					mysql_free_result( result )
				else
					outputDebugString( "Friendmessage load failed: " .. mysql_error( handler ) )
				end
				triggerClientEvent( source, "showFriendsList", source, friends, friendsmessage )
				setElementData(source, "friends.visible", 1)
			else
				outputDebugScript( "Friends load failed: " .. mysql_error(handler) )
				outputChatBox("Error 600000 - Could not retrieve friends list.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("sendFriends", false)
addEventHandler("sendFriends", getRootElement(), toggleFriends)

function updateFriendsMessage(message)
	local safemessage = mysql_escape_string(handler, tostring(message))
	local accid = getElementData(source, "gameaccountid")
	
	local query = mysql_query(handler, "UPDATE accounts SET friendsmessage='" .. safemessage .. "' WHERE id='" .. accid .. "'")
	if (query) then
		setElementData(source, "friends.visible", 0, false)
		mysql_free_result(query)
		toggleFriends(source)
	else
		outputChatBox("Error updating friends message - ensure you used no special characters!", source, 255, 0, 0)
	end
end
addEvent("updateFriendsMessage", true)
addEventHandler("updateFriendsMessage", getRootElement(), updateFriendsMessage)

function removeFriend(id, username, dontShowFriends)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local result = mysql_query( handler, "DELETE FROM friends WHERE id = " .. accid .. " AND friend = " .. id )
	if result then
		local friends = getElementData(source, "friends")
		if friends then
			friends[ tonumber(id) ] = nil
			setElementData(source, "friends", friends, false)
		end
		
		mysql_free_result( result )
		outputChatBox("You removed '" .. username .. "' from your friends list.", source, 255, 194, 14)
		
		setElementData(source, "friends.visible", 0, false)
		if (dontShowFriends==false) then
			toggleFriends(source)
		end
	end
end
addEvent("removeFriend", true)
addEventHandler("removeFriend", getRootElement(), removeFriend)