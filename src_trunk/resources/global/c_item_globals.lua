function cdoesPlayerHaveItem(thePlayer, itemID, itemValue)
	local items = getElementData(thePlayer, "items")
	local itemvalues = getElementData(thePlayer, "itemvalues")

	for i=1, 30 do
		if not (items) or not (itemvalues) then -- no items
			return false
		else
			local token = tonumber(gettok(items, i, string.byte(',')))
			if (token) then
				if (token==itemID) then
					if (itemValue==-1) or not (itemValue) then -- any value is okay
						return true, i
					else
						
						local value = tonumber(gettok(itemvalues, i, string.byte(',')))
						local value = tonumber(gettok(itemvalues, i, string.byte(',')))
						if (value==itemValue) then
							return true, i, value
						end
					end
				end
			end
		end
	end
	return false
end

function cgetItemName(itemID)
	if (itemID==1) then
		return "Haggis"
	elseif (itemID==2) then
		return "Cellphone"
	elseif (itemID==3) then
		return "Car Key"
	elseif (itemID==4) then
		return "House Key"
	elseif (itemID==5) then
		return "Business Key"
	elseif (itemID==6) then
		return "Radio"
	elseif (itemID==7) then
		return "Phonebook"
	elseif (itemID==8) then
		return "Sandwich"
	elseif (itemID==9) then
		return "Softdrink"
	elseif (itemID==10) then
		return "Dice"
	elseif (itemID==11) then
		return "Taco"
	elseif (itemID==12) then
		return "Burger"
	elseif (itemID==13) then
		return "Donut"
	elseif (itemID==14) then
		return "Cookie"
	elseif (itemID==15) then
		return "Water"
	elseif (itemID==16) then
		return "Clothes"
	elseif (itemID==17) then
		return "Watch"
	elseif (itemID==18) then
		return "City Guide"
	elseif (itemID==19) then
		return "MP3 Player"
	elseif (itemID==20) then
		return "Standard Fighting for Dummies"
	elseif (itemID==21) then
		return "Boxing for Dummies"
	elseif (itemID==22) then
		return "Kung Fu for Dummies"
	elseif (itemID==23) then
		return "Knfee Head Fighting for Dummies"
	elseif (itemID==24) then
		return "Grab Kick Fighting for Dummies"
	elseif (itemID==25) then
		return "Elbow Fighting for Dummies"
	elseif (itemID==26) then
		return "Gas Mask"
	elseif (itemID==27) then
		return "Flashbang"
	elseif (itemID==28) then
		return "Glowstick"
	elseif (itemID==29) then
		return "Door Ram"
	else
		return false
	end
end