local nData = LibStub("AceAddon-3.0"):NewAddon("nData", "AceEvent-3.0")
local Adjust = LibStub:GetLibrary("LibBasicAdjust-1.0", true)
local L = setmetatable({}, { __index = function(t,k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })


------------------------------------------------------------------------
--	 nData Database
------------------------------------------------------------------------
local db
local defaults = {
	profile = {
		enable = true,
		
		font = [[Fonts\ARIALN.ttf]],
		fontSize = 15,
			
		battleground = true,                            	-- enable 3 stats in battleground only that replace stat1,stat2,stat3.
		bag = false,										-- True = Open Backpack; False = Open All bags			
		classcolor = true,
		recountraiddps 	= false,							-- Enables tracking or Recounts Raid DPS
		
		
		-- Color Datatext	
		customcolor = { r = 1, g = 1, b = 1},				-- Color of Text for Datapanel
		
		-- Stat Locations
		bags			= "P9",		-- show space used in bags on panel.	
		system 			= "P1",		-- show total memory and others systems info (FPS/MS) on panel.	
		guild 			= "P4",		-- show number on guildmate connected on panel.
		dur 			= "P8",		-- show your equipment durability on panel.
		friends 		= "P6",		-- show number of friends connected.
		spec 			= "P5",		-- show your current spec on panel.
		coords 			= "P0",		-- show your current coords on panel.
		pro 			= "P7",		-- shows your professions and tradeskills
		stats 			= "P3",		-- Stat Based on your Role (Avoidance-Tank, AP-Melee, SP/HP-Caster)
		recount 		= "P2",		-- Stat Based on Recount"s DPS	
		calltoarms 		= "P0",		-- Show Current Call to Arms.		
	}
}

------------------------------------------------------------------------
-- Variables that point to frames or other objects:
------------------------------------------------------------------------
local nDataMainPanel, nDataLeftStatPanel, nDataCenterStatPanel, nDataRightStatPanel, nDataBattleGroundStatPanel
local currentFightDPS
local _, class = UnitClass("player")
local ccolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]

------------------------------------------------------------------------
--	 nData Functions
------------------------------------------------------------------------

function nData:CreatePanels()
	if nDataMainPanel then return end -- already done
	
	-- Create All Panels
	------------------------------------------------------------------------
	nDataMainPanel = CreateFrame("Frame", "nDataMainPanel", UIParent)
	nDataLeftStatPanel = CreateFrame("Frame", "nDataLeftStatPanel", nDataMainPanel)
	nDataCenterStatPanel = CreateFrame("Frame", "nDataCenterStatPanel", nDataMainPanel)
	nDataRightStatPanel = CreateFrame("Frame", "nDataRightStatPanel", nDataMainPanel)
	nDataBattleGroundStatPanel = CreateFrame("Frame", "nDataBattleGroundStatPanel", nDataMainPanel)
	
	
	-- Multi Panel Settings
	------------------------------------------------------------------------
	for _, panelz in pairs({
		nDataMainPanel,
		nDataLeftStatPanel,
		nDataCenterStatPanel,
		nDataRightStatPanel,
		nDataBattleGroundStatPanel,
	}) do
		panelz:SetHeight(35)
		panelz:SetFrameStrata("LOW")	
		panelz:SetFrameLevel(1)
	end

	-- Main Panel Settings
	------------------------------------------------------------------------
	nDataMainPanel:SetPoint("BOTTOM", UIParent, 0, 0)
	nDataMainPanel:SetWidth(1200)
	nDataMainPanel:SetBackdrop({ 
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], 
		edgeFile = [[Interface\AddOns\nData\Media\UI-DialogBox-Border.blp]], 
		edgeSize = 25, insets = { left = 5, right = 5, top = 5, bottom = 5 } 
	})
	nDataMainPanel:SetBackdropColor(0, 0, 0, 1)
	
	
	-- Left Stat Panel Settings
	------------------------------------------------------------------------
	nDataLeftStatPanel:SetPoint("LEFT", nDataMainPanel, 5, 0)
	nDataLeftStatPanel:SetWidth(1200 / 3)
	nDataLeftStatPanel:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
	nDataLeftStatPanel:SetScript("OnEvent", function(self, event, ...)
		if event == 'PLAYER_ENTERING_WORLD' then
			local inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == 'pvp') then			
				self:Hide()
			else
				self:Show()
			end
		end
	end)	
	
	-- Center Stat Panel Settings
	-----------------------------------------------------------------------
	nDataCenterStatPanel:SetPoint("CENTER", nDataMainPanel, 0, 0)
	nDataCenterStatPanel:SetWidth(1200 / 3)
	
	-- Right Stat Panel Settings
	-----------------------------------------------------------------------
	nDataRightStatPanel:SetPoint("RIGHT", nDataMainPanel, -5, 0)
	nDataRightStatPanel:SetWidth(1200 / 3)
	
	-- Battleground Stat Panel Settings
	-----------------------------------------------------------------------
	nDataBattleGroundStatPanel:SetAllPoints(nDataLeftStatPanel)
	
	-- Hide Panels When in a Vehicle or Pet Battle
	------------------------------------------------------------------------
	nDataMainPanel:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
	nDataMainPanel:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	nDataMainPanel:RegisterUnitEvent("PET_BATTLE_OPENING_START")
	nDataMainPanel:RegisterUnitEvent("PET_BATTLE_CLOSE")
	nDataMainPanel:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
	

	if Adjust then	
		nDataMainPanel:SetScript("OnEvent", function(self, event, ...)
			if event == "UNIT_ENTERING_VEHICLE" or event == "PET_BATTLE_OPENING_START" then
				Adjust:Unregister(nDataMainPanel)	
				self:Hide()
			elseif event == "UNIT_EXITED_VEHICLE" or event == "PET_BATTLE_CLOSE" or event == "PLAYER_ENTERING_WORLD" then	
				Adjust:RegisterBottom(nDataMainPanel)
				self:Show()
			end
		end)	
	end

