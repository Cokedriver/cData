----------------------------------------------------------
-- Code Source = TukUI
-- All Credit goes to programmers at www.tukui.org
-- Data order on Bars 
-- Bar Left = 1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9
----------------------------------------------------------
media = {
	['font'] = 'Fonts\\ARIALN.ttf',
}

datatext = {
	['enable'] = true,

	['position'] = 'shortbar',								-- choose either 'top' or 'bottom' or 'shortbar' (for NeavUi Shortbar) for your nData position.
	['border'] = 'DialogBox',								-- choose either 'Tooltip' or 'DialogBox' or 'NeavUI' for your nData Border.
	['fontsize'] = 15,                                  	-- font size for panels.
	['bags'] = 9,                                       	-- show space used in bags on panel.
	['system'] = 0,                                     	-- show total memory and others systems info (FPS/MS) on panel.
	['wowtime'] = 0,                                    	-- show time on panel.
	['guild'] = 0,                                      	-- show number on guildmate connected on panel.
	['dur'] = 8,                                        	-- show your equipment durability on panel.
	['friends'] = 7,                                    	-- show number of friends connected.
	['dps_text'] = 0,                                   	-- show a dps meter on panel.
	['hps_text'] = 0,                                   	-- show a heal meter on panel.
	['currency'] = 0,                                   	-- show your tracked currency on panel.
	['micromenu'] = 0,										-- show the micromenu on panel.
	['spec'] = 5,											-- show your current spec on panel.
	['zone'] = 0,											-- show your current zone on panel.
	['coords'] = 0,											-- show your current coords on panel.
	['pro'] = 4,											-- shows your professions and tradeskills
	['stat1'] = 1,											-- Stat Based on your Role (Avoidance-Tank, AP-Melee, SP/HP-Caster)
	['stat2'] = 3,											-- Stat Based on your Role (Armor-Tank, Crit-Melee, Crit-Caster)
	['recount'] = 2,										-- Stat Based on Recount's DPS
	['recountraiddps'] = false,								-- Enables tracking or Recounts Raid DPS
	['calltoarms'] = 6,										-- Show Current Call to Arms.
	
	-- Color Datatext
	['colors'] = {
		['classcolor'] = true,               			    -- classcolored datatexts
		['color'] = { r = 0, g = 0, b = 1},                  				-- datatext color if classcolor = false 
	},
	
	['battleground'] = true,                            	-- enable 3 stats in battleground only that replace stat1,stat2,stat3.

	['bag'] = false,										-- True = Open Backpack; False = Open All bags

	-- Clock Settings
	['time24'] = false,                                  	-- set time to 24h format.
	['localtime'] = true,                              		-- set time to local time instead of server time.	
		
	-- FPS Settings
	['fps'] = {
		['enable'] = true,									-- enable the FPS on the System Tooltip
		-- ONLY ONE OF THESE CAN BE TRUE	
		['home'] = false,									-- Only Show Home Latency
		['world'] = false,									-- Only Show World Latency
		['both'] = true,									-- Show both Home and World Latency
	},
		
	['threatbar'] = true,									-- Enable the threatbar over the Center Panel.

		
}

