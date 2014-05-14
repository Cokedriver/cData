local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
--	 Statistics 2 Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["stat2"] = function()

	db = nData.db.profile
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:SetFrameStrata("BACKGROUND")
	plugin:SetFrameLevel(3)
	plugin:EnableMouse(true)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.stat2, Text)

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
		if InCombatLockdown() then return end
	
		local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Statistics")
		GameTooltip:AddLine' '	
		if UnitLevel("player") >= 10 then
			if playerRole == "Tank" then
				AddTooltipHeader("Mitigation By Level: ")
				local lv = level +3
				for i = 1, 4 do
					GameTooltip:AddDoubleLine(lv,format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
					lv = lv - 1
				end
				lv = UnitLevel("target")
				if lv and lv > 0 and (lv > level + 3 or lv < level) then
					GameTooltip:AddDoubleLine(lv, format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
				end	
			elseif playerRole == "Caster" or playerRole == "Melee" then
				AddTooltipHeader(MAGIC_RESISTANCES_COLON)
				
				local base, total, bonus, minus
				for i = 2, 6 do
					base, total, bonus, minus = UnitResistance("player", i)
					GameTooltip:AddDoubleLine(_G["DAMAGE_SCHOOL"..(i+1)], format(chanceString, (total / (total + (500 + level + 2.5))) * 100),1,1,1)
				end
				
				local spellpen = GetSpellPenetration()
				if (UNIT_CLASS == "SHAMAN" or playerRole == "Caster") and spellpen > 0 then
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine(ITEM_MOD_SPELL_PENETRATION_SHORT, spellpen,1,1,1)
				end
			end
		else 
			GameTooltip:AddLine("No Stats Available unit Level 10")
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

		Text:SetFormattedText(displayFloatString, hexa.."Crit: "..hexb, spellcrit)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local meleecrit = GetCritChance()
		local rangedcrit = GetRangedCritChance()
		local critChance
			
		if UNIT_CLASS == "HUNTER" then    
			critChance = rangedcrit
		else
			critChance = meleecrit
		end
		
		Text:SetFormattedText(displayFloatString, hexa.."Crit: "..hexb, critChance)
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