local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
--	 Guild Plugin Functions
------------------------------------------------------------------------
local function RGBToHex(r, g, b)
	if r > 1 then r = 1 elseif r < 0 then r = 0 end
	if g > 1 then g = 1 elseif g < 0 then g = 0 end
	if b > 1 then b = 1 elseif b < 0 then b = 0 end
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

local function ShortValue(v)
	if v >= 1e6 then
		return format("%.1fm", v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return format("%.1fk", v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

nData.pluginConstructors["guild"] = function()

	db = nData.db.profile

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.guild, Text)
	
	local join 		= string.join
	local format 	= string.format
	local split 	= string.split	

	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local displayString = join("", hexa, GUILD, ":|r ", "%d")
	local noGuildString = join("", hexa, 'No Guild')
	local guildInfoString = "%s [%d]"
	local guildInfoString2 = join("", "Online", ": %d/%d")
	local guildMotDString = "%s |cffaaaaaa- |cffffffff%s"
	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
	local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
	local nameRankString = "%s |cff999999-|cffffffff %s"
	local guildXpCurrentString = gsub(join("", RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_CURRENT), ": ", ":|r |cffffffff", 1)
	local guildXpDailyString = gsub(join("", RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_DAILY), ": ", ":|r |cffffffff", 1)
	local standingString = join("", RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), "%s:|r |cFFFFFFFF%s/%s (%s%%)")
	local moreMembersOnlineString = join("", "+ %d ", FRIENDS_LIST_ONLINE, "...")
	local noteString = join("", "|cff999999   ", LABEL_NOTE, ":|r %s")
	local officerNoteString = join("", "|cff999999   ", GUILD_RANK1_DESC, ":|r %s")
	local groupedTable = { "|cffaaaaaa*|r", "" } 
	local MOBILE_BUSY_ICON = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t";
	local MOBILE_AWAY_ICON = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t";
	
	local guildTable, guildXP, guildMotD = {}, {}, ""
	local totalOnline = 0
	
	local function SortGuildTable(shift)
		sort(guildTable, function(a, b)
			if a and b then
				if shift then
					return a[10] < b[10]
				else
					return a[1] < b[1]
				end
			end
		end)
	end	

	local chatframetexture = ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255)
	local onlinestatusstring = "|cffFFFFFF[|r|cffFF0000%s|r|cffFFFFFF]|r"
	local onlinestatus = {
		[0] = function () return '' end,
		[1] = function () return format(onlinestatusstring, 'AFK') end,
		[2] = function () return format(onlinestatusstring, 'DND') end,
	}
	local mobilestatus = {
		[0] = function () return chatframetexture end,
		[1] = function () return MOBILE_AWAY_ICON end,
		[2] = function () return MOBILE_BUSY_ICON end,
	}

	local function BuildGuildTable()
		wipe(guildTable)
		local statusInfo
		local _, name, rank, level, zone, note, officernote, connected, memberstatus, class, isMobile
		
		local totalMembers = GetNumGuildMembers()
		for i = 1, totalMembers do
			name, rank, rankIndex, level, _, zone, note, officernote, connected, memberstatus, class, _, _, isMobile = GetGuildRosterInfo(i)

			statusInfo = isMobile and mobilestatus[memberstatus]() or onlinestatus[memberstatus]()
			zone = (isMobile and not connected) and REMOTE_CHAT or zone

			if connected or isMobile then 
				guildTable[#guildTable + 1] = { name, rank, level, zone, note, officernote, connected, statusInfo, class, rankIndex, isMobile }
			end
		end
	end

	local function UpdateGuildMessage()
		guildMotD = GetGuildRosterMOTD()
	end
	
	local FRIEND_ONLINE = select(2, split(" ", ERR_FRIEND_ONLINE_SS, 2))
	local resendRequest = false
	local eventHandlers = {
		['CHAT_MSG_SYSTEM'] = function(self, arg1)
			if(FRIEND_ONLINE ~= nil and arg1 and arg1:find(FRIEND_ONLINE)) then
				resendRequest = true
			end
		end,
		-- when we enter the world and guildframe is not available then
		-- load guild frame, update guild message and guild xp	
		["PLAYER_ENTERING_WORLD"] = function (self, arg1)
		
			if not GuildFrame and IsInGuild() then 
				LoadAddOn("Blizzard_GuildUI")
				GuildRoster() 
			end
		end,
		-- Guild Roster updated, so rebuild the guild table
		["GUILD_ROSTER_UPDATE"] = function (self)
			if(resendRequest) then
				resendRequest = false;
				return GuildRoster()
			else
				BuildGuildTable()
				UpdateGuildMessage()
				if GetMouseFocus() == self then
					self:GetScript("OnEnter")(self, nil, true)
				end
			end
		end,
		-- our guild xp changed, recalculate it	
		["PLAYER_GUILD_UPDATE"] = function (self, arg1)
			GuildRoster()
		end,
		-- our guild message of the day changed
		["GUILD_MOTD"] = function (self, arg1)
			guildMotD = arg1
		end,
		--["ELVUI_FORCE_RUN"] = function() end,
		--["ELVUI_COLOR_UPDATE"] = function() end,
	}	

	local function Update(self, event, ...)
		if IsInGuild() then
			eventHandlers[event](self, select(1, ...))

			Text:SetFormattedText(displayString, #guildTable)
		else
			Text:SetText(noGuildString)
		end
		
		self:SetAllPoints(Text)
	end
		
	local menuFrame = CreateFrame("Frame", "GuildRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
		{ text = INVITE, hasArrow = true,notCheckable=true,},
		{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true,}
	}

	local function inviteClick(self, arg1, arg2, checked)
		menuFrame:Hide()
		InviteUnit(arg1)
	end

	local function whisperClick(self,arg1,arg2,checked)
		menuFrame:Hide()
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
	end

	local function ToggleGuildFrame()
		if IsInGuild() then 
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end 
			GuildFrame_Toggle()
			GuildFrame_TabClicked(GuildFrameTab2)
		else 
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end 
			LookingForGuildFrame_Toggle() 
		end
	end

	plugin:SetScript("OnMouseUp", function(self, btn)
		if btn ~= "RightButton" or not IsInGuild() then return end
		
		GameTooltip:Hide()

		local classc, levelc, grouped
		local menuCountWhispers = 0
		local menuCountInvites = 0

		menuList[2].menuList = {}
		menuList[3].menuList = {}

		for i = 1, #guildTable do
			if (guildTable[i][7] and guildTable[i][1] ~= nDatamyname) then
				local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[guildTable[i][9]], GetQuestDifficultyColor(guildTable[i][3])

				if UnitInParty(guildTable[i][1]) or UnitInRaid(guildTable[i][1]) then
					grouped = "|cffaaaaaa*|r"
				else
					grouped = ""
					if not guildTable[i][10] then
						menuCountInvites = menuCountInvites + 1
						menuList[2].menuList[menuCountInvites] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], ""), arg1 = guildTable[i][1],notCheckable=true, func = inviteClick}
					end
				end
				menuCountWhispers = menuCountWhispers + 1
				menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], grouped), arg1 = guildTable[i][1],notCheckable=true, func = whisperClick}
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end)

	plugin:SetScript("OnEnter", function(self)
		if InCombatLockdown() or not IsInGuild() then return end
		
		local total, _, online = GetNumGuildMembers()
		if #guildTable == 0 then BuildGuildTable() end
		
		local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
		local guildName, guildRank = GetGuildInfo('player')
		
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()		
		GameTooltip:AddDoubleLine(hexa..PLAYER_NAME.."'s"..hexb.." Guild", format(guildInfoString2, online, total))
		
		SortGuildTable(IsShiftKeyDown())
		
		if guildMotD ~= "" then 
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1) 
		end
		
		local col = RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)
		
		local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
		if standingID ~= 8 then -- Not Max Rep
			barMax = barMax - barMin
			barValue = barValue - barMin
			barMin = 0
			GameTooltip:AddLine(format(standingString, COMBAT_FACTION_CHANGE, ShortValue(barValue), ShortValue(barMax), ceil((barValue / barMax) * 100)))
		end
		
		local zonec, classc, levelc, info, grouped
		local shown = 0
		
		GameTooltip:AddLine(' ')
		for i = 1, #guildTable do
			-- if more then 30 guild members are online, we don't Show any more, but inform user there are more
			if 30 - shown <= 1 then
				if online - 30 > 1 then GameTooltip:AddLine(format(moreMembersOnlineString, online - 30), ttsubh.r, ttsubh.g, ttsubh.b) end
				break
			end

			info = guildTable[i]
			if GetRealZoneText() == info[4] then zonec = activezone else zonec = inactivezone end
			classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[9]], GetQuestDifficultyColor(info[3])
			
			if (UnitInParty(info[1]) or UnitInRaid(info[1])) then grouped = 1 else grouped = 2 end

			if IsShiftKeyDown() then
				GameTooltip:AddDoubleLine(format(nameRankString, info[1], info[2]), info[4], classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
				if info[5] ~= "" then GameTooltip:AddLine(format(noteString, info[5]), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
				if info[6] ~= "" then GameTooltip:AddLine(format(officerNoteString, info[6]), ttoff.r, ttoff.g, ttoff.b, 1) end
			else
				GameTooltip:AddDoubleLine(format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, info[3], split("-", info[1]), groupedTable[grouped], info[8]), info[4], classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
			end
			shown = shown + 1
		end	
		
		GameTooltip:Show()
		
		if not noUpdate then
			GuildRoster()
		end		
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Guild Roster")
		GameTooltip:AddLine("|cffeda55fHold Shift & Mouseover|r to See Guild and Officer Note's")
		GameTooltip:AddLine("|cffeda55fRight Click|r to open Options Menu")		
		GameTooltip:Show()
	end)

	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	plugin:SetScript("OnMouseDown", function(self, btn)
		if btn ~= "LeftButton" then return end
		ToggleGuildFrame()
	end)

	plugin:RegisterEvent("GUILD_ROSTER_SHOW")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:RegisterEvent("GUILD_ROSTER_UPDATE")
	plugin:RegisterEvent("PLAYER_GUILD_UPDATE")
	plugin:SetScript("OnEvent", Update)

		return plugin -- important!
end