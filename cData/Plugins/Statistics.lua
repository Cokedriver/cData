local cData = LibStub("AceAddon-3.0"):GetAddon("cData")

------------------------------------------------------------------------
--	 Statistics Plugin Functions
------------------------------------------------------------------------
cData.pluginConstructors["stats"] = function()

	db = cData.db.profile
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:SetFrameStrata("BACKGROUND")
	plugin:SetFrameLevel(3)
	plugin:EnableMouse(true)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	cData:PlacePlugin(db.stats, Text)

	local playerClass, englishClass = UnitClass("player");

	local function ShowTooltip(self)
		if InCombatLockdown() then return end
	
		local anchor, panel, xoff, yoff = cData:DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Statistics")
		GameTooltip:AddLine' '		
		if cData.playerRole == nil then
			GameTooltip:AddLine("Choose a Specialization to see Stats")
		else
			if cData.playerRole == "TANK" then
				local Total_Dodge = GetDodgeChance()
				local Total_Parry = GetParryChance()
				local Total_Block = GetBlockChance()
				
				GameTooltip:AddLine(STAT_CATEGORY_DEFENSE)
				GameTooltip:AddDoubleLine(DODGE_CHANCE, format("%.2f%%", Total_Dodge),1,1,1)
				GameTooltip:AddDoubleLine(PARRY_CHANCE, format("%.2f%%", Total_Parry),1,1,1)
				GameTooltip:AddDoubleLine(BLOCK_CHANCE, format("%.2f%%", Total_Block),1,1,1)				
				
			elseif cData.playerRole == "HEALER" or cData.playerRole == "CASTER" then
				local SC = GetSpellCritChance("2")
				local Total_Spell_Haste = UnitSpellHaste("player")
				local base, casting = GetManaRegen()
				local manaRegenString = "%d / %d"				
				
				GameTooltip:AddLine(STAT_CATEGORY_SPELL)
				GameTooltip:AddDoubleLine(STAT_CRITICAL_STRIKE, format("%.2f%%", SC), 1, 1, 1)
				GameTooltip:AddDoubleLine(STAT_HASTE, format("%.2f%%", Total_Spell_Haste), 1, 1, 1)		
				GameTooltip:AddDoubleLine(MANA_REGEN, format(manaRegenString, base * 5, casting * 5), 1, 1, 1)

			elseif cData.playerRole == "DAMAGER" then			
				if englishClass == "HUNTER" then
					local Total_Range_Haste = GetRangedHaste("player")
					--local Range_Armor_Pen = GetArmorPenetration();
					local Range_Crit = GetRangedCritChance("25")
					local speed = UnitRangedDamage("player")
					local Total_Range_Speed = speed
					
					GameTooltip:AddLine(STAT_CATEGORY_RANGED)					
					--GameTooltip:AddDoubleLine("Armor Penetration", format("%.2f%%", Range_Armor_Pen), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_CRITICAL_STRIKE, format("%.2f%%", Range_Crit), 1, 1, 1)	
					GameTooltip:AddDoubleLine(STAT_HASTE, format("%.2f%%", Total_Range_Haste), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_ATTACK_SPEED, format("%.2f".." (sec)", Total_Range_Speed), 1, 1, 1)					
				else
					local Melee_Crit = GetCritChance("player")
					--local Melee_Armor_Pen = GetArmorPenetration();
					local Total_Melee_Haste = GetMeleeHaste("player")
					local mainSpeed = UnitAttackSpeed("player");
					local MH = mainSpeed
					
					GameTooltip:AddLine(STAT_CATEGORY_MELEE)
					--GameTooltip:AddDoubleLine("Armor Penetration", format("%.2f%%", Melee_Armor_Pen), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_CRITICAL_STRIKE, format("%.2f%%", Melee_Crit), 1, 1, 1)		
					GameTooltip:AddDoubleLine(STAT_HASTE, format("%.2f%%", Total_Melee_Haste), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_ATTACK_SPEED, format("%.2f".." (sec)", MH), 1, 1, 1)
				end
			end
			if GetCombatRating(CR_MASTERY) ~= 0 and GetSpecialization() then
				local masteryspell = GetSpecializationMasterySpells(GetSpecialization())
				local Mastery = GetMasteryEffect("player")
				local masteryName, _, _, _, _, _, _, _, _ = GetSpellInfo(masteryspell)
				if masteryName then
					GameTooltip:AddDoubleLine(masteryName, format("%.2f%%", Mastery), 1, 1, 1)
				end
			end
				
			GameTooltip:AddLine' '
			GameTooltip:AddLine(STAT_CATEGORY_GENERAL)
			
			local Life_Steal = GetLifesteal();
			--local Versatility = GetVersatility();
			local Versatility_Damage_Bonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
			local Avoidance = GetAvoidance();
			local bonusArmor, isNegatedForSpec = UnitBonusArmor("player");
			
			GameTooltip:AddDoubleLine(STAT_BONUS_ARMOR, format("%s", bonusArmor), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_LIFESTEAL, format("%.2f%%", Life_Steal), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_VERSATILITY, format("%.2f%%", Versatility_Damage_Bonus), 1, 1, 1)
			--GameTooltip:AddDoubleLine(STAT_VERSATILITY, format("%d", Versatility), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_AVOIDANCE, format("%.2f%%", Avoidance), 1, 1, 1)			
		end

		GameTooltip:Show()
	end

	local function UpdateTank(self)
		local armorString = hexa..ARMOR..hexb..": "
		local displayNumberString = string.join("", "%s", "%d|r");
		local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
		local Melee_Reduction = effectiveArmor
		
		Text:SetFormattedText(displayNumberString, armorString, effectiveArmor)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		local spellpwr = GetSpellBonusDamage("2");
		local displayNumberString = string.join("", "%s", "%d|r");
		
		Text:SetFormattedText(displayNumberString, hexa.."SP: "..hexb, spellpwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateDamager(self)	
		local displayNumberString = string.join("", "%s", "%d|r");
			
		if englishClass == "HUNTER" then
			local base, posBuff, negBuff = UnitRangedAttackPower("player")
			local Range_AP = base + posBuff + negBuff	
			pwr = Range_AP
		else
			local base, posBuff, negBuff = UnitAttackPower("player")
			local Melee_AP = base + posBuff + negBuff		
			pwr = Melee_AP
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
		if cData.playerRole == nil then
			Text:SetText(hexa.."No Stats"..hexb)
		else
			if cData.playerRole == "TANK" then 
				UpdateTank(self)
			elseif cData.playerRole == "HEALER" or cData.playerRole == "CASTER" then
				UpdateCaster(self)
			elseif cData.playerRole == "DAMAGER" then
				UpdateDamager(self)
			end
		end
		int = 2
	end

	plugin:SetScript("OnEnter", function() ShowTooltip(plugin) end)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	plugin:SetScript("OnUpdate", Update)
	Update(plugin, 10)

	return plugin -- important!
end