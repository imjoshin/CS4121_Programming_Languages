-- File to create user menu

function openMenu()
	-- Menu size, with respect to window
	local WIDTH = .5
	local HEIGHT = .5

	RunConsoleCommand("setVars", "scope", -1)

	-- initial settings
	local menuFrame = vgui.Create("DFrame")
	menuFrame:SetSize(ScrW() * WIDTH, ScrH() * HEIGHT)
	menuFrame:Center()
	menuFrame:SetTitle("Select Your Weapons Settings")
	menuFrame:SetDraggable(false)
	menuFrame:SetSizable(false)
	menuFrame:ShowCloseButton(true)
	menuFrame:MakePopup()

	-- layout setup
	local topPanel = vgui.Create("DPanel", menuFrame)
	topPanel:SetPos(0, 25)
	topPanel:SetSize(ScrW() * WIDTH, ScrH() * HEIGHT * .25)

	local botLeftPanel = vgui.Create("DPanel", menuFrame)
	botLeftPanel:SetPos(0, 30 + (ScrH() * HEIGHT * .25))
	botLeftPanel:SetSize((ScrW() * WIDTH * .5) - 2, ((ScrH() * HEIGHT) * .75) - 30)

	local botRightPanel = vgui.Create("DPanel", menuFrame)
	botRightPanel:SetPos((ScrW() * WIDTH * .5) + 3, 30 + (ScrH() * HEIGHT * .25))
	botRightPanel:SetSize((ScrW() * WIDTH * .5) - 3, ((ScrH() * HEIGHT) * .75) - 30)

	local topProperties = vgui.Create("DProperties", topPanel)
	topProperties:Dock(FILL)
	local botLeftProperties = vgui.Create("DProperties", botLeftPanel)
	botLeftProperties:Dock(FILL)
	local botRightProperties = vgui.Create("DProperties", botRightPanel)
	botRightProperties:Dock(FILL)

	-- Model cannot be set dynamically
	--[[
	--World Model------------------------------------------------
	local weaponModel = topProperties:CreateRow("Weapon", "World Model")
	weaponModel:Setup("Combo", {text = "Select Weapon Model..."})
	local options = weapons.GetList()
	for key,value in pairs(options) do
		if value["WorldModel"] != "" then
			weaponModel:AddChoice(value["WorldModel"], {value["WorldModel"]})
		end
	end
	weaponModel.DataChanged = function(self, data)
		optionSelected("worldModel", data[1])
	end
	-------------------------------------------------------------

	--View Model-------------------------------------------------
	local weaponModel = topProperties:CreateRow("Weapon", "View Model")
	weaponModel:Setup("Combo", {text = "Select Weapon Model..."})
	local options = weapons.GetList()
	for key,value in pairs(options) do
		weaponModel:AddChoice(value["ViewModel"], {value["ViewModel"]})
	end
	weaponModel.DataChanged = function(self, data)
		optionSelected("viewModel", data[1])
	end
	-------------------------------------------------------------
	]]

	--Scopes-----------------------------------------------------
	local weaponModel = topProperties:CreateRow("Weapon", "Scope")
	weaponModel:Setup("Combo", {text = "Select Scope..."})
	local options = {-1, 5, 10, 25, 50, 60}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		-- Hide secondary menu if scope is selected
		if math.floor(data[1]) != -1.00 then
			print("resize")
			botRightPanel:SetSize(0, 0)
			botLeftPanel:SetSize(ScrW() * WIDTH, ((ScrH() * HEIGHT) * .75) - 30)
		else
			botLeftPanel:SetSize((ScrW() * WIDTH * .5) - 2, ((ScrH() * HEIGHT) * .75) - 30)
			botRightPanel:SetSize((ScrW() * WIDTH * .5) - 3, ((ScrH() * HEIGHT) * .75) - 30)
		end
		RunConsoleCommand("setVars", "scope", data[1])
	end
	-------------------------------------------------------------

	--END OF TOP PANEL===========================================

	--[[
	--Primary Auto-----------------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Automatic")
	weaponModel:Setup("Combo", {text = "Select Automatic..."})
	weaponModel:AddChoice("Yes", {true})
	weaponModel:AddChoice("No", {false})
	weaponModel.DataChanged = function(self, data)
		optionSelected("pAuto", data[1])
	end
	-------------------------------------------------------------
	]]
	-- model browser for projectiles
	function openModelBrowser(t)
		local frame = vgui.Create( "DFrame" )
		frame:SetSize( 500, 250 )
		frame:SetSizable( true )
		frame:Center()
		frame:MakePopup()
		frame:SetTitle( "Select a model file" )

		local browser = vgui.Create( "DFileBrowser", frame )
		browser:Dock( FILL )

		browser:SetPath( "GAME" )
		browser:SetBaseFolder( "models" ) -- root folder
		browser:SetFileTypes( "*.mdl" )
		browser:SetOpen( true ) -- show sub folders?
		browser:SetCurrentFolder( "persist" )

		function browser:OnSelect( path, pnl ) -- Called when a file is clicked
			RunConsoleCommand("setVars", t .. "Shot", path)
			return path
		end
	end

	--Primary projectile entity----------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Projectile Model")
	weaponModel:Setup("Combo", {text = "Select Model..."})
	local options = {"Baby Doll", "Chair", "Skull", "Sink", "Select Your Own"}
	local models = {}
	models["Baby Doll"] = "models/props_c17/doll01.mdl"
	models["Chair"] = "models/props_wasteland/controlroom_chair001a.mdl"
	models["Skull"] = "models/Gibs/HGIBS.mdl"
	models["Sink"] = "models/props_interiors/SinkKitchen01a.mdl"
	-- add models to menu
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		if data[1] == "Select Your Own" then
			openModelBrowser("p")
		else
			RunConsoleCommand("setVars", "pShot", models[data[1]])
		end
	end
	-------------------------------------------------------------

	--Primary Fire Rate------------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Fire Rate")
	weaponModel:Setup("Combo", {text = "Select Fire Rate..."})
	local options = {.1, .2, .5, 1}
	-- add options to menu
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "pFireRate", data[1])
	end
	-------------------------------------------------------------

	--Primary Speed----------------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Projectile Speed")
	weaponModel:Setup("Combo", {text = "Select Projectile Speed..."})
	local options = {1, 20, 50, 100, 250, 500, 2000}
	-- add options to menu
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "pSpeed", data[1])
	end
	-------------------------------------------------------------
	function openSoundBrowser(t)
		RunConsoleCommand("StopSound")
		local frame = vgui.Create( "DFrame" )
		frame:SetSize( 500, 250 )
		frame:SetSizable( true )
		frame:Center()
		frame:MakePopup()
		frame:SetTitle( "Select a sound file" )

		local browser = vgui.Create( "DFileBrowser", frame )
		browser:Dock( FILL )

		browser:SetPath( "GAME" )
		browser:SetBaseFolder( "sound" ) -- root folder
		browser:SetOpen( true ) -- show sub-folders?
		browser:SetCurrentFolder( "persist" )

		function browser:OnSelect( path, pnl ) -- Called when a file is clicked
			print("path in openSoundBrowser")
			print(path)
			RunConsoleCommand("setVars", t .. "Sound", string.sub(path, 6))
			surface.PlaySound(string.sub(path, 6))
			return path
		end
	end

	--Primary Sound----------------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Sound")

	weaponModel:Setup("Combo", {text = "Select Sound..."})
	local options = weapons.GetList() --TODO: ad table of all sounds
	weaponModel:AddChoice("Select your own", {"filebrowserSound"} )
	-- add options to menu
	for key,value in pairs(options) do
		weaponModel:AddChoice(value["ViewModel"], {value["ViewModel"]})
	end
	weaponModel.DataChanged = function(self, data)
		openSoundBrowser("p")
	end
	-------------------------------------------------------------

	--Primary Damage---------------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Projectile Damage")
	weaponModel:Setup("Combo", {text = "Select Projectile Damage..."})
	local options = {1, 5, 10, 20, 50, 100}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "pDamage", data[1])
	end
	-------------------------------------------------------------

	--Primary Spread---------------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Projectile Spread")
	weaponModel:Setup("Combo", {text = "Select Projectile Spread..."})
	local options = {0, 1, 2, 3, 50}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "pSpread", data[1])
	end
	-------------------------------------------------------------

	--Projectiles per Round--------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Projectiles per Round")
	weaponModel:Setup("Combo", {text = "Select Projectiles per Round..."})
	local options = {1, 2, 3, 5, 10}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "pShotsPerRound", data[1])
	end
	-------------------------------------------------------------

	--[[
	--Clip Size--------------------------------------------------
	local weaponModel = botLeftProperties:CreateRow("Primary Weapon", "Clip Size")
	weaponModel:Setup("Combo", {text = "Select Clip Size..."})
	local options = {1, 2, 3}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		optionSelected("clip", data[1])
	end
	--]]
	-------------------------------------------------------------

	--END OF BOTTOM LEFT PANEL===================================

	--[[
	--Secondary Auto-----------------------------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Automatic")
	weaponModel:Setup("Combo", {text = "Select Automatic..."})
	weaponModel:AddChoice("Yes", {true})
	weaponModel:AddChoice("No", {false})
	weaponModel.DataChanged = function(self, data)
		optionSelected("sAuto", data[1])
	end
	-------------------------------------------------------------
	]]

	--Secondary projectile entity----------------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Projectile Model")
	weaponModel:Setup("Combo", {text = "Select Model..."})
	local options = {"Baby Doll", "Chair", "Skull", "Sink"}
	local models = {}
	models["Baby Doll"] = "models/props_c17/doll01.mdl"
	models["Chair"] = "models/props_wasteland/controlroom_chair001a.mdl"
	models["Skull"] = "models/Gibs/HGIBS.mdl"
	models["Sink"] = "models/props_interiors/SinkKitchen01a.mdl"
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "sShot", models[data[1]])
	end
	-------------------------------------------------------------

	--Secondary Fire Rate----------------------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Fire Rate")
	weaponModel:Setup("Combo", {text = "Select Fire Rate..."})
	local options = {.1, .2, .5, 1}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "sFireRate", data[1])
	end
	-------------------------------------------------------------

	--Secondary Speed--------------------------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Projectile Speed")
	weaponModel:Setup("Combo", {text = "Select Projectile Speed..."})
	local options = {1, 20, 50, 100, 250, 500, 2000}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "sSpeed", data[1])
	end
	-------------------------------------------------------------

	--Secondary Sound--------------------------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Sound")
	weaponModel:Setup("Combo", {text = "Select Sound..."})
	local options = weapons.GetList() --TODO: ad table of all sounds
	for key,value in pairs(options) do
		weaponModel:AddChoice(value["ViewModel"], {value["ViewModel"]})
	end
	weaponModel.DataChanged = function(self, data)
		openSoundBrowser("s")
	end
	-------------------------------------------------------------

	--Secondary Damage-------------------------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Projectile Damage")
	weaponModel:Setup("Combo", {text = "Select Projectile Damage..."})
	local options = {1, 5, 10, 20, 50, 100}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "sDamage", data[1])
	end
	-------------------------------------------------------------

	--Secondary Spread-------------------------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Projectile Spread")
	weaponModel:Setup("Combo", {text = "Select Projectile Spread..."})
	local options = {1, 2, 3}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "sSpread", data[1])
	end
	-------------------------------------------------------------

	--Secondary Projectiles per Round----------------------------
	local weaponModel = botRightProperties:CreateRow("Secondary Weapon", "Projectiles per Round")
	weaponModel:Setup("Combo", {text = "Select Projectiles per Round..."})
	local options = {1, 2, 3, 5, 10}
	for i, v in pairs(options) do
		weaponModel:AddChoice(options[i], {options[i]})
	end
	weaponModel.DataChanged = function(self, data)
		RunConsoleCommand("setVars", "sShotsPerRound", data[1])
	end
	-------------------------------------------------------------


	end
concommand.Add("weaponMenu", openMenu)