end

function nData:SetBattlegroundPanel()
	
	--Map IDs
	local WSG = 443
	local TP = 626
	local AV = 401
	local SOTA = 512
	local IOC = 540
	local EOTS = 482
	local TBFG = 736
	local AB = 461

	nDataBattleGroundStatPanel:SetScript('OnEnter', function(self)
		local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
			if ( name ) then
				if ( name == UnitName('player') ) then
					GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
					GameTooltip:ClearLines()
					GameTooltip:SetPoint('BOTTOM', self, 'TOP', 0, 1)
					GameTooltip:ClearLines()
					GameTooltip:AddLine("Stats for : "..hexa..name..hexb)
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine("Killing Blows:", killingBlows,1,1,1)
					GameTooltip:AddDoubleLine("Honorable Kills:", honorableKills,1,1,1)
					GameTooltip:AddDoubleLine("Deaths:", deaths,1,1,1)
					GameTooltip:AddDoubleLine("Honor Gained:", format('%d', honorGained),1,1,1)
					GameTooltip:AddDoubleLine("Damage Done:", damageDone,1,1,1)
					GameTooltip:AddDoubleLine("Healing Done:", healingDone,1,1,1)
					--Add extra statistics to watch based on what BG you are in.
					if curmapid == WSG or curmapid == TP then 
						GameTooltip:AddDoubleLine("Flags Captured:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Flags Returned:",GetBattlefieldStatData(i, 2),1,1,1)
					elseif curmapid == EOTS then
						GameTooltip:AddDoubleLine("Flags Captured:",GetBattlefieldStatData(i, 1),1,1,1)
					elseif curmapid == AV then
						GameTooltip:AddDoubleLine("Graveyards Assaulted:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Graveyards Defended:",GetBattlefieldStatData(i, 2),1,1,1)
						GameTooltip:AddDoubleLine("Towers Assaulted:",GetBattlefieldStatData(i, 3),1,1,1)
						GameTooltip:AddDoubleLine("Towers Defended:",GetBattlefieldStatData(i, 4),1,1,1)
					elseif curmapid == SOTA then
						GameTooltip:AddDoubleLine("Demolishers Destroyed:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Gates Destroyed:",GetBattlefieldStatData(i, 2),1,1,1)
					elseif curmapid == IOC or curmapid == TBFG or curmapid == AB then
						GameTooltip:AddDoubleLine("Bases Assaulted:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Bases Defended:",GetBattlefieldStatData(i, 2),1,1,1)
					end					
					GameTooltip:Show()
				end
			end
		end
	end) 
	nDataBattleGroundStatPanel:SetScript('OnLeave', function(self) GameTooltip:Hide() end)

	local f = CreateFrame('Frame', nil)
	f:EnableMouse(true)

	local Text1  = nDataBattleGroundStatPanel:CreateFontString(nil, 'OVERLAY')
	Text1:SetFont(db.font, db.fontSize,'THINOUTLINE')
	Text1:SetPoint('LEFT', nDataBattleGroundStatPanel, 30, 0)
	Text1:SetHeight(nDataMainPanel:GetHeight())

	local Text2  = nDataBattleGroundStatPanel:CreateFontString(nil, 'OVERLAY')
	Text2:SetFont(db.font, db.fontSize,'THINOUTLINE')
	Text2:SetPoint('CENTER', nDataBattleGroundStatPanel, 0, 0)
	Text2:SetHeight(nDataMainPanel:GetHeight())

	local Text3  = nDataBattleGroundStatPanel:CreateFontString(nil, 'OVERLAY')
	Text3:SetFont(db.font, db.fontSize,'THINOUTLINE')
	Text3:SetPoint('RIGHT', nDataBattleGroundStatPanel, -30, 0)
	Text3:SetHeight(nDataMainPanel:GetHeight())

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
					dmgtxt = ("Healing : "..hexa..healingDone..hexb)
				else
					dmgtxt = ("Damage : "..hexa..damageDone..hexb)
				end
				if ( name ) then
					if ( name == PLAYER_NAME ) then
						Text2:SetText("Honor : "..hexa..format('%d', honorGained)..hexb)
						Text1:SetText(dmgtxt)
						Text3:SetText("Killing Blows : "..hexa..killingBlows..hexb)
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
				nDataBattleGroundStatPanel:Show()
			else
				Text1:SetText('')
				Text2:SetText('')
				Text3:SetText('')
				nDataBattleGroundStatPanel:Hide()
			end
		end
	end

	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:SetScript('OnEvent', OnEvent)
	f:SetScript('OnUpdate', Update)
	Update(f, 10)
