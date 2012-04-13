---------------------------------------------------
-- Code Source = TukUI
-- All Credit goes to programmers at www.tukui.org
---------------------------------------------------

if datatext.enable == true then

	local DataPanel = CreateFrame('Frame', 'DataPanel', UIParent)
	local PanelLeft = CreateFrame('Frame', 'PanelLeft', UIParent)
	local PanelCenter = CreateFrame('Frame', 'PanelCenter', UIParent)
	local PanelRight = CreateFrame('Frame', 'PanelRight', UIParent)
	local BattleGroundPanel = CreateFrame('Frame', 'BattleGroundPanel', UIParent)
	local ccolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass("player"))]
	local getscreenwidth = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x+%d"))
	
	
	
	if datatext.position == 'top' then
		DataPanel:SetPoint('TOP', UIParent, 0, 0)
		DataPanel:SetHeight(35)
		DataPanel:SetWidth(getscreenwidth)
		DataPanel:SetFrameStrata('LOW')
		DataPanel:SetFrameLevel(0)
		DataPanel:SetBackdropBorderColor(ccolor.r, ccolor.g, ccolor.b, 1)

		-- Left Panel
		PanelLeft:SetPoint('LEFT', DataPanel, 5, 0)
		PanelLeft:SetHeight(35)
		PanelLeft:SetWidth(getscreenwidth / 3)
		PanelLeft:SetFrameStrata('LOW')
		PanelLeft:SetFrameLevel(1)		

		-- Center Panel
		PanelCenter:SetPoint('CENTER', DataPanel, 0, 0)
		PanelCenter:SetHeight(35)
		PanelCenter:SetWidth(getscreenwidth / 3)
		PanelCenter:SetFrameStrata('LOW')
		PanelCenter:SetFrameLevel(1)		

		-- Right Panel
		PanelRight:SetPoint('RIGHT', DataPanel, -5, 0)
		PanelRight:SetHeight(35)
		PanelRight:SetWidth(getscreenwidth / 3)
		PanelRight:SetFrameStrata('LOW')
		PanelRight:SetFrameLevel(1)		

		-- Battleground Panel
		BattleGroundPanel:SetAllPoints(PanelLeft)
		BattleGroundPanel:SetFrameStrata('LOW')
		BattleGroundPanel:SetFrameLevel(1)	
		
	elseif datatext.position == 'bottom' then
		DataPanel:SetPoint('BOTTOM', UIParent, 0, 0)
		DataPanel:SetHeight(35)
		DataPanel:SetWidth(1200)
		DataPanel:SetFrameStrata('LOW')
		DataPanel:SetFrameLevel(0)
		DataPanel:SetBackdropColor(0, 0, 0, 1)
		
		-- Left Panel
		PanelLeft:SetPoint('LEFT', DataPanel, 5, 0)
		PanelLeft:SetHeight(35)
		PanelLeft:SetWidth(1200 / 3)
		PanelLeft:SetFrameStrata('LOW')
		PanelLeft:SetFrameLevel(1)		

		-- Center Panel
		PanelCenter:SetPoint('CENTER', DataPanel, 0, 0)
		PanelCenter:SetHeight(35)
		PanelCenter:SetWidth(1200 / 3)
		PanelCenter:SetFrameStrata('LOW')
		PanelCenter:SetFrameLevel(1)		

		-- Right panel
		PanelRight:SetPoint('RIGHT', DataPanel, -5, 0)
		PanelRight:SetHeight(35)
		PanelRight:SetWidth(1200 / 3)
		PanelRight:SetFrameStrata('LOW')
		PanelRight:SetFrameLevel(1)		

		-- Battleground Panel
		BattleGroundPanel:SetAllPoints(PanelLeft)
		BattleGroundPanel:SetFrameStrata('LOW')
		BattleGroundPanel:SetFrameLevel(1)
		
	elseif datatext.position == 'shortbar' then
		DataPanel:SetPoint('BOTTOM', UIParent, 0, 0)
		DataPanel:SetHeight(35)
		DataPanel:SetWidth(725)
		DataPanel:SetFrameStrata('LOW')
		DataPanel:SetFrameLevel(0)
		DataPanel:SetBackdropColor(0, 0, 0, 1)
		
		-- Left Panel
		PanelLeft:SetPoint('LEFT', DataPanel, 5, 0)
		PanelLeft:SetHeight(35)
		PanelLeft:SetWidth(725 / 2)
		PanelLeft:SetFrameStrata('LOW')
		PanelLeft:SetFrameLevel(1)				

		-- Right panel
		PanelRight:SetPoint('RIGHT', DataPanel, -5, 0)
		PanelRight:SetHeight(35)
		PanelRight:SetWidth(725 / 2)
		PanelRight:SetFrameStrata('LOW')
		PanelRight:SetFrameLevel(1)		

		-- Battleground Panel
		BattleGroundPanel:SetAllPoints(PanelLeft)
		BattleGroundPanel:SetFrameStrata('LOW')
		BattleGroundPanel:SetFrameLevel(1)		
		
	end
	
	if datatext.border == 'Tooltip' then
		DataPanel:SetBackdrop({
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",							
			edgeSize = 20,
			insets = {left = 3, right = 3, top = 3, bottom = 3},
		})
	elseif datatext.border == 'DialogBox' then
		DataPanel:SetBackdrop({
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
			edgeFile = "Interface\\AddOns\\nData\\Media\\UI-DialogBox-Border",
			edgeSize = 25,
			insets = {left = 9, right = 9, top = 9, bottom = 8}
		})
	elseif datatext.border == 'NeavUI' then
		DataPanel:SetHeight(30)
		DataPanel:SetBackdrop({
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
			edgeSize = 25
		})		
		if (IsAddOnLoaded('!Beautycase')) then
			DataPanel:CreateBorder(12)
		else
			print('|cff00B4FFn|rData: |cffFF0000!Beautycase needs to be installed for NeavUI Border. Get it at http://www.wowinterface.com/downloads/info19675-Beautycase.html|r')
		end
	end

		-- move some frames to make way for the datapanel
	if datatext.position == 'top' then

		local top = function() end
		PlayerFrame:ClearAllPoints() PlayerFrame:SetPoint("TOPLEFT", -19, -32) PlayerFrame.ClearAllPoints = top PlayerFrame.SetPoint = top
		TargetFrame:ClearAllPoints() TargetFrame:SetPoint("TOPLEFT", 250, -32) TargetFrame.ClearAllPoints = top TargetFrame.SetPoint = top
		MinimapCluster:ClearAllPoints() MinimapCluster:SetPoint('TOPRIGHT', 0, -32) MinimapCluster.ClearAllPoints = top MinimapCluster.SetPoint = top
		BuffFrame:ClearAllPoints() BuffFrame:SetPoint('TOP', MinimapCluster, -110, -5) BuffFrame.ClearAllPoints = top BuffFrame.SetPoint = top
		WorldStateAlwaysUpFrame:ClearAllPoints() WorldStateAlwaysUpFrame:SetPoint('TOP', 0, -32) WorldStateAlwaysUpFrame.ClearAllpoints = top WorldStateAlwaysUpFrame.Setpoint = top

	elseif datatext.position == 'bottom' then

		-- Move some stuff for the panel on bottom.

		local bottom = function() end
		if (IsAddOnLoaded('!Beautycase')) then
			MainMenuBar:ClearAllPoints() MainMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, 0) MainMenuBar.ClearAllPoints = bottom MainMenuBar.SetPoint = bottom
			VehicleMenuBar:ClearAllPoints() VehicleMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, 4) VehicleMenuBar.ClearAllPoints = bottom VehicleMenuBar.SetPoint = bottom
			PetActionBarFrame:ClearAllPoints() PetActionBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 40, 47) PetActionBarFrame.ClearAllPoints = bottom PetActionBarFrame.SetPoint = bottom			
		else
			MainMenuBar:ClearAllPoints() MainMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, -3) MainMenuBar.ClearAllPoints = bottom MainMenuBar.SetPoint = bottom
			VehicleMenuBar:ClearAllPoints() VehicleMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, 4) VehicleMenuBar.ClearAllPoints = bottom VehicleMenuBar.SetPoint = bottom
			PetActionBarFrame:ClearAllPoints() PetActionBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 40, 47) PetActionBarFrame.ClearAllPoints = bottom PetActionBarFrame.SetPoint = bottom	
		end
		
		-- Move the tooltip above the Actionbar	
		if datatext.position == 'shortbar' then		
			hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
				self:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -27.35, 27.35)
			end)
		else		
			hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
				self:SetPoint('BOTTOMRIGHT', UIParent, -100, 140)
			end)
		end
		
		 -- Move the Bags above the Actionbar
		CONTAINER_WIDTH = 192;
		CONTAINER_SPACING = 5;
		VISIBLE_CONTAINER_SPACING = 3;
		CONTAINER_OFFSET_Y = 70;
		CONTAINER_OFFSET_X = 0;

		 
		function updateContainerFrameAnchors()
			local _, xOffset, yOffset, _, _, _, _;
			local containerScale = 1;
			screenHeight = GetScreenHeight() / containerScale;
			-- Adjust the start anchor for bags depending on the multibars
			xOffset = CONTAINER_OFFSET_X / containerScale;
			yOffset = CONTAINER_OFFSET_Y / containerScale + 25;
			-- freeScreenHeight determines when to start a new column of bags
			freeScreenHeight = screenHeight - yOffset;
			column = 0;
			for index, frameName in ipairs(ContainerFrame1.bags) do
				frame = _G[frameName];
				frame:SetScale(containerScale);
				if ( index == 1 ) then
					-- First bag
					frame:SetPoint('BOTTOMRIGHT', frame:GetParent(), 'BOTTOMRIGHT', -xOffset, yOffset );
				elseif ( freeScreenHeight < frame:GetHeight() ) then
					-- Start a new column
					column = column + 1;
					freeScreenHeight = screenHeight - yOffset;
					frame:SetPoint('BOTTOMRIGHT', frame:GetParent(), 'BOTTOMRIGHT', -(column * CONTAINER_WIDTH) - xOffset, yOffset );
				else
					-- Anchor to the previous bag
					frame:SetPoint('BOTTOMRIGHT', ContainerFrame1.bags[index - 1], 'TOPRIGHT', 0, CONTAINER_SPACING);   
				end
				freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
			end
		end	 
	end	
end

PP = function(p, obj)

	local left = PanelLeft
	local center = PanelCenter
	local right = PanelRight
	
		-- Left Panel Data
	if p == 1 then
		obj:SetParent(left)
		obj:SetHeight(left:GetHeight())
		obj:SetPoint('LEFT', left, 30, 0)
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 2 then
		obj:SetParent(left)
		obj:SetHeight(left:GetHeight())
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 3 then
		obj:SetParent(left)
		obj:SetHeight(left:GetHeight())
		obj:SetPoint('RIGHT', left, -30, 0)
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
		
		-- Center Panel Data
	elseif p == 4 then
		obj:SetParent(center)
		obj:SetHeight(center:GetHeight())
		obj:SetPoint('LEFT', center, 30, 0)
		obj:SetPoint('TOP', center)
		obj:SetPoint('BOTTOM', center)
	elseif p == 5 then
		obj:SetParent(center)
		obj:SetHeight(center:GetHeight())
		obj:SetPoint('TOP', center)
		obj:SetPoint('BOTTOM', center)
	elseif p == 6 then
		obj:SetParent(center)
		obj:SetHeight(center:GetHeight())
		obj:SetPoint('RIGHT', center, -30, 0)
		obj:SetPoint('TOP', center)
		obj:SetPoint('BOTTOM', center)
		
		-- Right Panel Data
	elseif p == 7 then
		obj:SetParent(right)
		obj:SetHeight(right:GetHeight())
		obj:SetPoint('LEFT', right, 30, 0)
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	elseif p == 8 then
		obj:SetParent(right)
		obj:SetHeight(right:GetHeight())
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	elseif p == 9 then
		obj:SetParent(right)
		obj:SetHeight(right:GetHeight())
		obj:SetPoint('RIGHT', right, -30, 0)
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	end

