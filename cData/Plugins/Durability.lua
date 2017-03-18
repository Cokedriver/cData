local cData = LibStub("AceAddon-3.0"):GetAddon("cData")

------------------------------------------------------------------------
--	 Durability Plugin Functions
------------------------------------------------------------------------
cData.pluginConstructors["dur"] = function()

	db = cData.db.profile
	
	Slots = {
		[1] = {1, "Head", 1000},
		[2] = {3, "Shoulder", 1000},
		[3] = {5, "Chest", 1000},
		[4] = {6, "Waist", 1000},
		[5] = {9, "Wrist", 1000},
		[6] = {10, "Hands", 1000},
		[7] = {7, "Legs", 1000},
		[8] = {8, "Feet", 1000},
		[9] = {16, "Main Hand", 1000},
		[10] = {17, "Off Hand", 1000},
		[11] = {18, "Ranged", 1000}
	}


	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	cData:PlacePlugin(db.dur, Text)

	local function OnEvent(self)
		local Total = 0
		local current, max
		
		for i = 1, 11 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				current, max = GetInventoryItemDurability(Slots[i][1])
				if current then 
					Slots[i][3] = current/max
					Total = Total + 1
				end
			end
		end
		table.sort(Slots, function(a, b) return a[3] < b[3] end)
		
		if Total > 0 then
			Text:SetText(hexa.."Armor: "..hexb..floor(Slots[1][3]*100).."% |r")
		else
			Text:SetText(hexa.."Armor: "..hexb.."100% |r")
		end
		-- Setup Durability Tooltip
		self:SetAllPoints(Text)
		Total = 0
	end

	plugin:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	plugin:RegisterEvent("MERCHANT_SHOW")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:SetScript("OnMouseDown",function(self,btn)
		if btn == "LeftButton" then
			ToggleCharacter("PaperDollFrame")
		elseif btn == "RightButton" then
			CastSpellByName("Traveler's Tundra Mammoth")
		end
	end)
	plugin:SetScript("OnEvent", OnEvent)
	plugin:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = cData:DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Durability")
			GameTooltip:AddLine' '
			GameTooltip:AddDoubleLine("Current "..STAT_AVERAGE_ITEM_LEVEL, format("%.1f", GetAverageItemLevel("player")))
			GameTooltip:AddLine' '
			for i = 1, 11 do
				if Slots[i][3] ~= 1000 then
					local green, red
					green = Slots[i][3]*2
					red = 1 - green
					GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
				end
			end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cffeda55fLeft Click|r opens Character Panel.")
		GameTooltip:AddLine("|cffeda55fRight Click|r summon's Traveler's Tundra Mammoth.")
		GameTooltip:Show()
		end
	end)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)

	return plugin -- important!
end