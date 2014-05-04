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
		
		fontNormal = 		[[Interface\Addons\nData\Media\NORMAL.ttf]],
		fontSize = 15,
			
		battleground = true,                            	-- enable 3 stats in battleground only that replace stat1,stat2,stat3.
		bag = false,										-- True = Open Backpack; False = Open All bags			
		classcolor = true,
		recountraiddps 	= false,							-- Enables tracking or Recounts Raid DPS
		
		
		-- Color Datatext	
		customcolor = { r = 1, g = 1, b = 1},				-- Color of Text for Datapanel
		
		-- Stat Locations
		bags			= "P9",		-- show space used in bags on panel.	
		system 			= "P0",		-- show total memory and others systems info (FPS/MS) on panel.	
		guild 			= "P4",		-- show number on guildmate connected on panel.
		dur 			= "P8",		-- show your equipment durability on panel.
		friends 		= "P6",		-- show number of friends connected.
		spec 			= "P5",		-- show your current spec on panel.
		coords 			= "P0",		-- show your current coords on panel.
		pro 			= "P7",		-- shows your professions and tradeskills
		stat1 			= "P1",		-- Stat Based on your Role (Avoidance-Tank, AP-Melee, SP/HP-Caster)
		stat2 			= "P3",		-- Stat Based on your Role (Armor-Tank, Crit-Melee, Crit-Caster)
		recount 		= "P2",		-- Stat Based on Recount"s DPS	
		calltoarms 		= "P0",		-- Show Current Call to Arms.		
	}
}

------------------------------------------------------------------------
-- Constants (variables whose values are never altered):
------------------------------------------------------------------------
local GAME_LOCALE = GetLocale()
local BACKGROUND = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]]
local BORDERPANEL = [[Interface\AddOns\nData\Media\UI-DialogBox-Border.blp]]


------------------------------------------------------------------------
-- Variables that point to frames or other objects:
------------------------------------------------------------------------
local Datapanel, StatPanelLeft, StatPanelCenter, StatPanelRight, BGPanel
local classColor, currentFightDPS

------------------------------------------------------------------------
--	 nData Functions
------------------------------------------------------------------------

function nData:SetDataPanel()

	Datapanel = CreateFrame("Frame", "Datapanel", UIParent)

	Datapanel:SetPoint("BOTTOM", UIParent, 0, 0)
	Datapanel:SetWidth(1200)
	Datapanel:SetFrameLevel(1)
	Datapanel:SetHeight(35)
	Datapanel:SetFrameStrata("LOW")
	Datapanel:SetBackdrop({ bgFile = BACKGROUND, edgeFile = BORDERPANEL, edgeSize = 25, insets = { left = 5, right = 5, top = 5, bottom = 5 } })
	Datapanel:SetBackdropColor(0, 0, 0, 1)

	-- Hide Panels When in a Vehicle or Pet Battle
	Datapanel:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
	Datapanel:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	Datapanel:RegisterUnitEvent("PET_BATTLE_OPENING_START")
	Datapanel:RegisterUnitEvent("PET_BATTLE_CLOSE")
	Datapanel:RegisterUnitEvent("PLAYER_ENTERING_WORLD")

	Datapanel:SetScript("OnEvent", function(self, event, ...)
		if event == "UNIT_ENTERING_VEHICLE" or event == "PET_BATTLE_OPENING_START" then
			self:Hide()
		elseif event == "UNIT_EXITED_VEHICLE" or event == "PET_BATTLE_CLOSE" or event == "PLAYER_ENTERING_WORLD" then	
			self:Show()
		end
	end)	
	
	if Adjust then	
		Adjust:RegisterBottom(Datapanel)
	end
	
		-- Move the tooltip above the Actionbar
	hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
		self:SetPoint('BOTTOMRIGHT', UIParent, -95, 135)
	end)

end

function nData:SetStatPanelLeft()
	StatPanelLeft = CreateFrame("Frame", nil, Datapanel)
	StatPanelLeft:SetPoint("LEFT", Datapanel, 5, 0)
	StatPanelLeft:SetHeight(35)
	StatPanelLeft:SetWidth(1200 / 3)
	StatPanelLeft:SetFrameStrata("MEDIUM")
	StatPanelLeft:SetFrameLevel(1)
	
	StatPanelLeft:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
	StatPanelLeft:SetScript("OnEvent", function(self, event, ...)
		if event == 'PLAYER_ENTERING_WORLD' then
			local inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == 'pvp') then			
				self:Hide()
			else
				self:Show()
			end
		end
	end)
end

function nData:SetStatPanelCenter()	
	StatPanelCenter = CreateFrame("Frame", nil, Datapanel)
	StatPanelCenter:SetPoint("CENTER", Datapanel, 0, 0)
	StatPanelCenter:SetHeight(35)
	StatPanelCenter:SetWidth(1200 / 3)
	StatPanelCenter:SetFrameStrata("MEDIUM")
	StatPanelCenter:SetFrameLevel(1)
