local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
-- Constants (variables whose values are never altered):
------------------------------------------------------------------------
local _, class = UnitClass("player")
local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
local PLAYER_NAME = UnitName("player")
------------------------------------------------------------------------
--	 Durability Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["dur"] = function()

	db = nData.db.profile

	if db.classcolor ~= true then
		local r, g, b = db.customcolor.r, db.customcolor.g, db.customcolor.b
		hexa = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
		hexb = "|r"
	else
		hexa = ("|cff%.2x%.2x%.2x"):format(classColor.r * 255, classColor.g * 255, classColor.b * 255)
		hexb = "|r"
	end		
	
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
	Text:SetFont(db.fontNormal, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.dur, Text)

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
	plugin:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	plugin:SetScript("OnEvent", OnEvent)
	plugin:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(hexa..PLAYER_NAME.."'s"..hexb.." Durability")
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
		GameTooltip:AddLine("|cffeda55fClick|r to Show Character Panel")
		GameTooltip:Show()
		end
	end)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)

	return plugin -- important!
end