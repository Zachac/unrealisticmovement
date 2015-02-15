print("Loaded sv_air_strafing.lua")

local AIR_ACCELERATION	= 100
local REQUIRED_DIFFERENCE	= 0
local AIR_ADD = 10

--hook.Remove("Think", "air acceleration")
/*hook.Add("Think", "air acceleration", function()
	for k,v in pairs (player.GetAll()) do
		local projVect 		= Vector(0,0,0)
		local aim 			= Vector(v:GetAimVector().x, v:GetAimVector().y, 0):GetNormal()
		local horSpeedNorm	=  Vector(v:GetVelocity().x, v:GetVelocity().y, 0):GetNormal()
		
		if (v:KeyDown(IN_FORWARD)) then
			projVect = projVect + aim
		end
		
		if (v:KeyDown(IN_BACK)) then
			projVect = projVect + (aim * -1)
		end
		
		if (v:KeyDown(IN_MOVERIGHT)) then
			projVect = projVect + Vector(aim.y, -aim.x, 0)
		end
		
		if (v:KeyDown(IN_MOVELEFT)) then
			projVect = projVect + Vector(-aim.y, aim.x, 0)
		end
		
		local projVectNorm 	= projVect:GetNormal()
		local difference 	= projVectNorm:Angle() - horSpeedNorm:Angle()
		
		if (REQUIRED_DIFFERENCE < math.abs(difference.y)) then
			v:SetVelocity(projVectNorm * AIR_ACCELERATION)
			--v:SetLocalVelocity(((projVectNorm * AIR_ACCELERATION) + (v:GetVelocity())):GetNormal() * v:GetVelocity():Length())
		end
	end
end)*/

--hook.Remove("Move", "air strafing")
hook.Add("Move", "air strafing", function(ply, cmd)
	if (!ply:IsOnGround()) then
		local aim 			= cmd:GetMoveAngles():Forward()
		local forward		= Vector(aim.x, aim.y, 0):GetNormal()
		local right			= Vector(aim.y, -aim.x, 0):GetNormal()
		local vel 			= cmd:GetVelocity()
		local speed			= vel:Length()
		local projVect 		= Vector(0,0,0)
		
		projVect 			= projVect + forward * cmd:GetForwardSpeed()
		projVect 			= projVect + right * cmd:GetSideSpeed() 
		projVect			= projVect:GetNormal()
		
		local difference 	= (aim + projVect):Length()
		
		if (difference > REQUIRED_DIFFERENCE) then
			cmd:SetVelocity((vel + (projVect * AIR_ACCELERATION)):GetNormal() * speed + AIR_ADD)
		end
	end
end)