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

	['top'] = true,										-- if = true then panel on top of screen, if = false panel below mainmenubar
	
	['fontsize'] = 15,                                  	-- font size for panels.
	['bags'] = 0,                                       	-- show space used in bags on panel.
	['system'] = 0,                                     	-- show total memory and others systems info (FPS/MS) on panel.
	['gold'] = 9,                                       	-- show your current gold on panel.
	['wowtime'] = 0,                                    	-- show time on panel.
	['guild'] = 0,                                      	-- show number on guildmate connected on panel.
	['dur'] = 8,                                        	-- show your equipment durability on panel.
	['friends'] = 7,                                    	-- show number of friends connected.
	['dps_text'] = 2,                                   	-- show a dps meter on panel.
	['hps_text'] = 0,                                   	-- show a heal meter on panel.
	['currency'] = 0,                                   	-- show your tracked currency on panel.
	['micromenu'] = 0,										-- show the micromenu on panel.
	['spec'] = 5,											-- show your current spec on panel.
	['zone'] = 0,											-- show your current zone on panel.
	['coords'] = 0,											-- show your current coords on panel.
	['pro'] = 4,											-- shows your professions and tradeskills
	['stat1'] = 1,											-- Stat Based on your Role (Avoidance-Tank, AP-Melee, SP/HP-Caster)
	['stat2'] = 3,											-- Stat Based on your Role (Armor-Tank, Crit-Melee, Crit-Caster)
	['recount'] = 0,										-- Stat Based on Recount's DPS
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

--local text (source Tukui)

L = {
	datatext_download = 'Download: ',
	datatext_bandwidth = 'Bandwidth: ',
	datatext_guild = 'Guild',
	datatext_noguild = 'No Guild',
	datatext_bags = 'Bags: ',
	datatext_friends = 'Friends',
	datatext_online = 'Online: ',
	datatext_armor = 'Armor: ',
	datatext_earned = 'Earned:',
	datatext_spent = 'Spent:',
	datatext_deficit = 'Deficit:',
	datatext_profit = 'Profit:',
	datatext_timeto = 'Time to',
	datatext_friendlist = 'Friends list:',
	datatext_playersp = 'SP: ',
	datatext_playerap = 'AP: ',
	datatext_playerhaste = 'Haste',
	datatext_dps = 'DPS: ',
	datatext_hps = 'HPS: ',
	datatext_playerarp = 'ArP',
	datatext_session = 'Session: ',
	datatext_character = 'Character: ',
	datatext_server = 'Server: ',
	datatext_totalgold = 'Total: ',
	datatext_savedraid = 'Saved Raid(s)',
	datatext_currency = 'Currency:',
	datatext_fps = 'FPS: ',
	datatext_ms = ' MS: ',
	datatext_playercrit = 'Crit: ',
	datatext_playerheal = 'Heal: ',
	datatext_avoidancebreakdown = 'Avoidance Breakdown',
	datatext_lvl = 'lvl',
	datatext_boss = 'Boss',
	datatext_miss = 'Miss',
	datatext_dodge = 'Dodge',
	datatext_block = 'Block',
	datatext_parry = 'Parry',
	datatext_playeravd = 'AVD: ',
	datatext_servertime = 'Server Time: ',
	datatext_localtime = 'Local Time: ',
	datatext_mitigation = 'Mitigation By Level: ',
	datatext_healing = 'Healing : ',
	datatext_damage = 'Damage : ',
	datatext_honor = 'Honor : ',
	datatext_killingblows = 'Killing Blows : ',
	datatext_ttstatsfor = 'Stats for ',
	datatext_ttkillingblows = 'Killing Blows:',
	datatext_tthonorkills = 'Honorable Kills:',
	datatext_ttdeaths = 'Deaths:',
	datatext_tthonorgain = 'Honor Gained:',
	datatext_ttdmgdone = 'Damage Done:',
	datatext_tthealdone = 'Healing Done:',
	datatext_basesassaulted = 'Bases Assaulted:',
	datatext_basesdefended = 'Bases Defended:',
	datatext_towersassaulted = 'Towers Assaulted:',
	datatext_towersdefended = 'Towers Defended:',
	datatext_flagscaptured = 'Flags Captured:',
	datatext_flagsreturned = 'Flags Returned:',
	datatext_graveyardsassaulted = 'Graveyards Assaulted:',
	datatext_graveyardsdefended = 'Graveyards Defended:',
	datatext_demolishersdestroyed = 'Demolishers Destroyed:',
	datatext_gatesdestroyed = 'Gates Destroyed:',
	datatext_totalmemusage = 'Total Memory Usage:',
	datatext_control = 'Controlled by:',
	datatext_homelatency = 'Home Latency: ',
	datatext_worldlatency = 'World Latency: ',
	datatext_cta_allunavailable = 'Could not get Call To Arms information.',
	datatext_cta_nodungeons = 'No dungeons are currently offering a Call To Arms.',
	
	goldabbrev = '|cffffd700g|r',
	silverabbrev = '|cffc7c7cfs|r',
	copperabbrev = '|cffeda55fc|r',
	
	unitframes_ouf_threattext = 'Threat on current target:',

	
	Slots = {
		[1] = {1, 'Head', 1000},
		[2] = {3, 'Shoulder', 1000},
		[3] = {5, 'Chest', 1000},
		[4] = {6, 'Waist', 1000},
		[5] = {9, 'Wrist', 1000},
		[6] = {10, 'Hands', 1000},
		[7] = {7, 'Legs', 1000},
		[8] = {8, 'Feet', 1000},
		[9] = {16, 'Main Hand', 1000},
		[10] = {17, 'Off Hand', 1000},
		[11] = {18, 'Ranged', 1000}
	},


}

