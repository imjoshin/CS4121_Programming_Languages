-- Test menu, not vital to addon

function WeaponSelectorDerma()
	-- Initial settings
	local WeaponFrame = vgui.Create("DFrame")
	WeaponFrame:SetSize(650, 80)
	WeaponFrame:Center()
	WeaponFrame:SetTitle("Take the weapon that you want")
	WeaponFrame:SetDraggable(true)
	WeaponFrame:SetSizable(false)
	WeaponFrame:ShowCloseButton(true)
	WeaponFrame:MakePopup()

	local PistolButton = vgui.Create("DButton", WeaponFrame)
	PistolButton:SetSize(100, 30)
	PistolButton:SetPos(50, 35)
	PistolButton:SetText("Spawn")
	local weaponData = {}

	PistolButton.DoClick = function() spawnWeapon(weaponData) WeaponFrame:Close() end --make it run our "weapon_take" console command with "pistol" as the 1st argument and then close the menu

	local SMGButton = vgui.Create("DButton", WeaponFrame)
	SMGButton:SetSize(100, 30)
	SMGButton:SetPos(200, 35)
	SMGButton:SetText("crossbow")
	SMGButton.DoClick = function() RunConsoleCommand("doStuff", "weapon_crossbow") WeaponFrame:Close() end

	local SMGButton = vgui.Create("DButton", WeaponFrame)
	SMGButton:SetSize(100, 30)
	SMGButton:SetPos(350, 35)
	SMGButton:SetText("Change Model")
	SMGButton.DoClick = function() RunConsoleCommand("custom-setViewModel", "weapons/models/v_pistol.mdl") WeaponFrame:Close() end

	local SMGButton = vgui.Create("DButton", WeaponFrame)
	SMGButton:SetSize(100, 30)
	SMGButton:SetPos(500, 35)
	SMGButton:SetText("Shots")
	SMGButton.DoClick = function() RunConsoleCommand("custom-setPrimaryShotsperRound", 5) WeaponFrame:Close() end
end

concommand.Add("selectweapon", WeaponSelectorDerma)