end

function nData:PlacePlugin(position, plugin)
	local left = nDataLeftStatPanel
	local center = nDataCenterStatPanel
	local right = nDataRightStatPanel

	-- Left Panel Data
	if position == "P1" then
		plugin:SetParent(left)
		plugin:SetHeight(left:GetHeight())
		plugin:SetPoint('LEFT', left, 30, 0)
		plugin:SetPoint('TOP', left)
		plugin:SetPoint('BOTTOM', left)
	elseif position == "P2" then
		plugin:SetParent(left)
		plugin:SetHeight(left:GetHeight())
		plugin:SetPoint('TOP', left)
		plugin:SetPoint('BOTTOM', left)
	elseif position == "P3" then
		plugin:SetParent(left)
		plugin:SetHeight(left:GetHeight())
		plugin:SetPoint('RIGHT', left, -30, 0)
		plugin:SetPoint('TOP', left)
		plugin:SetPoint('BOTTOM', left)

	-- Center Panel Data
	elseif position == "P4" then
		plugin:SetParent(center)
		plugin:SetHeight(center:GetHeight())
		plugin:SetPoint('LEFT', center, 30, 0)
		plugin:SetPoint('TOP', center)
		plugin:SetPoint('BOTTOM', center)
	elseif position == "P5" then
		plugin:SetParent(center)
		plugin:SetHeight(center:GetHeight())
		plugin:SetPoint('TOP', center)
		plugin:SetPoint('BOTTOM', center)
	elseif position == "P6" then
		plugin:SetParent(center)
		plugin:SetHeight(center:GetHeight())
		plugin:SetPoint('RIGHT', center, -30, 0)
		plugin:SetPoint('TOP', center)
		plugin:SetPoint('BOTTOM', center)

	-- Right Panel Data
	elseif position == "P7" then
		plugin:SetParent(right)
		plugin:SetHeight(right:GetHeight())
		plugin:SetPoint('LEFT', right, 30, 0)
		plugin:SetPoint('TOP', right)
		plugin:SetPoint('BOTTOM', right)
	elseif position == "P8" then
		plugin:SetParent(right)
		plugin:SetHeight(right:GetHeight())
		plugin:SetPoint('TOP', right)
		plugin:SetPoint('BOTTOM', right)
	elseif position == "P9" then
		plugin:SetParent(right)
		plugin:SetHeight(right:GetHeight())
		plugin:SetPoint('RIGHT', right, -30, 0)
		plugin:SetPoint('TOP', right)
		plugin:SetPoint('BOTTOM', right)
	elseif position == "P0" then
		return
	end
end

function nData:DataTextTooltipAnchor(self)
	local panel = self:GetParent()
	local anchor = 'GameTooltip'
	local xoff = 1
	local yoff = 3
	
	
	for _, panel in pairs ({
		nDataLeftStatPanel,
		nDataCenterStatPanel,
		nDataRightStatPanel,
	})	do
		anchor = 'ANCHOR_TOP'
	end	
	return anchor, panel, xoff, yoff
end	


function nData:OnInitialize()
	-- Assuming the .toc says ## SavedVariables: MyAddonDB
	self.db = LibStub("AceDB-3.0"):New("nDataDB", defaults, true)
	db = self.db.profile
	
	if not db.enable then return end
	
	self:SetUpOptions();
	self:CreatePanels() -- factor this giant blob out into its own function to keep things clean
