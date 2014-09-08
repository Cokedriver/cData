local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
--	 Bags Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["bags"] = function()

	db = nData.db.profile
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.bags, Text)

	local Profit	= 0
	local Spent		= 0
	local OldMoney	= 0
	local myPlayerRealm = GetRealmName();
	
	
	local function formatMoney(c)
		local str = ""
		if not c or c < 0 then 
			return str 
		end
		
		if c >= 10000 then
			local g = math.floor(c/10000)
			c = c - g*10000
			str = str..BreakUpLargeNumbers(g).."|cFFFFD800g|r "
		end
		if c >= 100 then
			local s = math.floor(c/100)
			c = c - s*100
			str = str..s.."|cFFC7C7C7s|r "
		end
		if c >= 0 then
			str = str..c.."|cFFEEA55Fc|r"
		end
		
		return str
	end
	
	local function OnEvent(self, event)
		local totalSlots, freeSlots = 0, 0
		local itemLink, subtype, isBag
		for i = 0,NUM_BAG_SLOTS do
			isBag = true
			if i > 0 then
				itemLink = GetInventoryItemLink('player', ContainerIDToInventoryID(i))
				if itemLink then
					subtype = select(7, GetItemInfo(itemLink))
					if (subtype == 'Mining Bag') or (subtype == 'Gem Bag') or (subtype == 'Engineering Bag') or (subtype == 'Enchanting Bag') or (subtype == 'Herb Bag') or (subtype == 'Inscription Bag') or (subtype == 'Leatherworking Bag') or (subtype == 'Fishing Bag')then
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
				elseif freeSlots < 10 then
					Text:SetTextColor(1,0,0)
				elseif freeSlots > 10 then
					Text:SetTextColor(1,1,1)
				end
			self:SetAllPoints(Text)
			
		end
		if event == "PLAYER_ENTERING_WORLD" then
			OldMoney = GetMoney()
		end
		
		local NewMoney	= GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money
		
		if OldMoney>NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Money
			Profit = Profit + Change
		end
		
		self:SetAllPoints(Text)

		local myPlayerName  = UnitName("player")				
		if not nDataDB then nDataDB = {} end
		if not nDataDB.gold then nDataDB.gold = {} end
		if not nDataDB.gold[myPlayerRealm] then nDataDB.gold[myPlayerRealm]={} end
		nDataDB.gold[myPlayerRealm][myPlayerName] = GetMoney()	
			
		OldMoney = NewMoney	
			
	end

	plugin:RegisterEvent("PLAYER_MONEY")
	plugin:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	plugin:RegisterEvent("SEND_MAIL_COD_CHANGED")
	plugin:RegisterEvent("PLAYER_TRADE_MONEY")
	plugin:RegisterEvent("TRADE_MONEY_CHANGED")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:RegisterEvent("BAG_UPDATE")
	
	plugin:SetScript('OnMouseDown', 
		function()
			if db.bag ~= true then
				ToggleAllBags()
			else
				ToggleBag(0)
			end
		end
	)
	plugin:SetScript('OnEvent', OnEvent)	
	plugin:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = nData:DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(hexa..PLAYER_NAME.."'s"..hexb.." Gold", formatMoney(OldMoney), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddLine' '			
			GameTooltip:AddLine("This Session: ")				
			GameTooltip:AddDoubleLine("Earned:", formatMoney(Profit), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine("Spent:", formatMoney(Spent), 1, 1, 1, 1, 1, 1)
			if Profit < Spent then
				GameTooltip:AddDoubleLine("Deficit:", formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
			elseif (Profit-Spent)>0 then
				GameTooltip:AddDoubleLine("Profit:", formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
			end				
			--GameTooltip:AddDoubleLine("Total:", formatMoney(OldMoney), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddLine' '
			
			local totalGold = 0				
			GameTooltip:AddLine("Character's: ")			
			local thisRealmList = nDataDB.gold[myPlayerRealm];
			for k,v in pairs(thisRealmList) do
				GameTooltip:AddDoubleLine(k, formatMoney(v), 1, 1, 1, 1, 1, 1)
				totalGold=totalGold+v;
			end  
			GameTooltip:AddLine' '
			GameTooltip:AddLine("Server:")
			GameTooltip:AddDoubleLine("Total: ", formatMoney(totalGold), 1, 1, 1, 1, 1, 1)

			for i = 1, GetNumWatchedTokens() do
				local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
				if name and i == 1 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(CURRENCY..":")
				end
				local r, g, b = 1,1,1
				if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
				if name and count then GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1) end
			end
			GameTooltip:AddLine' '
			GameTooltip:AddLine("|cffeda55fClick|r to Open Bags")			
			GameTooltip:Show()
		end
	end)
	
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)			
	-- reset gold data
	local function RESETGOLD()
		local myPlayerRealm = GetRealmName();
		local myPlayerName  = UnitName("player");
		
		nDataDB.gold = {}
		nDataDB.gold[myPlayerRealm]={}
		nDataDB.gold[myPlayerRealm][myPlayerName] = GetMoney();
	end
	SLASH_RESETGOLD1 = "/resetgold"
	SlashCmdList["RESETGOLD"] = RESETGOLD	

	return plugin -- important!
end