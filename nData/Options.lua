local nData = LibStub("AceAddon-3.0"):GetAddon("nData", "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

local L = setmetatable({}, { __index = function(t,k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

local options

local function GetOptions()
	if options then
		return options -- @PHANX: do this first, no point in defining variables if they won't be used
	end

	local db = nData.db.profile -- @PHANX: this should be local here

	local regions = {
		['BOTTOM'] = L['Bottom'],
		['BOTTOMLEFT'] = L['Bottom Left'],
		['BOTTOMRIGHT'] = L['Bottom Right'],
		['CENTER'] = L['Center'],
		['LEFT'] = L['Left'],
		['RIGHT'] = L['Right'],
		['TOP'] = L['Top'],
		['TOPLEFT'] = L['Top Left'],
		['TOPRIGHT'] = L['Top Right'],
	}
	
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
	
	local locate = {
		['top'] = L['Top'],
		['bottom'] = L['Bottom'],
	}

	-----------------------
	-- Options Order Chart
	-----------------------
	-- ReloadUI = 0
	-- Enable = 1
	-- toggle = 2
	-- select = 3
	-- color = 4
	-- range = 5
	-- group = 6

	options = {
		type = "group",
		name = "nData", -- @PHANX: don't use colors here, it will screw up alphabetizing
		handler = nData,
		--childGroups = "tab", -- @PHANX: this is the default, you don't need to specify it, you can delete this line
		args = {
			welcome = { -- @PHANX: moved all the "welcome" text into a group, you'll see why later
				type = "group",
				order = 1,
				name = "nData",
				args = {
					Text = {
						type = "description",
						order = 1,
						name = L["Welcome to |cffCC3333n|rData Config Area!"],
						width = "full",
						fontSize = "large",
					},
					Text2 = {
						type = "description",
						order = 2,
						name = L[" "],
						width = "full",
					},
					Text3 = {
						type = "description",
						order = 3,
						name = L["Special Thanks for |cffCC3333n|rData goes out to: "],
						width = "full",
						fontSize = "medium",
					},
					Text4 = {
						type = "description",
						order = 4,
						name = L["Phanx, Tuks, Elv, Baine, Treeston, and many more."],
						width = "full",
						fontSize = "large",
					},
				},
			},			
			datapanel = {
				type = "group",
				order = 6,
				name = L["Datapanel"],
				desc = L["datapanel Module for nData."],
				childGroups = "tree",
				get = function(info) return db.datapanel[ info[#info] ] end,
				set = function(info, value) db.datapanel[ info[#info] ] = value;   end,
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
						name = L["Enable"],
						desc = L["Enables datapanel Module."],
					},
					location = {
						type = "select",					
						order = 3,
						name = L["Location"],
						desc = L["Choose the location of the datapanel."],
						disabled = function() return not db.datapanel.enable end,
						values = locate;
					},
					time24 = {
						type = "toggle",
						order = 2,
						name = L["24-Hour Time"],
						desc = L["Display time datapanel on a 24 hour time scale"],
						disabled = function() return not db.datapanel.enable end,
					},
					bag = {
						type = "toggle",
						order = 2,
						name = L["Bag Open"],
						desc = L["Checked opens Backpack only, Unchecked opens all bags."],
						disabled = function() return not db.datapanel.enable end,
					},
					battleground = {
						type = "toggle",
						order = 2,
						name = L["Battleground Text"],
						desc = L["Display special datapanels when inside a battleground"],
						disabled = function() return not db.datapanel.enable end,
					},
					recountraiddps = {
						type = "toggle",
						order = 2,
						name = L["Recount Raid DPS"],
						desc = L["Display Recount's Raid DPS (RECOUNT MUST BE INSTALLED)"],
						disabled = function() return not db.datapanel.enable end,
					},
					fontSize = {
						type = "range",
						order = 5,						
						name = L["Game Font Size"],
						desc = L["Controls the Size of the Game Font"],
						disabled = function() return not db.datapanel.enable end,
						min = 0, max = 30, step = 1,
					},
					classcolor = {
						type = "toggle",					
						order = 2,
						name = L["Class Color"],
						desc = L["Use your classcolor for border and some text color."],
						disabled = function() return not db.datapanel.enable end,
					},					
					DataGroup = {
						type = "group",
						order = 6,
						name = L["Text Positions"],
						guiInline  = true,
						disabled = function() return not db.datapanel.enable end,
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
								disabled = function() return not db.datapanel.enable end,
							},
							calltoarms = {
								type = "select",
								order = 5,
								name = L["Call to Arms"],
								desc = L["Display the active roles that will recieve a reward for completing a random dungeon"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							coords = {
								type = "select",
								order = 5,
								name = L["Coordinates"],
								desc = L["Display Player's Coordinates"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							dps_text = {
								type = "select",
								order = 5,
								name = L["DPS"],
								desc = L["Display amount of DPS"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							dur = {
								type = "select",
								order = 5,
								name = L["Durability"],
								desc = L["Display your current durability"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							friends = {
								type = "select",
								order = 5,
								name = L["Friends"],
								desc = L["Display current online friends"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							guild = {
								type = "select",
								order = 5,
								name = L["Guild"],
								desc = L["Display current online people in guild"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							hps_text = {
								type = "select",
								order = 5,
								name = L["HPS"],
								desc = L["Display amount of HPS"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							pro = {
								type = "select",
								order = 5,
								name = L["Professions"],
								desc = L["Display Professions"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							recount = {
								type = "select",
								order = 5,
								name = L["Recount"],
								desc = L["Display Recount's DPS (RECOUNT MUST BE INSTALLED)"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							spec = {
								type = "select",
								order = 5,
								name = L["Talent Spec"],
								desc = L["Display current spec"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							stat1 = {
								type = "select",
								order = 5,
								name = L["Stat #1"],
								desc = L["Display stat based on your role (Avoidance-Tank, AP-Melee, SP/HP-Caster)"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							stat2 = {
								type = "select",
								order = 5,
								name = L["Stat #2"],
								desc = L["Display stat based on your role (Armor-Tank, Crit-Melee, Crit-Caster)"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
							system = {
								type = "select",
								order = 5,
								name = L["System"],
								desc = L["Display FPS and Latency"],
								values = statposition;
								disabled = function() return not db.datapanel.enable end,
							},
						},
					},
				},
			},
		},
	}

	return options
end


function nData:SetUpOptions()
	local options = GetOptions()

	-- @PHANX: add this to your options table instead of registering it separately:
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("nData", options)

	-- @PHANX: You could write out each subkey but let's be lazy:
	local panels = {}
	for k in pairs(options.args) do -- this assumes all immediate children are groups
		if k ~= "welcome" and k ~= "profile" then -- skip these so we can add them manually as the first and last panels
			tinsert(panels, k)
		end
	end
	sort(panels) -- alphabetize so it looks nice and is easy to navigate

	local Dialog = LibStub("AceConfigDialog-3.0")

	-- Use the "welcome" panel as the main one:
	self.optionsFrame = Dialog:AddToBlizOptions("nData", "nData", nil, "welcome")

	-- Add all the rest as sub-panels:
	for i = 1, #panels do
		local k = panels[i]
		Dialog:AddToBlizOptions("nData", options.args[k].name, "nData", k)
	end

	-- Add the profile panel last:
	Dialog:AddToBlizOptions("nData", options.args.profile.name, "nData", "profile")

end