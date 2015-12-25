-- File to initialize the server

AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "LastUsed")
end

function ENT:SpawnFunction(ply, tr) -- Spawn function needed to make it appear on the spawn menu
	if (!tr.HitWorld) then return end

	local ent = ents.Create("gun_printer") -- Create the entity
	ent:SetPos(tr.HitPos + Vector(0, 0, 50)) -- Set it to spawn 50 units over the spot you aim at when spawning it
	ent:Spawn() -- Spawn it

	return ent -- You need to return the entity to make it work
end

function ENT:Initialize()

	self:SetModel( "models/props_office/computer_monitor_01.mdl" ) -- Entity model
	self:PhysicsInit( SOLID_VPHYSICS ) -- Physics for entity
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetLastUsed(os.time()) -- Limit number of menus to show up

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

-- When "E" press on entity
function ENT:Use( activator, caller )
	if ( !activator:IsPlayer() ) then return end

    local phys = self:GetPhysicsObject()

	-- open menu if valid
    if(phys:IsValid() && (os.time() - self:GetLastUsed()) > 0) then
		self:SetLastUsed(os.time())
		RunConsoleCommand("weaponMenu")
    end

    return
end

function ENT:Think()
    local phys = self:GetPhysicsObject()
end