end

SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH('LEFT')
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

DataTextTooltipAnchor = function(self)
	local panel = self:GetParent()
	local anchor = 'GameTooltip'
	local xoff = 1
	local yoff = 3
	
	for _, panel in pairs ({
		PanelLeft,
		PanelCenter,
		PanelRight,
	})	do
		if datatext.top == true then
			anchor = 'ANCHOR_BOTTOM'
		else
			anchor = 'ANCHOR_TOP'
		end
	end	
	
	return anchor, panel, xoff, yoff
end

SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Pulse")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

Flash = function(self, duration)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:SetLooping("REPEAT")
	self.anim:Play()
end

StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

Slots = {
	[1] = {1, 'Head', 1000},
	[2] = {3, 'Shoulder', 1000},
	[3] = {5, 'Chest', 1000},
	[4] = {6, 'Waist', 1000},
	[5] = {9, 'Wrist', 1000},
	[6] = {10, 'Hands', 1000},
	[7] = {7, 'Legs', 1000},
	[8] = {8, 'Feet', 1000},
	[9] = {16, 'Main Hand', 1000},
	[10] = {17, 'Off Hand', 1000},
	[11] = {18, 'Ranged', 1000}
}

myclass = UnitClass("player")
myname = select(1, UnitName("player"))
toc = select(4, GetBuildInfo())
myrealm = GetRealmName()

--Check Player's Role


local RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetPrimaryTalentTree()
	local resilience
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() then
		resilience = true
	else
		resilience = false
	end
	if ((myclass == "PALADIN" and tree == 2) or 
	(myclass == "WARRIOR" and tree == 3) or 
	(myclass == "DEATHKNIGHT" and tree == 1)) and
	resilience == false or
	(myclass == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		Role = "Tank"
	else
		local playerint = select(2, UnitStat("player", 4))
		local playeragi	= select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (((playerap > playerint) or (playeragi > playerint)) and not (myclass == "SHAMAN" and tree ~= 1 and tree ~= 3) and not (UnitBuff("player", GetSpellInfo(24858)) or UnitBuff("player", GetSpellInfo(65139)))) or myclass == "ROGUE" or myclass == "HUNTER" or (myclass == "SHAMAN" and tree == 2) then
			Role = "Melee"
		else
			Role = "Caster"
		end
	end
end	
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)
CheckRole()

---------------------------------------------------
-- Color system for DataText Created by Hydra 
---------------------------------------------------

local ccolor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]
hexa, hexb = datatext.colors.color, '|r'

if datatext.colors.classcolor then
	hexa = string.format('|c%02x%02x%02x%02x', 255, ccolor.r * 255, ccolor.g * 255, ccolor.b * 255)
end

---------------
-- Threat Text
---------------

if datatext.threatbar == true then

	local aggroColors = {
		[1] = {1, 0, 0},
		[2] = {1, 1, 0},
		[3] = {0, 1, 0},
	}

	local nDataThreatBar = CreateFrame("StatusBar", "nDataThreatBar", UIParent)
	nDataThreatBar:SetPoint("TOPLEFT", PanelCenter, 2, -2)
	nDataThreatBar:SetPoint("BOTTOMRIGHT", PanelCenter, -2, 2)
	nDataThreatBar:SetFrameLevel(1)

	nDataThreatBar.text = SetFontString(nDataThreatBar, media.font, 18)
	nDataThreatBar.text:SetPoint("CENTER", nDataThreatBar, 0, 0)
		 

	local function OnEvent(self, event, ...)
		local party = GetNumPartyMembers()
		local raid = GetNumRaidMembers()
		local pet = select(1, HasPetUI())
		if event == "PLAYER_ENTERING_WORLD" then
			self:Hide()
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		elseif event == "PLAYER_REGEN_ENABLED" then
			self:Hide()
		elseif event == "PLAYER_REGEN_DISABLED" then
			if party > 0 or raid > 0 or pet == 1 then
				self:Show()
			else
				self:Hide()
			end
		else
			if (InCombatLockdown()) and (party > 0 or raid > 0 or pet == 1) then
				self:Show()
			else
				self:Hide()
			end
		end
	end

	local function OnUpdate(self, event, unit)
		if UnitAffectingCombat(self.unit) then
			local _, _, threatpct, rawthreatpct, _ = UnitDetailedThreatSituation(self.unit, self.tar)
			local threatval = threatpct or 0
			
			self:SetValue(threatval)
			self.text:SetFormattedText("%s ".."%3.1f%%|r", 'Threat on current target:', threatval)
			
			if( threatval < 30 ) then
				self.text:SetTextColor(unpack(self.Colors[3]))
			elseif( threatval >= 30 and threatval < 70 ) then
				self.text:SetTextColor(unpack(self.Colors[2]))
			else
				self.text:SetTextColor(unpack(self.Colors[1]))
			end	
					
			if threatval > 0 then
				self:SetAlpha(1)
				PanelCenter:SetAlpha(0)
			else
				self:SetAlpha(0)
				PanelCenter:SetAlpha(1)
			end		
		end
	end

	nDataThreatBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	nDataThreatBar:RegisterEvent("PLAYER_REGEN_ENABLED")
	nDataThreatBar:RegisterEvent("PLAYER_REGEN_DISABLED")
	nDataThreatBar:SetScript("OnEvent", OnEvent)
	nDataThreatBar:SetScript("OnUpdate", OnUpdate)
	nDataThreatBar.unit = "player"
	nDataThreatBar.tar = nDataThreatBar.unit.."target"
	nDataThreatBar.Colors = aggroColors
	nDataThreatBar:SetAlpha(0)
end
----------------------------------
-- Datatext for Battleground Data
----------------------------------

