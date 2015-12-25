-- testing purposes
function GivePlayerAWeapon( ply, cmd, args )
	if args[1] == "jump" then
		ply:SetJumpPower(1500)
	elseif args[1] == "reset" then
		ply:SetJumpPower(200)
	else
		ply:Give(args[1])
		ply:SelectWeapon(args[1])
		ply:ChatPrint("You got a " .. args[1])
	end
end --close our function

function newWeapon( ply, cmd, args )
	weapon = SWEP:new()
end

concommand.Add("doStuff", GivePlayerAWeapon)
concommand.Add("newWeapon", newWeapon)
