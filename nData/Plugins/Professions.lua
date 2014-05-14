local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
--	 Professions Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["pro"] = function()

	db = nData.db.profile

	local plugin = CreateFrame('Button', nil, Datapanel)
	plugin:RegisterEvent('PLAYER_ENTERING_WORLD')
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)
	plugin:EnableMouse(true)
	plugin.tooltip = false

	local Text = plugin:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.pro, Text)

	local function Update(self)
		local prof1, prof2 = GetProfessions()
			if prof1 ~= nil then
				Text:SetFormattedText(hexa.."Professions"..hexb)
			else
				Text:SetFormattedText(hexa.."No Professions"..hexb)
			end
		self:SetAllPoints(Text)
	end

	plugin:SetScript('OnEnter', function()
		if InCombatLockdown() then return end
		local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Professions")
		GameTooltip:AddLine' '		
		for i = 1, select("#", GetProfessions()) do
			local v = select(i, GetProfessions());
			if v ~= nil then
				local name, texture, rank, maxRank = GetProfessionInfo(v)
				GameTooltip:AddDoubleLine(name, rank..' / '..maxRank,.75,.9,1,.3,1,.3)
			end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Profession #1")
		GameTooltip:AddLine("|cffeda55fMiddle Click|r to Open Spell Book")
		GameTooltip:AddLine("|cffeda55fRight Click|r to Open Profession #2")
		
		GameTooltip:Show()
	end)


	plugin:SetScript("OnClick",function(self,btn)
		local prof1, prof2 = GetProfessions()
		if btn == "LeftButton" then
			if prof1 then
				if (GetProfessionInfo(prof1) == ('Herbalism')) then
					print('|cff33ff99nData:|r |cffFF0000Herbalism has no options!|r')
				elseif(GetProfessionInfo(prof1) == ('Skinning')) then
					print('|cff33ff99nData:|r |cffFF0000Skinning has no options!|r')
				elseif(GetProfessionInfo(prof1) == ('Mining')) then
					CastSpellByName("Smelting")
				else	
					CastSpellByName((GetProfessionInfo(prof1)))
				end
			else
				print('|cff33ff99nData:|r |cffFF0000No Profession Found!|r')
			end
		elseif btn == 'MiddleButton' then
			ToggleSpellBook(BOOKTYPE_PROFESSION)	
		elseif btn == "RightButton" then
			if prof2 then
				if (GetProfessionInfo(prof2) == ('Herbalism')) then
					print('|cff33ff99nData:|r |cffFF0000Herbalism has no options!|r')
				elseif(GetProfessionInfo(prof2) == ('Skinning')) then
					print('|cff33ff99nData:|r |cffFF0000Skinning has no options!|r')
				elseif(GetProfessionInfo(prof2) == ('Mining')) then
					CastSpellByName("Smelting")
				else
					CastSpellByName((GetProfessionInfo(prof2)))
				end
			else
				print('|cff33ff99nData:|r |cffFF0000No Profession Found!|r')
			end
		end
	end)


	plugin:RegisterForClicks("AnyUp")
	plugin:SetScript('OnUpdate', Update)
	plugin:SetScript('OnLeave', function() GameTooltip:Hide() end)

	return plugin -- important!
end