if datatext.battleground == true then 

	--Map IDs
	local WSG = 443
	local TP = 626
	local AV = 401
	local SOTA = 512
	local IOC = 540
	local EOTS = 482
	local TBFG = 736
	local AB = 461

	local bgframe = BattleGroundPanel
	bgframe:SetScript('OnEnter', function(self)
		local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
			if ( name ) then
				if ( name == UnitName('player') ) then
					GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
					GameTooltip:ClearLines()
					GameTooltip:SetPoint('BOTTOM', self, 'TOP', 0, 1)
					GameTooltip:ClearLines()
					GameTooltip:AddLine('Stats for '..hexa..name..hexb)
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine('Killing Blows : ', killingBlows,1,1,1)
					GameTooltip:AddDoubleLine('Honorable Kills:', honorableKills,1,1,1)
					GameTooltip:AddDoubleLine('Deaths:', deaths,1,1,1)
					GameTooltip:AddDoubleLine('Honor Gained:', format('%d', honorGained),1,1,1)
					GameTooltip:AddDoubleLine('Damage Done:', damageDone,1,1,1)
					GameTooltip:AddDoubleLine('Healing Done:', healingDone,1,1,1)
					--Add extra statistics to watch based on what BG you are in.
					if curmapid == WSG or curmapid == TP then 
						GameTooltip:AddDoubleLine('Flags Captured:',GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine('Flags Returned:',GetBattlefieldStatData(i, 2),1,1,1)
					elseif curmapid == EOTS then
						GameTooltip:AddDoubleLine('Flags Captured:',GetBattlefieldStatData(i, 1),1,1,1)
					elseif curmapid == AV then
						GameTooltip:AddDoubleLine('Graveyards Assaulted:',GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine('Graveyards Defended:',GetBattlefieldStatData(i, 2),1,1,1)
						GameTooltip:AddDoubleLine('Towers Assaulted:',GetBattlefieldStatData(i, 3),1,1,1)
						GameTooltip:AddDoubleLine('Towers Defended:',GetBattlefieldStatData(i, 4),1,1,1)
					elseif curmapid == SOTA then
						GameTooltip:AddDoubleLine('Demolishers Destroyed:',GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine('Gates Destroyed:',GetBattlefieldStatData(i, 2),1,1,1)
					elseif curmapid == IOC or curmapid == TBFG or curmapid == AB then
						GameTooltip:AddDoubleLine('Bases Assaulted:',GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine('Bases Defended:',GetBattlefieldStatData(i, 2),1,1,1)
					end					
					GameTooltip:Show()
				end
			end
		end
	end) 
	bgframe:SetScript('OnLeave', function(self) GameTooltip:Hide() end)

	local Stat = CreateFrame('Frame')
	Stat:EnableMouse(true)

	local Text1  = BattleGroundPanel:CreateFontString(nil, 'OVERLAY')
	Text1:SetFont(media.font, datatext.fontsize)
	Text1:SetPoint('LEFT', BattleGroundPanel, 30, 0)
	Text1:SetHeight(PanelLeft:GetHeight())

	local Text2  = BattleGroundPanel:CreateFontString(nil, 'OVERLAY')
	Text2:SetFont(media.font, datatext.fontsize)
	Text2:SetPoint('CENTER', BattleGroundPanel, 0, 0)
	Text2:SetHeight(PanelLeft:GetHeight())

	local Text3  = BattleGroundPanel:CreateFontString(nil, 'OVERLAY')
	Text3:SetFont(media.font, datatext.fontsize)
	Text3:SetPoint('RIGHT', BattleGroundPanel, -30, 0)
	Text3:SetHeight(PanelLeft:GetHeight())

	local int = 2
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local dmgtxt
			RequestBattlefieldScoreData()
			local numScores = GetNumBattlefieldScores()
			for i=1, numScores do
				local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
				if healingDone > damageDone then
					dmgtxt = ('Healing : '..hexa..healingDone..hexb)
				else
					dmgtxt = ('Damage : '..hexa..damageDone..hexb)
				end
				if ( name ) then
					if ( name == myname ) then
						Text2:SetText('Honor : '..hexa..format('%d', honorGained)..hexb)
						Text1:SetText(dmgtxt)
						Text3:SetText('Killing Blows : '..hexa..killingBlows..hexb)
					end   
				end
			end 
			int  = 0
		end
	end

	--hide text when not in an bg
	local function OnEvent(self, event)
		if event == 'PLAYER_ENTERING_WORLD' then
			local inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == 'pvp') then			
				bgframe:Show()
				PanelLeft:Hide()
			else
				Text1:SetText('')
				Text2:SetText('')
				Text3:SetText('')
				bgframe:Hide()
				PanelLeft:Show()
			end
		end
	end

	Stat:RegisterEvent('PLAYER_ENTERING_WORLD')
	Stat:SetScript('OnEvent', OnEvent)
	Stat:SetScript('OnUpdate', Update)
	Update(Stat, 10)
end

---------------------
-- Datatext for Bags
---------------------

if datatext.bags and datatext.bags > 0 then
	local Stat = CreateFrame('Frame')
	Stat:EnableMouse(true)
	Stat:SetFrameStrata('BACKGROUND')
	Stat:SetFrameLevel(3)

	local Text  = DataPanel:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(media.font, datatext.fontsize,'THINOUTLINE')
	PP(datatext.bags, Text)

	local defaultColor = { 1, 1, 1 }
	local Profit	= 0
	local Spent		= 0
	local OldMoney	= 0	
	
	local function formatMoney(c)
		local str = ""
		if not c or c < 0 then 
			return str 
		end
		
		if c >= 10000 then
			local g = math.floor(c/10000)
			c = c - g*10000
			str = str.."|cFFFFD800"..g.."|r|TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
		end
		if c >= 100 then
			local s = math.floor(c/100)
			c = c - s*100
			str = str.."|cFFC7C7C7"..s.."|r|TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
		end
		if c >= 0 then
			str = str.."|cFFEEA55F"..c.."|r|TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
		end
		
		return str
	end
	
	local function FormatTooltipMoney(c)
		if not c then return end
		local str = ""
		if not c or c < 0 then 
			return str 
		end
		
		if c >= 10000 then
			local g = math.floor(c/10000)
			c = c - g*10000
			str = str.."|cFFFFD800"..g.."|r|TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
		end
		if c >= 100 then
			local s = math.floor(c/100)
			c = c - s*100
			str = str.."|cFFC7C7C7"..s.."|r|TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
		end
		if c >= 0 then
			str = str.."|cFFEEA55F"..c.."|r|TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
		end
		
		return str
	end	
	Stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end
		
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..myname.."'s"..hexb.." Gold")
		GameTooltip:AddLine' '			
		GameTooltip:AddLine("Session: ")
		GameTooltip:AddDoubleLine("Earned:", formatMoney(Profit), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine("Spent:", formatMoney(Spent), 1, 1, 1, 1, 1, 1)
		if Profit < Spent then
			GameTooltip:AddDoubleLine("Deficit:", formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
		elseif (Profit-Spent)>0 then
			GameTooltip:AddDoubleLine("Profit:", formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
		end				
		GameTooltip:AddLine' '								
	
		local totalGold = 0				
		GameTooltip:AddLine("Character: ")			
		for k,_ in pairs(nData[myrealm]) do
			if nData[myrealm][k]["gold"] then 
				GameTooltip:AddDoubleLine(k, FormatTooltipMoney(nData[myrealm][k]["gold"]), 1, 1, 1, 1, 1, 1)
				totalGold=totalGold+nData[myrealm][k]["gold"]
			end
		end 
		GameTooltip:AddLine' '
		GameTooltip:AddLine("Server: ")
		GameTooltip:AddDoubleLine("Total: ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

		for i = 1, MAX_WATCHED_TOKENS do
			local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
			if name and i == 1 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(CURRENCY)
			end
			if name and count then GameTooltip:AddDoubleLine(name, count, 1, 1, 1) end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fClick|r to Open Bags")			
		GameTooltip:Show()
		
	end)
	
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)		
	
	local function OnEvent(self, event)
		local totalSlots, freeSlots = 0, 0
		local itemLink, subtype, isBag
		for i = 0,NUM_BAG_SLOTS do
			isBag = true
			if i > 0 then
				itemLink = GetInventoryItemLink('player', ContainerIDToInventoryID(i))
				if itemLink then
					subtype = select(7, GetItemInfo(itemLink))
					if (subtype == 'Soul Bag') or (subtype == 'Ammo Pouch') or (subtype == 'Quiver') or (subtype == 'Mining Bag') or (subtype == 'Gem Bag') or (subtype == 'Engineering Bag') or (subtype == 'Enchanting Bag') or (subtype == 'Herb Bag') or (subtype == 'Inscription Bag') or (subtype == 'Leatherworking Bag')then
						isBag = false
					end
				end
			end
			if isBag then
				totalSlots = totalSlots + GetContainerNumSlots(i)
				freeSlots = freeSlots + GetContainerNumFreeSlots(i)
			end
			Text:SetText(hexa.."Bags: "..hexb.. freeSlots.. '/' ..totalSlots)
				if freeSlots < 6 then
					Text:SetTextColor(1,0,0)
					Flash(Text, .5)
				elseif freeSlots < 10 then
					Text:SetTextColor(1,0,0)
					Flash(Text, 1)
				elseif freeSlots > 10 then
					Text:SetTextColor(1,1,1)
					StopFlash(Text)
				end
			self:SetAllPoints(Text)
			
		end	
		if event == "PLAYER_LOGIN" then
			OldMoney = GetMoney()
		end
		
		local NewMoney	= GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money
		
		if OldMoney>NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Moeny
			Profit = Profit + Change
		end
		
		-- Setup Money Tooltip
		self:SetAllPoints(Text)

		if (nData == nil) then nData = {}; end
		if (nData[myrealm] == nil) then nData[myrealm] = {} end
		if (nData[myrealm][myname] == nil) then nData[myrealm][myname] = {} end
		nData[myrealm][myname]["gold"] = GetMoney()
		nData.gold = nil -- old
			
		OldMoney = NewMoney			
	end
	
	Stat:RegisterEvent("PLAYER_MONEY")
	Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
	Stat:RegisterEvent("PLAYER_TRADE_MONEY")
	Stat:RegisterEvent("TRADE_MONEY_CHANGED")         
	Stat:RegisterEvent('PLAYER_LOGIN')
	Stat:RegisterEvent('BAG_UPDATE')
	Stat:SetScript('OnMouseDown', 
		function()
			if datatext.bag == true then
				ToggleBag(0)
			elseif datatext.bag == false then
				ToggleAllBags()
			end
		end
	)	


		-- reset gold data
	local function RESETGOLD()		
		for k,_ in pairs(nData[myrealm]) do
			nData[myrealm][k].gold = nil
		end 
		if (nData == nil) then nData = {}; end
		if (nData[myrealm] == nil) then nData[myrealm] = {} end
		if (nData[myrealm][myname] == nil) then nData[myrealm][myname] = {} end
		nData[myrealm][myname]["gold"] = GetMoney()		
	end
	SLASH_RESETGOLD1 = "/resetgold"
	SlashCmdList["RESETGOLD"] = RESETGOLD	
	Stat:SetScript('OnEvent', OnEvent)
end


----------------------------------
-- Datatext for Call To Arms Data
----------------------------------

if datatext.calltoarms and datatext.calltoarms > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.calltoarms, Text)
	
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
			Text:SetText(hexa..BATTLEGROUND_HOLIDAY..hexb.." : "..MakeIconString(tankReward, healerReward, dpsReward).." ")
		end
		
		self:SetAllPoints(Text)
	end

	local function OnEnter(self)
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..myname.."'s"..hexb.." Call to Arms")
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
			GameTooltip:AddLine('Could not get Call To Arms information.')
		elseif numCTA == 0 then 
			GameTooltip:AddLine('No dungeons are currently offering a Call To Arms.') 
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fClick|r to Open Dungeon Finder")		
		GameTooltip:Show()		
	end
    
	Stat:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function() ToggleFrame(LFDParentFrame) end)
	Stat:SetScript("OnEnter", OnEnter)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

------------------------------
-- Datatext for Player Coords
------------------------------

if datatext.coords and datatext.coords > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata('BACKGROUND')
	Stat:SetFrameLevel(3)

	local Text = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.coords, Text)

	local function Update(self)
	local px,py=GetPlayerMapPosition("player")
		Text:SetText(format("%i , %i",px*100,py*100))
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end

-------------------------
-- Datatext for CURRENCY
-------------------------

if datatext.currency and datatext.currency > 0 then
	local Stat = CreateFrame('Frame')
	Stat:EnableMouse(true)
	Stat:SetFrameStrata('BACKGROUND')
	Stat:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.currency, Text)
	
	local function update()
		local _text = '---'
		for i = 1, MAX_WATCHED_TOKENS do
			local name, count, _, _, _ = GetBackpackCurrencyInfo(i)
			if name and count then
				if(i ~= 1) then _text = _text .. ' ' else _text = '' end
				words = { strsplit(' ', name) }
				for _, word in ipairs(words) do
					_text = _text .. string.sub(word,1,1)
				end
				_text = _text .. ': ' .. count
			end
		end
		
		Text:SetText(_text)
	end
	
	local function OnEvent(self, event, ...)
		update()
		self:SetAllPoints(Text)
		Stat:UnregisterEvent('PLAYER_LOGIN')	
	end

	Stat:RegisterEvent('PLAYER_LOGIN')	
	hooksecurefunc('BackpackTokenFrame_Update', update)
	Stat:SetScript('OnEvent', OnEvent)
	Stat:SetScript('OnMouseDown', function() ToggleCharacter('TokenFrame') end)
end

----------------------------
-- Datatext for DPS Feed... 
----------------------------

if datatext.dps_text and datatext.dps_text > 0 then
	local events = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true}
	local DPS_FEED = CreateFrame('Frame')
	local player_id = UnitGUID('player')
	local dmg_total, last_dmg_amount = 0, 0
	local cmbt_time = 0

	local pet_id = UnitGUID('pet')
     
	local dText = PanelLeft:CreateFontString(nil, 'OVERLAY')
	dText:SetFont(media.font, datatext.fontsize)
	dText:SetText('DPS: ', '0')

	PP(datatext.dps_text, dText)

	DPS_FEED:EnableMouse(true)
	DPS_FEED:SetFrameStrata('BACKGROUND')
	DPS_FEED:SetFrameLevel(3)
	DPS_FEED:SetHeight(20)
	DPS_FEED:SetWidth(100)
	DPS_FEED:SetAllPoints(dText)

	DPS_FEED:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
	DPS_FEED:RegisterEvent('PLAYER_LOGIN')

	DPS_FEED:SetScript('OnUpdate', function(self, elap)
		if UnitAffectingCombat('player') then
			cmbt_time = cmbt_time + elap
		end
       
		dText:SetText(getDPS())
	end)
     
	function DPS_FEED:PLAYER_LOGIN()
		DPS_FEED:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		DPS_FEED:RegisterEvent('PLAYER_REGEN_ENABLED')
		DPS_FEED:RegisterEvent('PLAYER_REGEN_DISABLED')
		DPS_FEED:RegisterEvent('UNIT_PET')
		player_id = UnitGUID('player')
		DPS_FEED:UnregisterEvent('PLAYER_LOGIN')
	end
     
	function DPS_FEED:UNIT_PET(unit)
		if unit == 'player' then
			pet_id = UnitGUID('pet')
		end
	end
	
	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function DPS_FEED:COMBAT_LOG_EVENT_UNFILTERED(...)		   
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end

		-- only use events from the player
		local id = select(4, ...)
		   
		if id == player_id or id == pet_id then
			if select(2, ...) == "SWING_DAMAGE" then
				if toc < 40200 then
					last_dmg_amount = select(10, ...)
				else
					last_dmg_amount = select(12, ...)
				end
			else
				if toc < 40200 then
					last_dmg_amount = select(13, ...)
				else
					last_dmg_amount = select(15, ...)
				end
			end
			dmg_total = dmg_total + last_dmg_amount
		end       
	end
     
	function getDPS()
		if (dmg_total == 0) then
			return (hexa..'DPS: '..hexb..'0')
		else
			return string.format('%.1f ' ..hexa..'DPS: '..hexb, (dmg_total or 0) / (cmbt_time or 1))
		end
	end

	function DPS_FEED:PLAYER_REGEN_ENABLED()
		dText:SetText(getDPS())
	end
	
	function DPS_FEED:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
	end
     
	DPS_FEED:SetScript('OnMouseDown', function (self, button, down)
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
	end)