end

function nData:OnEnable()

	local db = self.db.profile
	PLAYER_NAME = UnitName("player")
	
	if db.classcolor ~= true then
		local r, g, b = db.customcolor.r, db.customcolor.g, db.customcolor.b
		hexa = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
		hexb = "|r"
	else
		hexa = ("|cff%.2x%.2x%.2x"):format(ccolor.r * 255, ccolor.g * 255, ccolor.b * 255)
		hexb = "|r"
	end		
	
	-- Rather than hardcode all the possible plugins here just use a nice table that you can add/remove stuff to much more easily. Scroll to the bottom to see it.
	self.plugins = {}
	for name, constructor in pairs(self.pluginConstructors) do
		local position = db[name]
		if position then
			local plugin = constructor()
			self.plugins[name] = plugin
			self:PlacePlugin(position, plugin)
		end
	end
	
	-- Move the tooltip above the Actionbar
	hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
		self:SetPoint('BOTTOMRIGHT', UIParent, -95, 135)
	end)
	
	-- no need to make a separate frame to handle events, your module object already does this!
	self:UpdatePlayerRole()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "UpdatePlayerRole")
	self:Refresh()
end

function nData:Refresh()
	db = self.db.profile

	if InCombatLockdown() then
		return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEnable")
	end
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function nData:SetFontString(parent, file, size, flags)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(file, size, flags)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

local isCaster = {
	-- All Classes are needed as to not cause a error when the table is called.
	-- SpecID - Spec - Role
	DEATHKNIGHT = {
		nil, -- 250 - Blood - (TANK) 
		nil, -- 251 - Frost - (MELEE_DPS)
		nil, -- 252 - Unholy - (MELEE_DPS)
	},
	DRUID = { 
		true, -- 102 - Balance - (CASTER_DPS)
		nil,  -- 103 - Feral - (MELEE_DPS)
		nil,  -- 104 Guardian - (TANK)
		nil,  -- 105 Restoration - (HEALER)
	},
	HUNTER = {
		nil, -- 253 - Beast Mastery - (RANGED_DPS)
		nil, -- 254 - Marksmanship - (RANGED_DPS)
		nil, -- 255 - Survival - (RANGED_DPS)
	},
	MAGE = { 
		true, -- 62 - Arcane - (CASTER_DPS)
		true, -- 63 - Fire - (CASTER_DPS)
		true, -- 64 - Frost - (CASTER_DPS)
	}, 
	MONK = {
		nil, -- 268 - Brewmaster - (TANK)
		nil, -- 269 - Windwalker - (MELEE_DPS)
		nil, -- 270 - Mistweaver - (HEALER)
	}, 
	PALADIN = {
		nil, -- 65 - Holy - (HEALER)
		nil, -- 66 - Protection - (TANK)
		nil, -- 70 - Retribution - (MELEE_DPS)
	},
	PRIEST = { 
		nil,  -- 256 - Discipline - (HEALER}
		nil,  -- 257 - Holy - (HEALER)
		true, -- 258 - Shadow - (CASTER_DPS)
	},
	ROGUE = {
		nil, -- 259 - Assassination - (MELEE_DPS)
		nil, -- 260 - Combat - (MELEE_DPS)
		nil, -- 261 - Subtlety - (MELEE_DPS)
	}, 
	SHAMAN = { 
		true, -- 262 - Elemental - (CASTER_DPS)
		nil,  -- 263 - Enhancement - (MELEE_DPS)
		nil,  -- 264 - Restoration - (HEALER)
	},
	WARLOCK = { 
		true, -- 265 - Affliction - (CASTER_DPS)
		true, -- 266 - Demonology - (CASTER_DPS)
		true, -- 267 - Destruction - (CASTER_DPS)
	}, 
	WARRIOR = {
		nil, -- 71 - Arms - (MELEE_DPS)
		nil, -- 72 - Furry - (MELEE_DPS)
		nil, -- 73 - Protection - (TANK)
	},
}

function nData:UpdatePlayerRole()	
	local spec = GetSpecialization()
	if not spec then
		self.playerRole = nil
		return
	end

	local specRole = GetSpecializationRole(spec)
	if specRole == "DAMAGER" then
		if isCaster[class][spec] then
			self.playerRole = "CASTER"
			return
		end
	end

	self.playerRole = specRole
end

