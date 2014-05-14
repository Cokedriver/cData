local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
--	 Statistics 1 Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["stat1"] = function()

	db = nData.db.profile
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:SetFrameStrata("BACKGROUND")
	plugin:SetFrameLevel(3)
	plugin:EnableMouse(true)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.stat1, Text)

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
		if InCombatLockdown() then return end
	
		local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Statistics")
		GameTooltip:AddLine' '		
		if UnitLevel("player") >= 10 then
			if playerRole == "Tank" then
				if targetlv > 1 then
					GameTooltip:AddDoubleLine("Avoidance Breakdown", string.join("", " (", "lvl", " ", targetlv, ")"))
				elseif targetlv == -1 then
					GameTooltip:AddDoubleLine("Avoidance Breakdown", string.join("", " (", "Boss", ")"))
				else
					GameTooltip:AddDoubleLine("Avoidance Breakdown", string.join("", " (", "lvl", " ", playerlv, ")"))
				end
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(DODGE_CHANCE, format(chanceString, dodge),1,1,1)
				GameTooltip:AddDoubleLine(PARRY_CHANCE, format(chanceString, parry),1,1,1)
				GameTooltip:AddDoubleLine(BLOCK_CHANCE, format(chanceString, block),1,1,1)
				GameTooltip:AddDoubleLine(MISS_CHANCE, format(chanceString, basemisschance),1,1,1)
			elseif playerRole == "Caster" then
				GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, GetCombatRating(CR_HIT_SPELL), GetCombatRatingBonus(CR_HIT_SPELL)), 1, 1, 1)
				GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, GetCombatRating(CR_HASTE_SPELL), GetCombatRatingBonus(CR_HASTE_SPELL)), 1, 1, 1)
				local base, combat = GetManaRegen()
				GameTooltip:AddDoubleLine(MANA_REGEN, format(manaRegenString, base * 5, combat * 5), 1, 1, 1)
			elseif playerRole == "Melee" then
				local hit =  UNIT_CLASS == "HUNTER" and GetCombatRating(CR_HIT_RANGED) or GetCombatRating(CR_HIT_MELEE)
				local hitBonus =  UNIT_CLASS == "HUNTER" and GetCombatRatingBonus(CR_HIT_RANGED) or GetCombatRatingBonus(CR_HIT_MELEE)
			
				GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, hit, hitBonus), 1, 1, 1)
				
				local haste = UNIT_CLASS == "HUNTER" and GetCombatRating(CR_HASTE_RANGED) or GetCombatRating(CR_HASTE_MELEE)
				local hasteBonus = UNIT_CLASS == "HUNTER" and GetCombatRatingBonus(CR_HASTE_RANGED) or GetCombatRatingBonus(CR_HASTE_MELEE)
				
				GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, haste, hasteBonus), 1, 1, 1)
			end
		else
			GameTooltip:AddLine("No Stats Available unit Level 10")
		end
		
		local masteryspell
		if GetCombatRating(CR_MASTERY) ~= 0 and GetSpecialization() then
			if UNIT_CLASS == "DRUID" then
				if playerRole == "Melee" then
					masteryspell = select(2, GetSpecializationMasterySpells(GetSpecialization()))
				elseif playerRole == "Tank" then
					masteryspell = select(1, GetSpecializationMasterySpells(GetSpecialization()))
				else
					masteryspell = GetSpecializationMasterySpells(GetSpecialization())
				end
			else
				masteryspell = GetSpecializationMasterySpells(GetSpecialization())
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
		
		if UNIT_CLASS == "DRUID" then
			parry = 0
			block = 0
		elseif UNIT_CLASS == "DEATHKNIGHT" then
			block = 0
		end
		avoidance = (dodge+parry+block+basemisschance)
		
		Text:SetFormattedText(displayFloatString, hexa.."AVD: "..hexb, avoidance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		if GetSpellBonusHealing() > GetSpellBonusDamage(7) then
			spellpwr = GetSpellBonusHealing()
		else
			spellpwr = GetSpellBonusDamage(7)
		end
		
		Text:SetFormattedText(displayNumberString, hexa.."SP: "..hexb, spellpwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local base, posBuff, negBuff = UnitAttackPower("player");
		local effective = base + posBuff + negBuff;
		local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player");
		local Reffective = Rbase + RposBuff + RnegBuff;
			
		if UNIT_CLASS == "HUNTER" then
			pwr = Reffective
		else
			pwr = effective
		end
		
		Text:SetFormattedText(displayNumberString, hexa.."AP: "..hexb, pwr)      
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	-- initial delay for update (let the ui load)
	local int = 5	
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		if UnitLevel("player") >= 10 then
			if playerRole == "Tank" then 
				UpdateTank(self)
			elseif playerRole == "Caster" then
				UpdateCaster(self)
			elseif playerRole == "Melee" then
				UpdateMelee(self)
			end
		else
			Text:SetText(hexa.."No Stats"..hexb)
		end
		int = 2
	end

	plugin:SetScript("OnEnter", function() ShowTooltip(plugin) end)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	plugin:SetScript("OnUpdate", Update)
	Update(plugin, 10)

	return plugin -- important!
end