end

---------------------------
-- Datatext for DURABILITY
---------------------------
	
if datatext.dur and datatext.dur > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.dur, Text)

	local Total = 0
	local current, max

	local function OnEvent(self)
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
			Text:SetText(hexa..'Armor: '..hexb..floor(Slots[1][3]*100).."%")
		else
			Text:SetText(hexa..'Armor: '..hexb.."100%")
		end
		-- Setup Durability Tooltip
		self:SetAllPoints(Text)
		Total = 0
	end

	Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	Stat:RegisterEvent("MERCHANT_SHOW")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(hexa..myname.."'s"..hexb.." Armor")			
			for i = 1, 11 do
				if Slots[i][3] ~= 1000 then
					green = Slots[i][3]*2
					red = 1 - green
					GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
				end
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cffeda55fClick|r to Open Character Panel")
			GameTooltip:Show()
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-----------------------------
-- Datatext for Friends List
-----------------------------

if datatext.friends and datatext.friends > 0 then

	StaticPopupDialogs.SET_BN_BROADCAST = {
		text = BN_BROADCAST_TOOLTIP,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnAccept = function(self) BNSetCustomMessage(self.editBox:GetText()) end,
		OnShow = function(self) self.editBox:SetText(select(3, BNGetInfo()) ) self.editBox:SetFocus() end,
		OnHide = ChatEdit_FocusActiveWindow,
		EditBoxOnEnterPressed = function(self) BNSetCustomMessage(self:GetText()) self:GetParent():Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}

	-- localized references for global functions (about 50% faster)
	local join 			= string.join
	local find			= string.find
	local format		= string.format
	local sort			= table.sort

	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.friends, Text)

	local menuFrame = CreateFrame("Frame", "ElvuiFriendRightClickMenu", UIParent, "UIDropDownMenuTemplate")
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

	local function inviteClick(self, arg1, arg2, checked)
		menuFrame:Hide()
		InviteUnit(arg1)
	end

	local function whisperClick(self,arg1,arg2,checked)
		menuFrame:Hide() 
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )		 
	end

	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
	local clientLevelNameString = "%s |cff%02x%02x%02x(%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r"
	local levelNameClassString = "|cff%02x%02x%02x%d|r %s%s%s"
	local worldOfWarcraftString = "World of Warcraft"
	local battleNetString = "Battle.NET"
	local wowString = "WoW"
	local otherGameInfoString = "%s (%s)"
	local otherGameInfoString2 = "%s %s"
	local totalOnlineString = join("", FRIENDS_LIST_ONLINE, ": %s/%s")
	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local displayString = join("", "%s: ", "%d|r")
	local statusTable = { 'AFK', 'DND', "" }
	local groupedTable = { "|cffaaaaaa*|r", "" } 
	local friendTable, BNTable = {}, {}
	local friendOnline, friendOffline = gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(ERR_FRIEND_OFFLINE_S,"%%s","")
	local dataValid = false

	local function BuildFriendTable(total)
		wipe(friendTable)
		local name, level, class, area, connected, status, note
		for i = 1, total do
			name, level, class, area, connected, status, note = GetFriendInfo(i)
			
			if connected then 
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				friendTable[i] = { name, level, class, area, connected, status, note }
			end
		end
		sort(friendTable, function(a, b)
			if a[1] and b[1] then
				return a[1] < b[1]
			end
		end)
	end

	local function BuildBNTable(total)
		wipe(BNTable)
		local presenceID, givenName, surname, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level
		for i = 1, total do
			presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
			
			if isOnline then 
				_, _, _, realmName, faction, _, race, class, _, zoneName, level = BNGetToonInfo(presenceID)
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				BNTable[i] = { presenceID, givenName, surname, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
			end
		end
		sort(BNTable, function(a, b)
			if a[2] and b[2] then
				if a[2] == b[2] then return a[3] < b[3] end
				return a[2] < b[2]
			end
		end)
	end

	local function Update(self, event, ...)
		local _, onlineFriends = GetNumFriends()
		local _, numBNetOnline = BNGetNumFriends()

		-- special handler to detect friend coming online or going offline
		-- when this is the case, we invalidate our buffered table and update the 
		-- datatext information
		if event == "CHAT_MSG_SYSTEM" then
			local message = select(1, ...)
			if not (find(message, friendOnline) or find(message, friendOffline)) then return end
		end

		-- force update when showing tooltip
		dataValid = false

		Text:SetFormattedText(displayString, hexa..'Friends'..hexb, onlineFriends + numBNetOnline)
		self:SetAllPoints(Text)
	end

	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn ~= "RightButton" then return end
		
		GameTooltip:Hide()
		
		local menuCountWhispers = 0
		local menuCountInvites = 0
		local classc, levelc, info
		
		menuList[2].menuList = {}
		menuList[3].menuList = {}
		
		if #friendTable > 0 then
			for i = 1, #friendTable do
				info = friendTable[i]
				if (info[5]) then
					menuCountInvites = menuCountInvites + 1
					menuCountWhispers = menuCountWhispers + 1
		
					classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])
					if classc == nil then classc = GetQuestDifficultyColor(info[2]) end
		
					menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = inviteClick}
					menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = whisperClick}
				end
			end
		end
		if #BNTable > 0 then
			local realID, playerFaction, grouped
			for i = 1, #BNTable do
				info = BNTable[i]
				if (info[7]) then
					realID = (BATTLENET_NAME_FORMAT):format(info[2], info[3])
					menuCountWhispers = menuCountWhispers + 1
					menuList[3].menuList[menuCountWhispers] = {text = realID, arg1 = realID,notCheckable=true, func = whisperClick}

					if select(1, UnitFactionGroup("player")) == "Horde" then playerFaction = 0 else playerFaction = 1 end
					if info[6] == wowString and info[11] == myrealm and playerFaction == info[12] then
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[14]], GetQuestDifficultyColor(info[16])
						if classc == nil then classc = GetQuestDifficultyColor(info[16]) end

						if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
						menuCountInvites = menuCountInvites + 1
						menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[16],classc.r*255,classc.g*255,classc.b*255,info[4]), arg1 = info[4],notCheckable=true, func = inviteClick}
					end
				end
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end)
		
	Stat:SetScript("OnMouseDown", function(self, btn) if btn == "LeftButton" then ToggleFriendsFrame(1) end end)

	Stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end

		local numberOfFriends, onlineFriends = GetNumFriends()
		local totalBNet, numBNetOnline = BNGetNumFriends()
			
		local totalonline = onlineFriends + numBNetOnline
		
		-- no friends online, quick exit
		if totalonline == 0 then return end

		if not dataValid then
			-- only retrieve information for all on-line members when we actually view the tooltip
			if numberOfFriends > 0 then BuildFriendTable(numberOfFriends) end
			if totalBNet > 0 then BuildBNTable(totalBNet) end
			dataValid = true
		end

		local totalfriends = numberOfFriends + totalBNet
		local zonec, classc, levelc, realmc, info

		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine('Friends list:', format(totalOnlineString, totalonline, totalfriends),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
		if onlineFriends > 0 then
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(worldOfWarcraftString)
			for i = 1, #friendTable do
				info = friendTable[i]
				if info[5] then
					if GetRealZoneText() == info[4] then zonec = activezone else zonec = inactivezone end
					classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])
					if classc == nil then classc = GetQuestDifficultyColor(info[2]) end
					
					if UnitInParty(info[1]) or UnitInRaid(info[1]) then grouped = 1 else grouped = 2 end
					GameTooltip:AddDoubleLine(format(levelNameClassString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],info[1],groupedTable[grouped]," "..info[6]),info[4],classc.r,classc.g,classc.b,zonec.r,zonec.g,zonec.b)
				end
			end
		end

		if numBNetOnline > 0 then
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(battleNetString)

			local status = 0
			for i = 1, #BNTable do
				info = BNTable[i]
				if info[7] then
					if info[6] == wowString then
						if (info[8] == true) then status = 1 elseif (info[9] == true) then status = 2 else status = 3 end
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[14]], GetQuestDifficultyColor(info[16])
						
						if classc == nil then classc = GetQuestDifficultyColor(info[16]) end
						
						if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
						GameTooltip:AddDoubleLine(format(clientLevelNameString, info[6],levelc.r*255,levelc.g*255,levelc.b*255,info[16],classc.r*255,classc.g*255,classc.b*255,info[4],groupedTable[grouped], 255, 0, 0, statusTable[status]),info[2].." "..info[3],238,238,238,238,238,238)
						if IsShiftKeyDown() then
							if GetRealZoneText() == info[15] then zonec = activezone else zonec = inactivezone end
							if GetRealmName() == info[11] then realmc = activezone else realmc = inactivezone end
							GameTooltip:AddDoubleLine(info[15], info[11], zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
						end
					else
						GameTooltip:AddDoubleLine(format(otherGameInfoString, info[6], info[4]), format(otherGameInfoString2, info[2], info[3]), .9, .9, .9, .9, .9, .9)
					end
				end
			end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fClick|r to Open Friend's List")		
		GameTooltip:Show()	
	end)

	Stat:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	Stat:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	Stat:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	Stat:RegisterEvent("BN_FRIEND_TOON_ONLINE")
	Stat:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
	Stat:RegisterEvent("BN_TOON_NAME_UPDATED")
	Stat:RegisterEvent("FRIENDLIST_UPDATE")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("CHAT_MSG_SYSTEM")

	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnEvent", Update)
end

-----------------------------
-- Datatext for Guild Roster
-----------------------------

local USE_EPGP = true