end

function nData:SetStatPanelRight()
	StatPanelRight = CreateFrame("Frame", nil, Datapanel)
	StatPanelRight:SetPoint("RIGHT", Datapanel, -5, 0)
	StatPanelRight:SetHeight(35)
	StatPanelRight:SetWidth(1200 / 3)
	StatPanelRight:SetFrameStrata("MEDIUM")
	StatPanelRight:SetFrameLevel(1)
end

function nData:PlacePlugin(position, plugin)
	local left = StatPanelLeft
	local center = StatPanelCenter
	local right = StatPanelRight

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
		StatPanelLeft,
		StatPanelCenter,
		StatPanelRight,
	})	do
		anchor = 'ANCHOR_TOP'
	end	
	return anchor, panel, xoff, yoff
end	


function nData:OnInitialize()
	-- Assuming the .toc says ## SavedVariables: MyAddonDB
	self.db = LibStub("AceDB-3.0"):New("nDataDB", defaults, true)
	db = self.db.profile
	
	self:SetUpOptions();

	self.OnInitialize = nil	
end

function nData:OnEnable()
	-- This line should not be needed if you're using modules correctly:
	if not db.enable then return end

	if db.enable then -- How is this different than "enable" ? If the panel is not enabled, what's the point of doing anything else?
		self:CreatePanel() -- factor this giant blob out into its own function to keep things clean
		self:Refresh()
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
	
	-- no need to make a separate frame to handle events, your module object already does this!
	self:UpdatePlayerRole()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "UpdatePlayerRole")	
end

function nData:Refresh()
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

function nData:CreatePanel()

	if Datapanel then return end -- already done
	
	-- Setup the Panels
	self:SetDataPanel()
	self:SetStatPanelLeft()
	self:SetStatPanelCenter()
	self:SetStatPanelRight()

end

function nData:UpdatePlayerRole()
	local spec = GetSpecialization()
	local specRole = GetSpecializationRole(spec) -- no need for a giant table that must be maintained by hand
	if specRole == "TANK" then
		playerRole = "Tank"
	elseif specRole == "HEALER" then
		playerRole = "Caster"
	elseif specRole == "DAMAGER" then
		if UnitPowerType("player") == SPELL_POWER_MANA then
			playerRole = "Caster"
		else
			playerRole = "Melee"
		end
	else
		playerRole = nil -- no spec
	end
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
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,
						name = " ",
					},
					---------------------------
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
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable nData"],
						width = "full"
					},
					time24 = {
						type = "toggle",
						order = 2,
						name = L["24-Hour Time"],
						desc = L["Display time datapanel on a 24 hour time scale"],
						disabled = function() return  not db.enable end,
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
						name = L["Game Font Size"],
						desc = L["Controls the Size of the Game Font"],
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
						name = L["Text Positions"],
						guiInline  = true,
						disabled = function() return  not db.enable end,
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,
								name = " ",
							},
							---------------------------							
							bags = {
								type = "select",
								order = 5,
								name = L["Bags"],
								desc = L["Display amount of bag space"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							calltoarms = {
								type = "select",
								order = 5,
								name = L["Call to Arms"],
								desc = L["Display the active roles that will recieve a reward for completing a random dungeon"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							coords = {
								type = "select",
								order = 5,
								name = L["Coordinates"],
								desc = L["Display Player's Coordinates"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							dps_text = {
								type = "select",
								order = 5,
								name = L["DPS"],
								desc = L["Display amount of DPS"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							dur = {
								type = "select",
								order = 5,
								name = L["Durability"],
								desc = L["Display your current durability"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							friends = {
								type = "select",
								order = 5,
								name = L["Friends"],
								desc = L["Display current online friends"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							guild = {
								type = "select",
								order = 5,
								name = L["Guild"],
								desc = L["Display current online people in guild"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							hps_text = {
								type = "select",
								order = 5,
								name = L["HPS"],
								desc = L["Display amount of HPS"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							pro = {
								type = "select",
								order = 5,
								name = L["Professions"],
								desc = L["Display Professions"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							recount = {
								type = "select",
								order = 5,
								name = L["Recount"],
								desc = L["Display Recount's DPS (RECOUNT MUST BE INSTALLED)"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							spec = {
								type = "select",
								order = 5,
								name = L["Talent Spec"],
								desc = L["Display current spec"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							stat1 = {
								type = "select",
								order = 5,
								name = L["Stat #1"],
								desc = L["Display stat based on your role (Avoidance-Tank, AP-Melee, SP/HP-Caster)"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							stat2 = {
								type = "select",
								order = 5,
								name = L["Stat #2"],
								desc = L["Display stat based on your role (Armor-Tank, Crit-Melee, Crit-Caster)"],
								values = statposition;
								disabled = function() return  not db.enable end,
							},
							system = {
								type = "select",
								order = 5,
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