function nData:SetUpOptions()
	local options = self:GetOptions()

	-- @PHANX: add this to your options table instead of registering it separately:
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("nData", options)

	-- @PHANX: You could write out each subkey but let's be lazy:
	local panels = {}

	local Dialog = LibStub("AceConfigDialog-3.0")

	-- Use the "welcome" panel as the main one:
	self.optionsFrame = Dialog:AddToBlizOptions("nData", "nData", nil, "datatext")

	-- Add the profile panel last:
	Dialog:AddToBlizOptions("nData", options.args.profile.name, "nData", "profile")

end

------------------------------------------------------------------------
-- Stat Creation
------------------------------------------------------------------------
-- This can be simplified hugely by using a table, instead of a bunch of if/end blocks.

nData.pluginConstructors = {}
		
------------------------------------------------------------------------
--	 nData Options
------------------------------------------------------------------------

local options
function nData:GetOptions()
	if options then
		return options
	end

	local statposition = {
		["P0"] = L["Not Shown"],
		["P1"] = L["Position #1"],
		["P2"] = L["Position #2"],
		["P3"] = L["Position #3"],
		["P4"] = L["Position #4"],
		["P5"] = L["Position #5"],
		["P6"] = L["Position #6"],
		["P7"] = L["Position #7"],
		["P8"] = L["Position #8"],
		["P9"] = L["Position #9"],
	}
	
	options = {
		type = "group",
		name = L["nData"],
		childGroups = "tree",
		get = function(info) return db[ info[#info] ] end,
		set = function(info, value) db[ info[#info] ] = value;   end,
		args = {
			datatext = { 
				type = "group",
				order = 1,
				name = "nData",
				args = {			
					reloadUI = {
						type = "execute",
						name = "Reload UI",
						desc = " ",
						order = 0,
						func = 	function()
							ReloadUI()
						end,
					},
					Text = {
						type = "description",
						order = 0,
						name = "When changes are made a reload of the UI is needed.",
						width = "full",
					},
					Text1 = {
						type = "description",
						order = 1,
						name = " ",
						width = "full",
					},
					bag = {
						type = "toggle",
						order = 2,
						name = L["Bag Open"],
						desc = L["Checked opens Backpack only, Unchecked opens all bags."],
						disabled = function() return  not db.enable end,
					},
					battleground = {
						type = "toggle",
						order = 2,
						name = L["Battleground Text"],
						desc = L["Display special datapanels when inside a battleground"],
						disabled = function() return  not db.enable end,
					},
					recountraiddps = {
						type = "toggle",
						order = 2,
						name = L["Recount Raid DPS"],
						desc = L["Display Recount's Raid DPS (RECOUNT MUST BE INSTALLED)"],
						disabled = function() return  not db.enable end,
					},
					fontSize = {
						type = "range",
						order = 5,						
						name = L["Stat Font Size"],
						desc = L["Controls the Size of the Stat Font"],
						disabled = function() return not db.enable end,
						min = 0, max = 30, step = 1,
					},
					classcolor = {
						type = "toggle",					
						order = 2,
						name = L["Class Color"],
						desc = L["Use your classcolor for border and some text color."],
						disabled = function() return not db.enable end,
					},
					DataGroup = {
						type = "group",
						order = 6,
						name = L["Stat Positions"],
						guiInline  = true,
						disabled = function() return  not db.enable end,
						args = {						
							bags = {
								type = "select",
								name = L["Bags"],
								desc = L["Display amount of bag space"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							calltoarms = {
								type = "select",
								name = L["Call to Arms"],
								desc = L["Display the active roles that will recieve a reward for completing a random dungeon"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							coords = {
								type = "select",
								name = L["Coordinates"],
								desc = L["Display Player's Coordinates"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							dur = {
								type = "select",
								name = L["Durability"],
								desc = L["Display your current durability"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							friends = {
								type = "select",
								name = L["Friends"],
								desc = L["Display current online friends"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							guild = {
								type = "select",
								name = L["Guild"],
								desc = L["Display current online people in guild"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							pro = {
								type = "select",
								name = L["Professions"],
								desc = L["Display Professions"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							recount = {
								type = "select",
								name = L["Recount"],
								desc = L["Display Recount's DPS (RECOUNT MUST BE INSTALLED)"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							spec = {
								type = "select",
								name = L["Talent Spec"],
								desc = L["Display current spec"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							stats = {
								type = "select",
								name = L["Statistics"],
								desc = L["Display stat based on your role (Avoidance-Tank, AP-Melee, SP/HP-Caster)"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							system = {
								type = "select",
								name = L["System"],
								desc = L["Display FPS and Latency"],
								values = statposition;
								disabled = function() return not db.enable end,
							},
						},
					},
				},
			},
		},
	}
	return options
end