if datatext.guild and datatext.guild > 0 then	

	function sortGuildByRank(a,b)

		texta = string.format("%02d",a.rankIndex)..a.name
		textb = string.format("%02d",b.rankIndex)..b.name

		return texta<textb
	end

	function sortGuildByName(a,b)
		texta = a.name
		textb = b.name

		return texta<textb
	end

	function sortGuildByZone(a,b)

		texta = a.zone..a.name
		textb = b.zone..b.name

		return texta<textb
	end

	sortGuildFunc = sortGuildByName

	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local tthead = {r=0.4,g=0.78,b=1}
	local ttsubh = {r=0.75,g=0.9,b=1}

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.guild, Text)

	local BASE_GP = 1
	local function ParseGuildInfo(info)
		BASE_GP = 1
		local v
		local lines = {string.split("\n", info)}
		for _,line in pairs(lines) do
			v = string.match(line,"@BASE_GP:(%d+)")
			if(v) then
				BASE_GP = v
				break
			end
		end
	end

	local displayString = string.join("", hexa..GUILD..hexb, ": ", "%d|r")

	local function Update(self, event, ...)	

		if (event=="ADDON_LOADED") then

			if USE_EPGP then
				ParseGuildInfo(GetGuildInfoText())
			end

		else
			if IsInGuild() then
				GuildRoster()
				local numOnline = (GetNumGuildMembers())
				local total = (GetNumGuildMembers())
				local numOnline = 0
				for i = 1, total do
					local _, _, _, _, _, _, _, _, online, _, _ = GetGuildRosterInfo(i)
					if online then
						numOnline = numOnline + 1
					end
				end 			

				Text:SetFormattedText(displayString, numOnline)
				self:SetAllPoints(Text)
			else
				Text:SetText(hexa..'No Guild'..hexb)
			end
		end
	end

	local guildMenuFrame = nil

	function setGuildSort(self,fun)

		guildMenuFrame:Hide()
		sortGuildFunc = fun
	end	

	local guildMenuList = {
		{ text = "Select an Option", isTitle = true,notCheckable=true},
		{ text = "Invite", hasArrow = true,notCheckable=true,
			menuList = {
				{ text = "Option 3", func = function() print("You've chosen option 3"); end }
			}
		},
		{ text = "Whisper", hasArrow = true,notCheckable=true,
			menuList = {
				{ text = "Option 4", func = function() print("You've chosen option 4"); end }
			}
		},
		{ text = "Sort", hasArrow = true,notCheckable=true,
			menuList = {
				{ notCheckable=true,text = "Name", func = setGuildSort, arg1=sortGuildByName},
				{ notCheckable=true,text = "Zone", func = setGuildSort, arg1=sortGuildByZone},
				{ notCheckable=true,text = "Rank", func = setGuildSort, arg1=sortGuildByRank},
			}
		}
	}

	if USE_EPGP then

		function sortEPGP(a,b)
			if a.PR == b.PR then
				return a.name < b.name
			else
				return a.PR>b.PR
			end
		end

		guildMenuList[4].menuList[4] = { notCheckable=true,text = "EPGP (PR)", func = setGuildSort, arg1=sortEPGP}
	end

	function inviteFriendClick(self, arg1, arg2, checked)
		guildMenuFrame:Hide()
		InviteUnit(arg1)
	end

	function whisperFriendClick(self,arg1,arg2,checked)
		guildMenuFrame:Hide()
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
	end

	local menuCountWhispers = 0
	local menuCountInvites = 0

	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton" then
			GameTooltip:Hide()

			if(guildMenuFrame==nil) then
				guildMenuFrame = CreateFrame("Frame", "guildMenuFrame", nil, "UIDropDownMenuTemplate")
				guildMenuFrame.relativeTo = self
			else
				guildMenuFrame:Show()
			end			

			EasyMenu(guildMenuList, guildMenuFrame, "cursor", 0, 0, "MENU", 2)
		end
	end)	

	local function EPGPDecodeNote(note)
	  if note then
		if note == "" then
		  return 0, 0
		else
		  local ep, gp = string.match(note, "^(%d+),(%d+)$")
		  if ep then
			return tonumber(ep), tonumber(gp)
		  end
		end
	  end
	end	

	Stat:RegisterEvent("ADDON_LOADED")
	Stat:RegisterEvent("GUILD_ROSTER_UPDATE")
	Stat:RegisterEvent("PLAYER_GUILD_UPDATE")
	Stat:RegisterEvent("GUILD_PERK_UPDATE")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("CHAT_MSG_SYSTEM")
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() or self.altdow then					

			if IsInGuild() then			

				menuCountWhispers = 0
				menuCountInvites = 0

				guildMenuList[2].menuList = {}
				guildMenuList[3].menuList = {}

				colors = {
					note = { .14, .76, .15 },
					officerNote = { 1, .56, .25 }
				}	

				local r,g,b = unpack(colors.officerNote)
				local officerColor = ("\124cff%.2x%.2x%.2x"):format( r*255, g*255, b*255 )
				r,g,b = unpack(colors.note)
				local noteColor = ("\124cff%.2x%.2x%.2x"):format( r*255, g*255, b*255 )

				self.hovered = true
				GuildRoster()
				local name, rank,rankIndex, level, zone, note, officernote, EP,GP,PR, connected, status, class, zone_r, zone_g, zone_b, classc, levelc,grouped
				local online, total, gmotd = 0, GetNumGuildMembers(true), GetGuildRosterMOTD()
				for i = 0, total do if select(9, GetGuildRosterInfo(i)) then online = online + 1 end end
				
				local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
				GameTooltip:SetOwner(panel, anchor, xoff, yoff)
				GameTooltip:ClearAllPoints()
				GameTooltip:ClearLines()
				GameTooltip:AddLine(hexa..myname.."'s"..hexb.." Guild")
				GameTooltip:AddLine' '				
				GameTooltip:AddDoubleLine(GetGuildInfo'player',format("%s: %d/%d",GUILD,online,total),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine(' ')
				if gmotd ~= "" then GameTooltip:AddLine(format("  %s |cffaaaaaa- |cffffffff%s",GUILD_MOTD,gmotd),ttsubh.r,ttsubh.g,ttsubh.b,1) end
				if online > 1 then
					GameTooltip:AddLine' '
					sortable = {}
					for i = 1, total do
						tabletemp = {}
						tabletemp.index=i
						tabletemp.name, tabletemp.rank, tabletemp.rankIndex , tabletemp.level, _, tabletemp.zone, tabletemp.note, tabletemp.officernote, tabletemp.connected, tabletemp.status, tabletemp.class = GetGuildRosterInfo(i)

						if tabletemp.zone==nil then
							tabletemp.zone = "Unknow Zone"
						end

						if USE_EPGP then
							if tabletemp.officernote then
								tabletemp.EP,tabletemp.GP = EPGPDecodeNote(tabletemp.officernote)
								if(tabletemp.EP) then

									tabletemp.GP = tabletemp.GP + BASE_GP
									tabletemp.PR = tabletemp.EP / tabletemp.GP
									tabletemp.officernote = format("EP: %d GP: %d PR:%.2f",tabletemp.EP,tabletemp.GP,tabletemp.PR)
								else
									tabletemp.EP = 0
									tabletemp.GP = 0
									tabletemp.PR = -1
								end
							end
						end

						if tabletemp.connected~=nil and tabletemp.connected==1 then
							table.insert(sortable,tabletemp)
						end

					end

					table.sort(sortable,sortGuildFunc)

					for i,v in ipairs(sortable) do
						if online <= 1 then
							if online > 1 then GameTooltip:AddLine(format("+ %d More...", online - modules.Guild.maxguild),ttsubh.r,ttsubh.g,ttsubh.b) end
							break
						end						

						name = v.name
						rank = v.rank
						rankIndex = v.rankIndex
						level = v.level
						zone = v.zone
						note = v.note
						officernote = v.officernote
						connected = v.connected
						status = v.status
						class = v.class

						if connected then

							if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
							classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)

							notes = format(" %s%s",noteColor,note)
							if officernote ~= "" then
								notes = notes .. format(" %s%s",officerColor,officernote)
							end
							rank = noteColor..rank

							if (UnitInParty(name) or UnitInRaid(name)) and (name ~= UnitName'player') then
								grouped = "|cffaaaaaa*|r"
							else
								grouped = ""
								if name ~= UnitName'player' then
									menuCountInvites = menuCountInvites +1
									guildMenuList[2].menuList[menuCountInvites] = {text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r",levelc.r*255,levelc.g*255,levelc.b*255,level,classc.r*255,classc.g*255,classc.b*255,name), arg1 = name,notCheckable=true, func = inviteFriendClick}
								end
							end

							GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s%s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,name,grouped,notes,' '..status),zone.." "..rank,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)

							if name ~= UnitName'player' then
								menuCountWhispers = menuCountWhispers + 1

								guildMenuList[3].menuList[menuCountWhispers] = {text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r",levelc.r*255,levelc.g*255,levelc.b*255,level,classc.r*255,classc.g*255,classc.b*255,name), arg1 = name,notCheckable=true, func = whisperFriendClick}
							end

						end
					end
				end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cffeda55fClick|r to Open Guild Panel")
			GameTooltip:Show()
			end
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnMouseDown", function(self, btn)
		if btn == "LeftButton" then
			if not GuildFrame and IsInGuild() then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end
		end)
	Stat:SetScript("OnEvent", Update)
end

----------------------------
-- Datatext for HPS Feed... 
----------------------------

if datatext.hps_text and datatext.hps_text > 0 then
	local events = {SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true}
	local HPS_FEED = CreateFrame('Frame')
	local player_id = UnitGUID('player')
	local actual_heals_total, cmbt_time = 0
 
	local hText = PanelLeft:CreateFontString(nil, 'OVERLAY')
	hText:SetFont(media.font, datatext.fontsize)
	hText:SetText('HPS: ', '0')
 
	PP(datatext.hps_text, hText)
 
	HPS_FEED:EnableMouse(true)
	HPS_FEED:SetFrameStrata('BACKGROUND')
	HPS_FEED:SetFrameLevel(3)
	HPS_FEED:SetHeight(20)
	HPS_FEED:SetWidth(100)
	HPS_FEED:SetAllPoints(hText)
 
	HPS_FEED:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
	HPS_FEED:RegisterEvent('PLAYER_LOGIN')
 
	HPS_FEED:SetScript('OnUpdate', function(self, elap)
		if UnitAffectingCombat('player') then
			HPS_FEED:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
			cmbt_time = cmbt_time + elap
		else
			HPS_FEED:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		end
		hText:SetText(get_hps())
	end)
 
	function HPS_FEED:PLAYER_LOGIN()
		HPS_FEED:RegisterEvent('PLAYER_REGEN_ENABLED')
		HPS_FEED:RegisterEvent('PLAYER_REGEN_DISABLED')
		player_id = UnitGUID('player')
		HPS_FEED:UnregisterEvent('PLAYER_LOGIN')
	end
 
	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function HPS_FEED:COMBAT_LOG_EVENT_UNFILTERED(...)         
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end
		if event == 'PLAYER_REGEN_DISABLED' then return end

		-- only use events from the player
		local id = select(4, ...)
		if id == player_id then
			if toc < 40200 then
				amount_healed = select(13, ...)
				amount_over_healed = select(14, ...)
			else
				amount_healed = select(15, ...)
				amount_over_healed = select(16, ...)
			end
			-- add to the total the healed amount subtracting the overhealed amount
			actual_heals_total = actual_heals_total + math.max(0, amount_healed - amount_over_healed)
		end
	end
	
 	function get_hps()
		if (actual_heals_total == 0) then
			return (hexa..'HPS: '..hexb..'0')
		else
			return string.format('%.1f '..hexa..'HPS: '..hexb, (actual_heals_total or 0) / (cmbt_time or 1))
		end
	end
 
	function HPS_FEED:PLAYER_REGEN_ENABLED()
		hText:SetText(get_hps)
	end
   
	function HPS_FEED:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		actual_heals_total = 0
	end
     
	HPS_FEED:SetScript('OnMouseDown', function (self, button, down)
		cmbt_time = 0
		actual_heals_total = 0
	end)
 


end


---------------------------
-- Datatext for Micro Menu
---------------------------

