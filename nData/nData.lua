local nData = LibStub("AceAddon-3.0"):NewAddon("nData")

-- Media --
local NDATA_BACKGROUND = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]]
local NDATA_BORDERPANEL = [[Interface\AddOns\nData\Media\UI-DialogBox-Border.blp]]

SlashCmdList['RELOADUI'] = function()
	ReloadUI()
end
SLASH_RELOADUI1 = '/rl'
	
local defaults = {

    profile = {
	
		ModuleEnabledState = {
			["*"] = true
		},

		datapanel = {
			
			fontNormal = 		[[Interface\Addons\nData\Media\NORMAL.ttf]],
			fontSize = 15,
			
			classcolor = true,
			enable = true,
			battleground = true,                            	-- enable 3 stats in battleground only that replace stat1,stat2,stat3.
			bag = false,										-- True = Open Backpack; False = Open All bags			

			-- nData Media
			border = NDATA_BORDERPANEL,							-- Border for Datapanel ( Choose either Datapanel or Neav for border choice)
			background = NDATA_BACKGROUND,						-- Background for Datapanel	
			
			-- Color Datatext	
			customcolor = { r = 1, g = 1, b = 1},				-- Color of Text for Datapanel
			
			location = "bottom",								-- 3 Choices for panel placement = "top", "bottom", or "shortbar". Shortbar is to match nMainbar shortbar.
			armor = "P0",                                     	-- show your armor value against the level mob you are currently targeting.
			avd = "P0",                                        	-- show your current avoidance against the level of the mob your targeting	
			bags = "P9",                                       	-- show space used in bags on panel.
			haste = "P0",                                      	-- show your haste rating on panels.	
			system = "P0",                                     	-- show total memory and others systems info (FPS/MS) on panel.	
			guild = "P4",                                      	-- show number on guildmate connected on panel.
			dur = "P8",                                        	-- show your equipment durability on panel.
			friends = "P6",                                    	-- show number of friends connected.
			dps_text = "P0",                                   	-- show a dps meter on panel.
			hps_text = "P0",                                   	-- show a heal meter on panel.
			spec = "P5",										-- show your current spec on panel.
			coords = "P0",										-- show your current coords on panel.
			pro = "P7",											-- shows your professions and tradeskills
			stat1 = "P1",										-- Stat Based on your Role (Avoidance-Tank, AP-Melee, SP/HP-Caster)
			stat2 = "P3",										-- Stat Based on your Role (Armor-Tank, Crit-Melee, Crit-Caster)
			recount = "P2",										-- Stat Based on Recount"s DPS
			recountraiddps = false,								-- Enables tracking or Recounts Raid DPS
			calltoarms = "P0",									-- Show Current Call to Arms.
			
		},
	},
}

function nData:OnInitialize()
	-- Assuming the .toc says ## SavedVariables: MyAddonDB
	self.db = LibStub("AceDB-3.0"):New("nDataDB", defaults, true)
	
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	
	for name, module in self:IterateModules() do
		module:SetEnabledState(self.db.profile.ModuleEnabledState[name] or false)
	end
	
	self:SetUpOptions();
	--self:Greeting()
	
	self.OnInitialize = nil
end

function nData:OnProfileChanged(event, database, newProfileKey)
	for name, module in self:IterateModules() do
		if self.db.profile.ModuleEnabledState[name] then
			module:Enable()
		else
			module:Disable()
		end
	end
end