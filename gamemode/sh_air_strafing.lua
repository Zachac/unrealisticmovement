print("Loaded sh_air_strafing.lua")

-- defualt: 30, 10
local AIR_SPEEDCAP	= 100
local AIR_ACCEL		= 100

--hook.Remove("SetupMove", "air strafing")
hook.Add("SetupMove", "air strafing", function(ply, cmd, cud)
	if (ply:Alive() && ply:GetNetworkedInt("lobbyMoveType") == 2 || ply:GetNetworkedInt("lobbyMoveType") == 3) then
		local aim 			= cmd:GetMoveAngles():Forward()
		local wishDir 		= Vector(0,0,0)
		local wishSpeed		= 0
		local addSpeed		= 0
		local currentSpeed	= 0
		
		wishDir 			= wishDir + Vector(aim.x, aim.y, 0):GetNormal() * cmd:GetForwardSpeed()
		wishDir 			= wishDir + Vector(aim.y, -aim.x, 0):GetNormal() * cmd:GetSideSpeed() 
		
		wishSpeed			= wishDir:Length()
		wishDir				= wishDir:GetNormal()
		
		if (wishSpeed > AIR_SPEEDCAP) then
			wishSpeed = AIR_SPEEDCAP
		end
		
		currentSpeed = cmd:GetVelocity():Dot(wishDir)
		
		addSpeed = wishSpeed - currentSpeed
		
		if (addSpeed > 0) then
			local accelSpeed = AIR_ACCEL * wishSpeed
			
			if (accelSpeed > addSpeed) then
				accelSpeed = addSpeed
			end
			
			cmd:SetVelocity(cmd:GetVelocity() + (accelSpeed * wishDir))
		end
	end
end)