if datatext.micromenu and datatext.micromenu > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.micromenu, Text)

	local function OnEvent(self, event, ...)
		Text:SetText(hexa..MAINMENU_BUTTON..hexb)
		self:SetAllPoints(Text)
	end

	local function OpenMenu()
		local menuFrame = CreateFrame("Frame", "DataTextMicroMenu", UIParent, "UIDropDownMenuTemplate")
		local menuList = {
			{text = CHARACTER_BUTTON,
			func = function() ToggleCharacter("PaperDollFrame") end},
			{text = SPELLBOOK_ABILITIES_BUTTON,
			func = function() ToggleFrame(SpellBookFrame) end},
			{text = TALENTS_BUTTON,
			func = function() if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end if not GlyphFrame then LoadAddOn("Blizzard_GlyphUI") end PlayerTalentFrame_Toggle() end},
			{text = ACHIEVEMENT_BUTTON,
			func = function() ToggleAchievementFrame() end},
			{text = QUESTLOG_BUTTON,
			func = function() ToggleFrame(QuestLogFrame) end},
			{text = SOCIAL_BUTTON,
			func = function() ToggleFriendsFrame(1) end},
			{text = PLAYER_V_PLAYER,
			func = function() ToggleFrame(PVPFrame) end},
			{text = ACHIEVEMENTS_GUILD_TAB,
			func = function() if IsInGuild() then if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end end},
			{text = LFG_TITLE,
			func = function() ToggleFrame(LFDParentFrame) end},
			{text = L_LFRAID,
			func = function() ToggleFrame(LFRParentFrame) end},
			{text = HELP_BUTTON,
			func = function() ToggleHelpFrame() end},
			{text = L_CALENDAR,
			func = function()
			if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
				Calendar_Toggle()
			end},
		}

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end

	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function() OpenMenu() end)
end

---------------------------
--Datatext for Professions
---------------------------
if datatext.pro and datatext.pro > 0 then

	local Stat = CreateFrame('Button')
	Stat:RegisterEvent('PLAYER_ENTERING_WORLD')
	Stat:SetFrameStrata('BACKGROUND')
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	Stat.tooltip = false

	local Text  = PanelLeft:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.pro, Text)

	local function Update(self)
		for _, v in pairs({GetProfessions()}) do
			if v ~= nil then
				local name, texture, rank, maxRank = GetProfessionInfo(v)
				Text:SetFormattedText(hexa..'Professions'..hexb)
			end
		end
		self:SetAllPoints(Text)
	end

	Stat:SetScript('OnEnter', function()
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..myname.."'s"..hexb..' Professions', .4,.78,1)
		for _, v in pairs({GetProfessions()}) do
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


	Stat:SetScript("OnClick",function(self,btn)
		local prof1, prof2 = GetProfessions()
		if btn == "LeftButton" then
			if prof1 then
				if (GetProfessionInfo(prof1) == 'Herbalism')then
						print('|cff00B4FFn|rData: |cffFF0000Herbalism has no options!|r')
				elseif(GetProfessionInfo(prof1) == 'Skinning') then
						print('|cff00B4FFn|rData: |cffFF0000Skinning has no options!|r')
				elseif(GetProfessionInfo(prof1) == 'Mining') then
						CastSpellByName("Smelting")							
				else	
					CastSpellByName((GetProfessionInfo(prof1)))
				end
			else
				print('|cff00B4FFn|rData: |cffFF0000No Profession Found!|r')
			end
		elseif btn == 'MiddleButton' then
			ToggleFrame(SpellBookFrame)		
		elseif btn == "RightButton" then
			if prof2 then
				if (GetProfessionInfo(prof2) == 'Herbalism')then
						print('|cff00B4FFn|rData: |cffFF0000Herbalism has no options!|r')
				elseif(GetProfessionInfo(prof2) == 'Skinning') then
						print('|cff00B4FFn|rData: |cffFF0000Skinning has no options!|r')
				elseif(GetProfessionInfo(prof2) == 'Mining') then
						CastSpellByName("Smelting")						
				else	
					CastSpellByName((GetProfessionInfo(prof2)))
				end
			else
				print('|cff00B4FFn|rData: |cffFF0000No Profession Found!|r')
			end
		end
	end)

	Stat:RegisterForClicks("AnyUp")
	Stat:SetScript('OnUpdate', Update)
	Stat:SetScript('OnLeave', function() GameTooltip:Hide() end)
end

------------------------
-- Datatext for Recount 
------------------------
local currentFightDPS

if datatext.recount and datatext.recount > 0 then 

	local RecountDPS = CreateFrame("Frame")
	RecountDPS:EnableMouse(true)
	RecountDPS:SetFrameStrata("MEDIUM")
	RecountDPS:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.recount, Text)
	RecountDPS:SetAllPoints(Text)

	function OnEvent(self, event, ...)
		if event == "PLAYER_LOGIN" then
			if IsAddOnLoaded("Recount") then
				RecountDPS:RegisterEvent("PLAYER_REGEN_ENABLED")
				RecountDPS:RegisterEvent("PLAYER_REGEN_DISABLED")
				myname = UnitName("player")
				currentFightDPS = 0
			else
				return
			end
			RecountDPS:UnregisterEvent("PLAYER_LOGIN")
		elseif event == "PLAYER_ENTERING_WORLD" then
			self.updateDPS()
			RecountDPS:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end

	function RecountDPS:RecountHook_UpdateText()
		self:updateDPS()
	end

	function RecountDPS:updateDPS()
		Text:SetText(hexa.."DPS: "..hexb.. RecountDPS.getDPS() .. "|r")
	end

	function RecountDPS:getDPS()
		if not IsAddOnLoaded("Recount") then return "N/A" end
		if datatext.recountraiddps == true then
			-- show raid dps
			_, dps = RecountDPS:getRaidValuePerSecond(Recount.db.profile.CurDataSet)
			return dps
		else
			return RecountDPS.getValuePerSecond()
		end
	end

	-- quick dps calculation from recount's data
	function RecountDPS:getValuePerSecond()
		local _, dps = Recount:MergedPetDamageDPS(Recount.db2.combatants[myname], Recount.db.profile.CurDataSet)
		return math.floor(10 * dps + 0.5) / 10
	end

	function RecountDPS:getRaidValuePerSecond(tablename)
		local dps, curdps, data, damage, temp = 0, 0, nil, 0, 0
		for _,data in pairs(Recount.db2.combatants) do
			if data.Fights and data.Fights[tablename] and (data.type=="Self" or data.type=="Grouped" or data.type=="Pet" or data.type=="Ungrouped") then
				temp, curdps = Recount:MergedPetDamageDPS(data,tablename)
				if data.type ~= "Pet" or (not Recount.db.profile.MergePets and data.Owner and (Recount.db2.combatants[data.Owner].type=="Self" or Recount.db2.combatants[data.Owner].type=="Grouped" or Recount.db2.combatants[data.Owner].type=="Ungrouped")) or (not Recount.db.profile.MergePets and data.Name and data.GUID and self:matchUnitGUID(data.Name, data.GUID)) then
					dps = dps + 10 * curdps
					damage = damage + temp
				end
			end
		end
		return math.floor(damage + 0.5) / 10, math.floor(dps + 0.5)/10
	end

	-- tracked events
	RecountDPS:RegisterEvent("PLAYER_LOGIN")
	RecountDPS:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- scripts
	RecountDPS:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end

		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		if IsAddOnLoaded("Recount") then
			local damage, dps = Recount:MergedPetDamageDPS(Recount.db2.combatants[myname], Recount.db.profile.CurDataSet)
			local raid_damage, raid_dps = RecountDPS:getRaidValuePerSecond(Recount.db.profile.CurDataSet)
			-- format the number
			dps = math.floor(10 * dps + 0.5) / 10
			GameTooltip:AddLine("Recount")
			GameTooltip:AddDoubleLine("Personal Damage:", damage, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddDoubleLine("Personal DPS:", dps, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Raid Damage:", raid_damage, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddDoubleLine("Raid DPS:", raid_dps, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Recount")
			GameTooltip:AddLine("|cffeda55fRight Click|r to Reset Data")
			GameTooltip:AddLine("|cffeda55fShift + Right Click|r to Open Config")
		else
			GameTooltip:AddLine("Recount is not loaded.", 255, 0, 0)
			GameTooltip:AddLine("Enable Recount and reload your UI.")
		end
		GameTooltip:Show()
	end)
	RecountDPS:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			if not IsShiftKeyDown() then
				Recount:ShowReset()
			else
				Recount:ShowConfig()
			end
		elseif button == "LeftButton" then
			if Recount.MainWindow:IsShown() then
				Recount.MainWindow:Hide()
			else
				Recount.MainWindow:Show()
				Recount:RefreshMainWindow()
			end
		end
	end)
	RecountDPS:SetScript("OnEvent", OnEvent)
	RecountDPS:SetScript("OnLeave", function() GameTooltip:Hide() end)
	RecountDPS:SetScript("OnUpdate", function(self, t)
		local int = -1
		int = int - t
		if int < 0 then
			self.updateDPS()
			int = 1
		end
	end)
end

--------------------------
-- Datatext for Spec Swap
--------------------------

if datatext.spec and datatext.spec > 0 then

	local Stat = CreateFrame('Frame')
	Stat:EnableMouse(true)
	Stat:SetFrameStrata('BACKGROUND')
	Stat:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.spec, Text)

	local talent = {}
	local active
	local talentString = string.join('', '|cffFFFFFF%s|r ')
	local talentStringTip = string.join('', '|cffFFFFFF%s:|r ', '%d|r/',  '%d|r/',  '%d|r')
	local activeString = string.join('', '|cff00FF00' , ACTIVE_PETS, '|r')
	local inactiveString = string.join('', '|cffFF0000', FACTION_INACTIVE, '|r')



	local function LoadTalentTrees()
		for i = 1, GetNumTalentGroups(false, false) do
			talent[i] = {} -- init talent group table
			for j = 1, GetNumTalentTabs(false, false) do
				talent[i][j] = select(5, GetTalentTabInfo(j, false, false, i))
			end
		end
	end

	local int = 1
	local function Update(self, t)
		int = int - t
		if int > 0 or not GetPrimaryTalentTree() then return end

		active = GetActiveTalentGroup(false, false)
		Text:SetFormattedText(talentString, hexa..select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, active)))..hexb)
		int = 1

		-- disable script	
		self:SetScript('OnUpdate', nil)
	end


	Stat:SetScript('OnEnter', function(self)
		if InCombatLockdown() then return end

		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)

		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..myname.."'s"..hexb.." Spec")
		GameTooltip:AddLine' '		
		for i = 1, GetNumTalentGroups() do
			if GetPrimaryTalentTree(false, false, i) then
				GameTooltip:AddLine(string.join(' ', string.format(talentStringTip, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, i))), talent[i][1], talent[i][2], talent[i][3]), (i == active and activeString or inactiveString)),1,1,1)
			end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Switch Spec's")		
		GameTooltip:AddLine("|cffeda55fRight Click|r to Open Talent Tree")
		GameTooltip:Show()
	end)

	Stat:SetScript('OnLeave', function() GameTooltip:Hide() end)

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



	Stat:RegisterEvent('PLAYER_ENTERING_WORLD');
	Stat:RegisterEvent('CHARACTER_POINTS_CHANGED');
	Stat:RegisterEvent('PLAYER_TALENT_UPDATE');
	Stat:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	Stat:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	Stat:SetScript('OnEvent', OnEvent)
	Stat:SetScript('OnUpdate', Update)

	Stat:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			SetActiveTalentGroup(active == 1 and 2 or 1)
		elseif button == "RightButton" then
			ToggleTalentFrame()
		end
	end)
