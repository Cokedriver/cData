local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
--	 Friends Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["friends"] = function()

	db = nData.db.profile

	local _, _, _, broadcastText = BNGetInfo();
	
	StaticPopupDialogs["SET_BN_BROADCAST"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = BN_BROADCAST_TOOLTIP,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnAccept = function(self)
			BNSetCustomMessage(self.editBox:GetText())
		end,
		OnShow = function(self)
			self.editBox:SetText(broadcastText)
			self.editBox:SetFocus()
		end,
		OnHide = ChatEdit_FocusActiveWindow,
		EditBoxOnEnterPressed = function(self)
			BNSetCustomMessage(self:GetText())
			self:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.friends, Text)

	local menuFrame = CreateFrame("Frame", "FriendDatatextRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
		{ text = INVITE, hasArrow = true,notCheckable=true, },
		{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true, },
		{ text = PLAYER_STATUS, hasArrow = true, notCheckable=true,
			menuList = {
				{ text = "|cff2BC226"..AVAILABLE.."|r", notCheckable=true, func = function() if IsChatAFK() then SendChatMessage("", "AFK") elseif IsChatDND() then SendChatMessage("", "DND") end end },
				{ text = "|cffE7E716"..DND.."|r", notCheckable=true, func = function() if not IsChatDND() then SendChatMessage("", "DND") end end },
				{ text = "|cffFF0000"..AFK.."|r", notCheckable=true, func = function() if not IsChatAFK() then SendChatMessage("", "AFK") end end },
			},
		},
		{ text = BN_BROADCAST_TOOLTIP, notCheckable=true, func = function() StaticPopup_Show("SET_BN_BROADCAST") end },
	}

	local function GetTableIndex(table, fieldIndex, value)
		for k,v in ipairs(table) do
			if v[fieldIndex] == value then return k end
		end
		return -1
	end	
	
	local function inviteClick(self, name)
		menuFrame:Hide()
		
		if type(name) ~= 'number' then
			InviteUnit(name)
		else
			BNInviteFriend(name);
		end
	end

	local function whisperClick(self, name, battleNet)
		menuFrame:Hide() 
		
		if battleNet then
			ChatFrame_SendSmartTell(name)
		else
			SetItemRef( "player:"..name, ("|Hplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )		 
		end
	end

	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
	local clientLevelNameString = "%s (|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r"
	local levelNameClassString = "|cff%02x%02x%02x%d|r %s%s%s"
	local worldOfWarcraftString = WORLD_OF_WARCRAFT
	local battleNetString = BATTLENET_OPTIONS_LABEL
	local wowString, scString, d3String, wtcgString, appString  = "WoW", "SC2", "D3", "WTCG", "App"
	local totalOnlineString = string.join("", FRIENDS_LIST_ONLINE, ": %s/%s")
	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local displayString = string.join("", hexa.."%s:|r %d|r"..hexb)
	local statusTable = { "|cffff0000[AFK]|r", "|cffff0000[DND]|r", "" }
	local groupedTable = { "|cffaaaaaa*|r", "" } 
	local friendTable, BNTable, BNTableWoW, BNTableD3, BNTableSC, BNTableWTCG, BNTableApp = {}, {}, {}, {}, {}, {}, {}
	local tableList = {[wowString] = BNTableWoW, [d3String] = BNTableD3, [scString] = BNTableSC, [wtcgString] = BNTableWTCG, [appString] = BNTableApp}
	local totalOnline, BNTotalOnline = 0, 0

	local function BuildFriendTable(total)
		totalOnline = 0
		wipe(friendTable)
		local name, level, class, area, connected, status, note
		for i = 1, total do
			name, level, class, area, connected, status, note = GetFriendInfo(i)

			if status == "<"..AFK..">" then
				status = "|cffFFFFFF[|r|cffFF0000"..L['AFK'].."|r|cffFFFFFF]|r"
			elseif status == "<"..DND..">" then
				status = "|cffFFFFFF[|r|cffFF0000"..L['DND'].."|r|cffFFFFFF]|r"
			end
			
			if connected then 
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
				friendTable[i] = { name, level, class, area, connected, status, note }
			end
		end
		sort(friendTable, function(a, b)
			if a[1] and b[1] then
				return a[1] < b[1]
			end
		end)
	end


	local function Sort(a, b)
		if a[2] and b[2] and a[3] and b[3] then
			if a[2] == b[2] then return a[3] < b[3] end
			return a[2] < b[2]
		end
	end

	local function UpdateFriendTable(total)
		totalOnline = 0
		local name, level, class, area, connected, status, note
		for i = 1, #friendTable do
			name, level, class, area, connected, status, note = GetFriendInfo(i)
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			
			-- get the correct index in our table		
			local index = GetTableIndex(friendTable, 1, name)
			-- we cannot find a friend in our table, so rebuild it
			if index == -1 then
				BuildFriendTable(total)
				break
			end
			-- update on-line status for all members
			friendTable[index][5] = connected
			-- update information only for on-line members
			if connected then
				friendTable[index][2] = level
				friendTable[index][3] = class
				friendTable[index][4] = area
				friendTable[index][6] = status
				friendTable[index][7] = note
				totalOnline = totalOnline + 1
			end
		end
	end

	local function BuildBNTable(total)
		wipe(BNTable)
		wipe(BNTableWoW)
		wipe(BNTableD3)
		wipe(BNTableSC)
		wipe(BNTableWTCG)
		wipe(BNTableApp)


		for i = 1, total do
			local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i)			
			local hasFocus, _, _, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(toonID or presenceID);

			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			BNTable[i] = { presenceID, presenceName, battleTag, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }			
			if isOnline then 
				if client == scString then
					BNTableSC[#BNTableSC + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				elseif client == d3String then
					BNTableD3[#BNTableD3 + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				elseif client == wtcgString then
					BNTableWTCG[#BNTableWTCG + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				elseif client == appString then
					BNTableApp[#BNTableApp + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				else
					BNTableWoW[#BNTableWoW + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				end
				
				BNTotalOnline = BNTotalOnline + 1
			end
		end
		
		sort(BNTable, Sort)	
		sort(BNTableWoW, Sort)
		sort(BNTableSC, Sort)
		sort(BNTableD3, Sort)
		sort(BNTableWTCG, Sort)
		sort(BNTableApp, Sort)
	end
		

	local function UpdateBNTable(total)
		BNTotalOnline = 0
		for i = 1, #BNTable do
			-- get guild roster information
			local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i)
			local hasFocus, _, _, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(presenceID)
			
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			
			-- get the correct index in our table		
			local index = GetTableIndex(BNTable, 1, presenceID)
			-- we cannot find a BN member in our table, so rebuild it
			if index == -1 then
				BuildBNTable(total)
				return
			end
			-- update on-line status for all members
			BNTable[index][7] = isOnline
			-- update information only for on-line members
			if isOnline then
				BNTable[index][2] = presenceName
				BNTable[index][3] = battleTag
				BNTable[index][4] = toonName
				BNTable[index][5] = toonID
				BNTable[index][6] = client
				BNTable[index][8] = isAFK
				BNTable[index][9] = isDND
				BNTable[index][10] = noteText
				BNTable[index][11] = realmName
				BNTable[index][12] = faction
				BNTable[index][13] = race
				BNTable[index][14] = class
				BNTable[index][15] = zoneName
				BNTable[index][16] = level
				
				BNTotalOnline = BNTotalOnline + 1
			end
		end
	end

	plugin:SetScript("OnMouseDown", function(self, btn)
	
		GameTooltip:Hide()
		
		if btn == "RightButton" then
			local menuCountWhispers = 0
			local menuCountInvites = 0
			local factionc, classc, levelc, info
			
			menuList[2].menuList = {}
			menuList[3].menuList = {}
			
			if #friendTable > 0 then
				for i = 1, #friendTable do
					info = friendTable[i]
					if (info[5]) then
						menuCountInvites = menuCountInvites + 1
						menuCountWhispers = menuCountWhispers + 1
			
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])
						classc = classc or GetQuestDifficultyColor(info[2]);
			
						menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = inviteClick}
						menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = whisperClick}
					end
				end
			end
			if #BNTable > 0 then
				local realID, grouped
				for i = 1, #BNTable do
					info = BNTable[i]
					if (info[5]) then
						realID = info[2]
						menuCountWhispers = menuCountWhispers + 1
						menuList[3].menuList[menuCountWhispers] = {text = realID, arg1 = realID, arg2 = true, notCheckable=true, func = whisperClick}

						if info[6] == wowString and UnitFactionGroup("player") == info[12] then
							factionc, classc, levelc = info[12], (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[14]], GetQuestDifficultyColor(info[16])
							classc = classc or GetQuestDifficultyColor(info[16])

							if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
							menuCountInvites = menuCountInvites + 1
							
							menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[16],classc.r*255,classc.g*255,classc.b*255,info[4]), arg1 = info[5], notCheckable=true, func = inviteClick}
						end
					end
				end
			end

			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)	
		else
			ToggleFriendsFrame()
		end
	end)

	local function Update(self, event, ...)		
		if event == "BN_FRIEND_INFO_CHANGED" or "BN_FRIEND_ACCOUNT_ONLINE" or "BN_FRIEND_ACCOUNT_OFFLINE" or "BN_TOON_NAME_UPDATED"
				or "BN_FRIEND_TOON_ONLINE" or "BN_FRIEND_TOON_OFFLINE" or "PLAYER_ENTERING_WORLD" then
			local BNTotal = BNGetNumFriends()
			if BNTotal == #BNTable then
				UpdateBNTable(BNTotal)
			else
				BuildBNTable(BNTotal)
			end
		end
		
		if event == "FRIENDLIST_UPDATE" or "PLAYER_ENTERING_WORLD" then
			local total = GetNumFriends()
			if total == #friendTable then
				UpdateFriendTable(total)
			else
				BuildFriendTable(total)
			end
		end		

		if event == "CHAT_MSG_SYSTEM" then
			local message = select(1, ...)
			if not (find(message, friendOnline) or find(message, friendOffline)) then return end
		end
		
		-- force update when showing tooltip
		dataValid = false		
		
		Text:SetFormattedText(displayString, "Friends", totalOnline + BNTotalOnline)
		self:SetAllPoints(Text)
	end


	plugin:SetScript("OnEnter", function(self)	
		if InCombatLockdown() then return end
		
		local numberOfFriends, onlineFriends = GetNumFriends()
		local totalBNet, numBNetOnline = BNGetNumFriends()
		local totalfriends = #friendTable + #BNTable	
		local totalonline = onlineFriends + numBNetOnline
		
		-- no friends online, quick exit
		if totalonline == 0 then return end

		if not dataValid then
			-- only retrieve information for all on-line members when we actually view the tooltip
			if numberOfFriends > 0 then BuildFriendTable(numberOfFriends) end
			if totalBNet > 0 then BuildBNTable(totalBNet) end
			dataValid = true
		end
		if totalonline > 0 then
			local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(hexa..PLAYER_NAME.."'s"..hexb.." Friends", format(totalOnlineString, totalonline, totalfriends))
			if onlineFriends > 0 then
				local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
				GameTooltip:SetOwner(panel, anchor, xoff, yoff)		
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(worldOfWarcraftString)
				for i = 1, #friendTable do
					info = friendTable[i]
					if info[5] then
						if GetRealZoneText() == info[4] then zonec = activezone else zonec = inactivezone end
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])
						
						classc = classc or GetQuestDifficultyColor(info[2])
						
						if UnitInParty(info[1]) or UnitInRaid(info[1]) then grouped = 1 else grouped = 2 end
						GameTooltip:AddDoubleLine(format(levelNameClassString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],info[1],groupedTable[grouped]," "..info[6]),info[4],classc.r,classc.g,classc.b,zonec.r,zonec.g,zonec.b)
					end
				end
			end
			if numBNetOnline > 0 then
				local status = 0
				for client, BNTable in pairs(tableList) do
					if #BNTable > 0 then
						GameTooltip:AddLine(' ')
						GameTooltip:AddLine(battleNetString..' ('..client..')')			
						for i = 1, #BNTable do
							info = BNTable[i]
							if info[6] then
								if info[5] == wowString then
									if (info[7] == true) then status = 1 elseif (info[8] == true) then status = 2 else status = 3 end
									classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[13]]
									if info[15] ~= '' then
										levelc = GetQuestDifficultyColor(info[15])
									else
										levelc = RAID_CLASS_COLORS["PRIEST"]
										classc = RAID_CLASS_COLORS["PRIEST"]
									end

									if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
									GameTooltip:AddDoubleLine(format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[15],classc.r*255,classc.g*255,classc.b*255,info[3],groupedTable[grouped], 255, 0, 0, statusTable[status]),info[2],238,238,238,238,238,238)
									if IsShiftKeyDown() then
										if GetRealZoneText() == info[14] then zonec = activezone else zonec = inactivezone end
										if GetRealmName() == info[10] then realmc = activezone else realmc = inactivezone end
										GameTooltip:AddDoubleLine(info[14], info[10], zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
									end
								else
									GameTooltip:AddDoubleLine(info[3], info[2], .9, .9, .9, .9, .9, .9)
								end
							end
						end
					end
				end
			end
			GameTooltip:AddLine' '
			GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Friends List")
			GameTooltip:AddLine("|cffeda55fShift + Mouseover|r to Show Zone and Realm of Friend")
			GameTooltip:AddLine("|cffeda55fRight Click|r to Access Option Menu")			
			GameTooltip:Show()
		else 
			GameTooltip:Hide() 
		end
	end)

	plugin:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	plugin:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	plugin:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	plugin:RegisterEvent("BN_FRIEND_TOON_ONLINE")
	plugin:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
	plugin:RegisterEvent("BN_TOON_NAME_UPDATED")
	plugin:RegisterEvent("FRIENDLIST_UPDATE")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")

	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	plugin:SetScript("OnEvent", Update)

	return plugin -- important!
end