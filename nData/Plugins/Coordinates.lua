local nData = LibStub("AceAddon-3.0"):GetAddon("nData")

------------------------------------------------------------------------
--	 Coordinates Plugin Functions
------------------------------------------------------------------------
nData.pluginConstructors["coords"] = function()

	db = nData.db.profile

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(db.font, db.fontSize,'THINOUTLINE')
	nData:PlacePlugin(db.coords, Text)

	local function Update(self)
	local px,py=GetPlayerMapPosition("player")
		Text:SetText(format(hexa.."Loc: "..hexb.."%i , %i",px*100,py*100))
	end

	plugin:SetScript("OnUpdate", Update)
	Update(plugin, 10)
	
	return plugin -- important!
end