end

-----------------------
-- Datatext for Stat 1 
-----------------------

if datatext.stat1 and datatext.stat1 > 0 then

	local Stat = CreateFrame("Frame")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.stat1, Text)

	local format = string.format
	local targetlv, playerlv = UnitLevel("target"), UnitLevel("player")
	local basemisschance, leveldifference, dodge, parry, block
	local chanceString = "%.2f%%"
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local manaRegenString = "%d / %d"
	local displayNumberString = string.join("", "%s", "%d|r")
	local displayFloatString = string.join("", "%s", "%.2f%%|r")
	local spellpwr, avoidance, pwr
	local haste, hasteBonus
	local level = UnitLevel("player")

	local function ShowTooltip(self)
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		
		if Role == "Tank" then
			if targetlv > 1 then
				GameTooltip:AddDoubleLine('Avoidance Breakdown', string.join("", " (", 'lvl', " ", targetlv, ")"))
			elseif targetlv == -1 then
				GameTooltip:AddDoubleLine('Avoidance Breakdown', string.join("", " (", 'Boss', ")"))
			else
				GameTooltip:AddDoubleLine('Avoidance Breakdown', string.join("", " (", 'lvl', " ", playerlv, ")"))
			end
			GameTooltip:AddLine' '
			GameTooltip:AddDoubleLine(DODGE_CHANCE, format(chanceString, dodge),1,1,1)
			GameTooltip:AddDoubleLine(PARRY_CHANCE, format(chanceString, parry),1,1,1)
			GameTooltip:AddDoubleLine(BLOCK_CHANCE, format(chanceString, block),1,1,1)
			GameTooltip:AddDoubleLine(MISS_CHANCE, format(chanceString, basemisschance),1,1,1)
		elseif Role == "Caster" then
			GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, GetCombatRating(CR_HIT_SPELL), GetCombatRatingBonus(CR_HIT_SPELL)), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, GetCombatRating(CR_HASTE_SPELL), GetCombatRatingBonus(CR_HASTE_SPELL)), 1, 1, 1)
			local base, combat = GetManaRegen()
			GameTooltip:AddDoubleLine(MANA_REGEN, format(manaRegenString, base * 5, combat * 5), 1, 1, 1)
		elseif Role == "Melee" then
			local hit =  myclass == "HUNTER" and GetCombatRating(CR_HIT_RANGED) or GetCombatRating(CR_HIT_MELEE)
			local hitBonus =  myclass == "HUNTER" and GetCombatRatingBonus(CR_HIT_RANGED) or GetCombatRatingBonus(CR_HIT_MELEE)
		
			GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, hit, hitBonus), 1, 1, 1)
			
			--Hunters don't use expertise
			if myclass ~= "HUNTER" then
				local expertisePercent, offhandExpertisePercent = GetExpertisePercent()
				expertisePercent = format("%.2f", expertisePercent)
				offhandExpertisePercent = format("%.2f", offhandExpertisePercent)
				
				local expertisePercentDisplay
				if IsDualWielding() then
					expertisePercentDisplay = expertisePercent.."% / "..offhandExpertisePercent.."%"
				else
					expertisePercentDisplay = expertisePercent.."%"
				end
				GameTooltip:AddDoubleLine(COMBAT_RATING_NAME24, format('%d (+%s)', GetCombatRating(CR_EXPERTISE), expertisePercentDisplay), 1, 1, 1)
			end
			
			local haste = myclass == "HUNTER" and GetCombatRating(CR_HASTE_RANGED) or GetCombatRating(CR_HASTE_MELEE)
			local hasteBonus = myclass == "HUNTER" and GetCombatRatingBonus(CR_HASTE_RANGED) or GetCombatRatingBonus(CR_HASTE_MELEE)
			
			GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, haste, hasteBonus), 1, 1, 1)
		end
		
		local masteryspell
		if GetCombatRating(CR_MASTERY) ~= 0 and GetPrimaryTalentTree() then
			if myclass == "DRUID" then
				if Role == "Melee" then
					masteryspell = select(2, GetTalentTreeMasterySpells(GetPrimaryTalentTree()))
				elseif Role == "Tank" then
					masteryspell = select(1, GetTalentTreeMasterySpells(GetPrimaryTalentTree()))
				else
					masteryspell = GetTalentTreeMasterySpells(GetPrimaryTalentTree())
				end
			else
				masteryspell = GetTalentTreeMasterySpells(GetPrimaryTalentTree())
			end
			


			local masteryName, _, _, _, _, _, _, _, _ = GetSpellInfo(masteryspell)
			if masteryName then
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(masteryName, format(modifierString, GetCombatRating(CR_MASTERY), GetCombatRatingBonus(CR_MASTERY)), 1, 1, 1)
			end
		end
		
		GameTooltip:Show()
	end

	local function UpdateTank(self)
				
		-- the 5 is for base miss chance
		if targetlv == -1 then
			basemisschance = (5 - (3*.2))
			leveldifference = 3
		elseif targetlv > playerlv then
			basemisschance = (5 - ((targetlv - playerlv)*.2))
			leveldifference = (targetlv - playerlv)
		elseif targetlv < playerlv and targetlv > 0 then
			basemisschance = (5 + ((playerlv - targetlv)*.2))
			leveldifference = (targetlv - playerlv)
		else
			basemisschance = 5
			leveldifference = 0
		end
		
		if select(2, UnitRace("player")) == "NightElf" then basemisschance = basemisschance + 2 end
		
		if leveldifference >= 0 then
			dodge = (GetDodgeChance()-leveldifference*.2)
			parry = (GetParryChance()-leveldifference*.2)
			block = (GetBlockChance()-leveldifference*.2)
		else
			dodge = (GetDodgeChance()+abs(leveldifference*.2))
			parry = (GetParryChance()+abs(leveldifference*.2))
			block = (GetBlockChance()+abs(leveldifference*.2))
		end
		
		if dodge <= 0 then dodge = 0 end
		if parry <= 0 then parry = 0 end
		if block <= 0 then block = 0 end
		
		if myclass == "DRUID" then
			parry = 0
			block = 0
		elseif myclass == "DEATHKNIGHT" then
			block = 0
		end
		avoidance = (dodge+parry+block+basemisschance)
		
		Text:SetFormattedText(displayFloatString, hexa..'AVD: '..hexb, avoidance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		if GetSpellBonusHealing() > GetSpellBonusDamage(7) then
			spellpwr = GetSpellBonusHealing()
		else
			spellpwr = GetSpellBonusDamage(7)
		end
		
		Text:SetFormattedText(displayNumberString, hexa..'SP: '..hexb, spellpwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local base, posBuff, negBuff = UnitAttackPower("player");
		local effective = base + posBuff + negBuff;
		local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player");
		local Reffective = Rbase + RposBuff + RnegBuff;
			
		if myclass == "HUNTER" then
			pwr = Reffective
		else
			pwr = effective
		end
		
		Text:SetFormattedText(displayNumberString, hexa..'AP: '..hexb, pwr)      
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	-- initial delay for update (let the ui load)
	local int = 5	
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		if Role == "Tank" then 
			UpdateTank(self)
		elseif Role == "Caster" then
			UpdateCaster(self)
		elseif Role == "Melee" then
			UpdateMelee(self)
		end
		int = 2
	end

	Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end

-----------------------
-- Datatext for Stat 2
-----------------------

if datatext.stat2 and datatext.stat2 > 0 then

	local Stat = CreateFrame("Frame")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.stat2, Text)

	local _G = getfenv(0)
	local format = string.format
	local chanceString = "%.2f%%"
	local armorString = hexa..ARMOR..hexb..": "
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local baseArmor, effectiveArmor, armor, posBuff, negBuff
	local displayNumberString = string.join("", "%s", "%d|r")
	local displayFloatString = string.join("", "%s", "%.2f%%|r")
	local level = UnitLevel("player")

	local function CalculateMitigation(level, effective)
		local mitigation
		
		if not effective then
			_, effective, _, _, _ = UnitArmor("player")
		end
		
		if level < 60 then
			mitigation = (effective/(effective + 400 + (85 * level)));
		else
			mitigation = (effective/(effective + (467.5 * level - 22167.5)));
		end
		if mitigation > .75 then
			mitigation = .75
		end
		return mitigation
	end

	local function AddTooltipHeader(description)
		GameTooltip:AddLine(description)
		GameTooltip:AddLine(' ')
	end

	local function ShowTooltip(self)
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		
		if Role == "Tank" then
			AddTooltipHeader('Mitigation By Level: ')
			local lv = level +3
			for i = 1, 4 do
				GameTooltip:AddDoubleLine(lv,format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
				lv = lv - 1
			end
			lv = UnitLevel("target")
			if lv and lv > 0 and (lv > level + 3 or lv < level) then
				GameTooltip:AddDoubleLine(lv, format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
			end	
		elseif Role == "Caster" or Role == "Melee" then
			AddTooltipHeader(MAGIC_RESISTANCES_COLON)
			
			local baseResistance, effectiveResistance, posResitance, negResistance
			for i = 2, 6 do
				baseResistance, effectiveResistance, posResitance, negResistance = UnitResistance("player", i)
				GameTooltip:AddDoubleLine(_G["DAMAGE_SCHOOL"..(i+1)], format(chanceString, (effectiveResistance / (effectiveResistance + (500 + level + 2.5))) * 100),1,1,1)
			end
			
			local spellpen = GetSpellPenetration()
			if (myclass == "SHAMAN" or Role == "Caster") and spellpen > 0 then
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(ITEM_MOD_SPELL_PENETRATION_SHORT, spellpen,1,1,1)
			end
		end
		GameTooltip:Show()
	end

	local function UpdateTank(self)
		baseArmor, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
		
		Text:SetFormattedText(displayNumberString, armorString, effectiveArmor)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		local spellcrit = GetSpellCritChance(1)

		Text:SetFormattedText(displayFloatString, hexa..'Crit: '..hexb, spellcrit)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local meleecrit = GetCritChance()
		local rangedcrit = GetRangedCritChance()
		local critChance
			
		if myclass == "HUNTER" then    
			critChance = rangedcrit
		else
			critChance = meleecrit
		end
		
		Text:SetFormattedText(displayFloatString, hexa..'Crit: '..hexb, critChance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	-- initial delay for update (let the ui load)
	local int = 5	
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		
		if Role == "Tank" then
			UpdateTank(self)
		elseif Role == "Caster" then
			UpdateCaster(self)
		elseif Role == "Melee" then
			UpdateMelee(self)		
		end
		int = 2
	end

	Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end

---------------------------------------------------
-- Datatext for System Stats
---------------------------------------------------

if datatext.system and datatext.system > 0 then

	local Stat = CreateFrame("Frame")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	Stat.tooltip = false

	local Text  = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.system, Text)

	local bandwidthString = "%.2f Mbps"
	local percentageString = "%.2f%%"
	local homeLatencyString = "%d ms"
	local worldLatencyString = "%d ms"
	local kiloByteString = "%d kb"
	local megaByteString = "%.2f mb"

	local function formatMem(memory)
		local mult = 10^1
		if memory > 999 then
			local mem = ((memory/1024) * mult) / mult
			return string.format(megaByteString, mem)
		else
			local mem = (memory * mult) / mult
			return string.format(kiloByteString, mem)
		end
	end

	local memoryTable = {}

	local function RebuildAddonList(self)
		local addOnCount = GetNumAddOns()
		if (addOnCount == #memoryTable) or self.tooltip == true then return end

		-- Number of loaded addons changed, create new memoryTable for all addons
		memoryTable = {}
		for i = 1, addOnCount do
			memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
		end
		self:SetAllPoints(Text)
	end

	local function UpdateMemory()
		-- Update the memory usages of the addons
		UpdateAddOnMemoryUsage()
		-- Load memory usage in table
		local addOnMem = 0
		local totalMemory = 0
		for i = 1, #memoryTable do
			addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
			memoryTable[i][3] = addOnMem
			totalMemory = totalMemory + addOnMem
		end
		-- Sort the table to put the largest addon on top
		table.sort(memoryTable, function(a, b)
			if a and b then
				return a[3] > b[3]
			end
		end)
		
		return totalMemory
	end

	-- initial delay for update (let the ui load)
	local int, int2 = 6, 5
	local statusColors = {
		"|cff0CD809",
		"|cffE8DA0F",
		"|cffFF9000",
		"|cffD80909"
	}

	local function Update(self, t)
		int = int - t
		int2 = int2 - t
		
		if int < 0 then
			RebuildAddonList(self)
			int = 10
		end
		if int2 < 0 then
			local framerate = floor(GetFramerate())
			local fpscolor = 4
			local latency = select(4, GetNetStats()) 
			local latencycolor = 4
						
			if latency < 150 then
				latencycolor = 1
			elseif latency >= 150 and latency < 300 then
				latencycolor = 2
			elseif latency >= 300 and latency < 500 then
				latencycolor = 3
			end
			if framerate >= 30 then
				fpscolor = 1
			elseif framerate >= 20 and framerate < 30 then
				fpscolor = 2
			elseif framerate >= 10 and framerate < 20 then
				fpscolor = 3
			end
			local displayFormat = string.join("", hexa..'FPS: '..hexb, statusColors[fpscolor], "%d|r", hexa..' MS: ', statusColors[latencycolor], "%d|r")
			Text:SetFormattedText(displayFormat, framerate, latency)
			int2 = 1
		end
	end
	Stat:SetScript("OnMouseDown", function () collectgarbage("collect") Update(Stat, 20) end)
	Stat:SetScript("OnEnter", function(self)
		local bandwidth = GetAvailableBandwidth()
		local _, _, latencyHome, latencyWorld = GetNetStats() 
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..myname.."'s"..hexb.." Latency")
		GameTooltip:AddLine' '		
		if datatext.fps.enable == true then 
			if datatext.fps.home == true then
				GameTooltip:AddDoubleLine('Home Latency: ', string.format('Home Latency: ', latencyHome), 0.80, 0.31, 0.31,0.84, 0.75, 0.65)
			elseif datatext.fps.world == true then
				GameTooltip:AddDoubleLine('World Latency: ', string.format('World Latency: ', latencyWorld), 0.80, 0.31, 0.31,0.84, 0.75, 0.65)
			elseif datatext.fps.both == true then
				GameTooltip:AddDoubleLine('Home Latency: ', string.format('Home Latency: ', latencyHome), 0.80, 0.31, 0.31,0.84, 0.75, 0.65)
				GameTooltip:AddDoubleLine('World Latency: ', string.format('World Latency: ', latencyWorld), 0.80, 0.31, 0.31,0.84, 0.75, 0.65)
			end
		end
		if bandwidth ~= 0 then
			GameTooltip:AddDoubleLine('Bandwidth: ' , string.format(bandwidthString, bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine('Download: ' , string.format(percentageString, GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
		end
		local totalMemory = UpdateMemory()
		GameTooltip:AddDoubleLine('Total Memory Usage:', formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
		for i = 1, #memoryTable do
			if (memoryTable[i][4]) then
				local red = memoryTable[i][3] / totalMemory
				local green = 1 - red
				GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
			end						
		end
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end

---------------------
-- Datatext for TIME
---------------------

if datatext.wowtime and datatext.wowtime > 0 then

	local europeDisplayFormat = string.join("", "%02d", ":|r%02d")
	local ukDisplayFormat = string.join("", "", "%d", ":|r%02d", " %s|r")
	local timerLongFormat = "%d:%02d:%02d"
	local timerShortFormat = "%d:%02d"
	local lockoutInfoFormat = "%s |cffaaaaaa(%s%s, %s/%s)"
	local formatBattleGroundInfo = "%s: "
	local lockoutColorExtended, lockoutColorNormal = { r=0.3,g=1,b=0.3 }, { r=1,g=1,b=1 }
	local difficultyInfo = { "N", "N", "H", "H" }
	local curHr, curMin, curAmPm

	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)

	local Text  = PanelLeft:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.wowtime, Text)

	local APM = { TIMEMANAGER_PM, TIMEMANAGER_AM }

	local function CalculateTimeValues(tt)
		if tt == nil then tt = false end
		local Hr, Min, AmPm
		if tt == true then
			if datatext.localtime == true then
				Hr, Min = GetGameTime()
				if datatext.time24 == true then
					return Hr, Min, -1
				else
					if Hr>=12 then
						if Hr>12 then Hr = Hr - 12 end
						AmPm = 1
					else
						if Hr == 0 then Hr = 12 end
						AmPm = 2
					end
					return Hr, Min, AmPm
				end			
			else
				local Hr24 = tonumber(date("%H"))
				Hr = tonumber(date("%I"))
				Min = tonumber(date("%M"))
				if datatext.time24 == true then
					return Hr24, Min, -1
				else
					if Hr24>=12 then AmPm = 1 else AmPm = 2 end
					return Hr, Min, AmPm
				end
			end
		else
			if datatext.localtime == true then
				local Hr24 = tonumber(date("%H"))
				Hr = tonumber(date("%I"))
				Min = tonumber(date("%M"))
				if datatext.time24 == true then
					return Hr24, Min, -1
				else
					if Hr24>=12 then AmPm = 1 else AmPm = 2 end
					return Hr, Min, AmPm
				end
			else
				Hr, Min = GetGameTime()
				if datatext.time24 == true then
					return Hr, Min, -1
				else
					if Hr>=12 then
						if Hr>12 then Hr = Hr - 12 end
						AmPm = 1
					else
						if Hr == 0 then Hr = 12 end
						AmPm = 2
					end
					return Hr, Min, AmPm
				end
			end	
		end
	end

	local function CalculateTimeLeft(time)
			local hour = floor(time / 3600)
			local min = floor(time / 60 - (hour*60))
			local sec = time - (hour * 3600) - (min * 60)
			
			return hour, min, sec
	end

	local function formatResetTime(sec,table)
		local table = table or {}
		local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
		local string = gsub(gsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," "),"%s+"," ")
		local string = strtrim(gsub(string, "([dhms])", {d=table.days or "d",h=table.hours or "h",m=table.minutes or "m",s=table.seconds or "s"})," ")
		return strmatch(string,"^%s*$") and "0"..(table.seconds or L"s") or string
	end

	local int = 1
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		
		local Hr, Min, AmPm = CalculateTimeValues()
		
		if CalendarGetNumPendingInvites() > 0 then
			Text:SetTextColor(1, 0, 0)
		else
			Text:SetTextColor(1, 1, 1)
		end
		
		-- no update quick exit
		if (Hr == curHr and Min == curMin and AmPm == curAmPm) then
			int = 2
			return
		end
		
		curHr = Hr
		curMin = Min
		curAmPm = AmPm
			
		if AmPm == -1 then
			Text:SetFormattedText(europeDisplayFormat, Hr, Min)
		else
			Text:SetFormattedText(ukDisplayFormat, Hr, Min, hexa..APM[AmPm]..hexb)
		end

		self:SetAllPoints(Text)
		int = 2
	end

	Stat:SetScript("OnEnter", function(self)
		OnLoad = function(self) RequestRaidInfo() end
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..myname.."'s"..hexb.." Time")
		GameTooltip:AddLine' '	
		local localizedName, isActive, canQueue, startTime, canEnter
		for i = 1, GetNumWorldPVPAreas() do
			_, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(i)
			if canEnter then
				if isActive then
					startTime = WINTERGRASP_IN_PROGRESS
				elseif startTime == nil then
					startTime = QUEUE_TIME_UNAVAILABLE
				else
					local hour, min, sec = CalculateTimeLeft(startTime)
					if hour > 0 then 
						startTime = string.format(timerLongFormat, hour, min, sec) 
					else 
						startTime = string.format(timerShortFormat, min, sec)
					end
				end
				GameTooltip:AddDoubleLine(format(formatBattleGroundInfo, localizedName), startTime)	
			end
		end	

		local timeText
		local Hr, Min, AmPm = CalculateTimeValues(true)

		if datatext.localtime == true then
			timeText = 'Server Time: '
		else
			timeText = 'Local Time: '
		end
		
		if AmPm == -1 then
			GameTooltip:AddDoubleLine(timeText, string.format(europeDisplayFormat, Hr, Min))
		else
			GameTooltip:AddDoubleLine(timeText, string.format(ukDisplayFormat, Hr, Min, APM[AmPm]))
		end
		
		local oneraid, lockoutColor
		for i = 1, GetNumSavedInstances() do
			local name, _, reset, difficulty, locked, extended, _, isRaid, maxPlayers, _, numEncounters, encounterProgress  = GetSavedInstanceInfo(i)
			if isRaid and (locked or extended) then
				local tr,tg,tb,diff
				if not oneraid then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine('Saved Raid(s)')
					oneraid = true
				end
				if extended then lockoutColor = lockoutColorExtended else lockoutColor = lockoutColorNormal end
				GameTooltip:AddDoubleLine(format(lockoutInfoFormat, name, maxPlayers, difficultyInfo[difficulty],encounterProgress,numEncounters), formatResetTime(reset), 1,1,1, lockoutColor.r,lockoutColor.g,lockoutColor.b)
			end
		end
		GameTooltip:Show()
	end)

	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnUpdate", Update)
	Stat:RegisterEvent("UPDATE_INSTANCE_INFO")
	Stat:SetScript("OnMouseDown", function(self, btn)
		if btn == 'RightButton'  then
			ToggleTimeManager()
		else
			GameTimeFrame:Click()
		end
	end)
	Update(Stat, 10)
end

---------------------------------------------------
-- Datatext for Zone Text
---------------------------------------------------
if datatext.zone and datatext.zone > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata('BACKGROUND')
	Stat:SetFrameLevel(3)

	local Text = PanelLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(media.font, datatext.fontsize)
	PP(datatext.zone, Text)

	local function Update(self)
		if GetMinimapZoneText() == "Putricide's Laboratory of Alchemical Horrors and Fun" then
			Text:SetText("Putricides's Laboratory")
		else
			Text:SetText(hexa..GetMinimapZoneText()..hexb)
		end
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end