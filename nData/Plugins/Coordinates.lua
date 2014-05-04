local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
-- Constants (variables whose values are never altered):
------------------------------------------------------------------------
local _, class = UnitClass("player")
local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]

------------------------------------------------------------------------
--	 Coordinates Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["coords"] = function()

	db = nData.db.profile

	if db.classcolor ~= true then
		local r, g, b = db.customcolor.r, db.customcolor.g, db.customcolor.b
		hexa = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
		hexb = "|r"
	else
		hexa = ("|cff%.2x%.2x%.2x"):format(classColor.r * 255, classColor.g * 255, classColor.b * 255)
		hexb = "|r"
	end	

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.fontNormal, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.coords, Text)

	local function Update(self)
	local px,py=GetPlayerMapPosition("player")
		Text:SetText(format(hexa.."Loc: "..hexb.."%i , %i",px*100,py*100))
	end

	plugin:SetScript("OnUpdate", Update)
	Update(plugin, 10)
	
	return plugin -- important!
end