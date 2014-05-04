local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
-- Constants (variables whose values are never altered):
------------------------------------------------------------------------
local _, class = UnitClass("player")
local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
local PLAYER_NAME = UnitName("player")
------------------------------------------------------------------------
--	 Talent Spec Swap Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["spec"] = function()

	db = nData.db.profile

	if db.classcolor ~= true then
		local r, g, b = db.customcolor.r, db.customcolor.g, db.customcolor.b
		hexa = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
		hexb = "|r"
	else
		hexa = ("|cff%.2x%.2x%.2x"):format(classColor.r * 255, classColor.g * 255, classColor.b * 255)
		hexb = "|r"
	end		
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(db.fontNormal, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.spec, Text)

	local talent = {}
	local active
	local talentString = string.join('', '|cffFFFFFF%s|r ')
	local activeString = string.join('', '|cff00FF00' , ACTIVE_PETS, '|r')
	local inactiveString = string.join('', '|cffFF0000', FACTION_INACTIVE, '|r')



	local function LoadTalentTrees()
		for i = 1, GetNumSpecGroups(false, false) do
			talent[i] = {} -- init talent group table
			for j = 1, GetNumSpecializations(false, false) do
				talent[i][j] = select(5, GetSpecializationInfo(j, false, false, i))
			end
		end
	end

	local int = 1
	local function Update(self, t)
		int = int - t
		if int > 0 or not GetSpecialization() then return end

		active = GetActiveSpecGroup(false, false)
		Text:SetFormattedText(talentString, hexa..select(2, GetSpecializationInfo(GetSpecialization(false, false, active)))..hexb)
		int = 1

		-- disable script	
		self:SetScript('OnUpdate', nil)
	end


	plugin:SetScript('OnEnter', function(self)
		if InCombatLockdown() then return end

		local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)

		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Spec")
		GameTooltip:AddLine' '		
		for i = 1, GetNumSpecGroups() do
			if GetSpecialization(false, false, i) then
				GameTooltip:AddLine(string.join('- ', string.format(talentString, select(2, GetSpecializationInfo(GetSpecialization(false, false, i)))), (i == active and activeString or inactiveString)),1,1,1)
			end
		end
		
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Switch Spec's")		
		GameTooltip:AddLine("|cffeda55fRight Click|r to Open Talent Tree")
		GameTooltip:Show()
	end)

	plugin:SetScript('OnLeave', function() GameTooltip:Hide() end)

	local function OnEvent(self, event, ...)
		if event == 'PLAYER_ENTERING_WORLD' then
			self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		end
		
		-- load talent information
		LoadTalentTrees()

		-- Setup Talents Tooltip
		self:SetAllPoints(Text)

		-- update datatext
		if event ~= 'PLAYER_ENTERING_WORLD' then
			self:SetScript('OnUpdate', Update)
		end
	end



	plugin:RegisterEvent('PLAYER_ENTERING_WORLD');
	plugin:RegisterEvent('CHARACTER_POINTS_CHANGED');
	plugin:RegisterEvent('PLAYER_TALENT_UPDATE');
	plugin:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	plugin:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	plugin:SetScript('OnEvent', OnEvent)
	plugin:SetScript('OnUpdate', Update)

	plugin:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			SetActiveSpecGroup (active == 1 and 2 or 1)
		elseif button == "RightButton" then
			ToggleTalentFrame()
		end
	end)

	return plugin -- important!
end