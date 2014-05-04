local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
-- Constants (variables whose values are never altered):
------------------------------------------------------------------------
local _, class = UnitClass("player")
local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
local PLAYER_NAME = UnitName("player")
------------------------------------------------------------------------
--	 Call-To-Arms Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["calltoarms"] = function()

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
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.fontNormal, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.calltoarms, Text)
	
	local function MakeIconString(tank, healer, damage)
		local str = ""
		if tank then 
			str = str..'T'
		end
		if healer then
			str = str..', H'
		end
		if damage then
			str = str..', D'
		end	
		
		return str
	end
	
	local function MakeString(tank, healer, damage)
		local str = ""
		if tank then 
			str = str..'Tank'
		end
		if healer then
			str = str..', Healer'
		end
		if damage then
			str = str..', DPS'
		end	
		
		return str
	end

	local function OnEvent(self, event, ...)
		local tankReward = false
		local healerReward = false
		local dpsReward = false
		local unavailable = true		
		for i=1, GetNumRandomDungeons() do
			local id, name = GetLFGRandomDungeonInfo(i)
			for x = 1,LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible then unavailable = false end
				if eligible and forTank and itemCount > 0 then tankReward = true end
				if eligible and forHealer and itemCount > 0 then healerReward = true end
				if eligible and forDamage and itemCount > 0 then dpsReward = true end				
			end
		end	
		
		if unavailable then
			Text:SetText(QUEUE_TIME_UNAVAILABLE)
		else
			Text:SetText(hexa..'C to A'..hexb.." : "..MakeIconString(tankReward, healerReward, dpsReward).." ")
		end
		
		self:SetAllPoints(Text)
	end

	local function OnEnter(self)
		if InCombatLockdown() then return end
	
		local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Call to Arms")
		GameTooltip:AddLine(' ')
		
		local allUnavailable = true
		local numCTA = 0
		for i=1, GetNumRandomDungeons() do
			local id, name = GetLFGRandomDungeonInfo(i)
			local tankReward = false
			local healerReward = false
			local dpsReward = false
			local unavailable = true
			for x=1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible then unavailable = false end
				if eligible and forTank and itemCount > 0 then tankReward = true end
				if eligible and forHealer and itemCount > 0 then healerReward = true end
				if eligible and forDamage and itemCount > 0 then dpsReward = true end
			end
			if not unavailable then
				allUnavailable = false
				local rolesString = MakeString(tankReward, healerReward, dpsReward)
				if rolesString ~= ""  then 
					GameTooltip:AddDoubleLine(name.." : ", rolesString..' ', 1, 1, 1)
				end
				if tankReward or healerReward or dpsReward then numCTA = numCTA + 1 end
			end
		end
		
		if allUnavailable then 
			GameTooltip:AddLine("Could not get Call To Arms information.")
		elseif numCTA == 0 then 
			GameTooltip:AddLine("Could not get Call To Arms information.") 
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Dungeon Finder")	
		GameTooltip:AddLine("|cffeda55fRight Click|r to Open PvP Finder")			
		GameTooltip:Show()	
	end
	
	plugin:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
	plugin:RegisterEvent("PLAYER_LOGIN")
	plugin:SetScript("OnEvent", OnEvent)
	plugin:SetScript("OnMouseDown", function(self, btn)
		if btn == "LeftButton" then
			ToggleLFDParentFrame(1)
		elseif btn == "RightButton" then
			TogglePVPUI(1)
		end
	end)		
	plugin:SetScript("OnEnter", OnEnter)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	return plugin -- important!
end