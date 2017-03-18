local cData = LibStub("AceAddon-3.0"):GetAddon("cData")

------------------------------------------------------------------------
--	 Coordinates Plugin Functions
------------------------------------------------------------------------
cData.pluginConstructors["coords"] = function()

	db = cData.db.profile

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	cData:PlacePlugin(db.coords, Text)

	local function Update(self)
	local px, py = GetPlayerMapPosition("player")	
 			Text:SetText(format(hexa.."Loc: "..hexb..': %.0f x %.0f', px * 100, py * 100))
	end

	plugin:SetScript("OnUpdate", Update)
	Update(plugin, 10)
	
	return plugin -- important!
end