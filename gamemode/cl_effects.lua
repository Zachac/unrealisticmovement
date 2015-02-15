print("Loaded cl_effects.lua")

local multView			= 22.5					-- how far to check for a wall 
local lastSoundTime		= CurTime()
local soundCD			= function() return (200/LocalPlayer():GetVelocity():Length()) end -- how quickly should we move to the next sound?
local wrSound			= function() return ("physics/plaster/drywall_footstep" .. math.random(4) .. ".wav") end
local wrSoundLevel		= 100
local wrPitch			= 100
local hoverSoundName 	= Sound("npc/manhack/mh_engine_loop1.wav")
local lastPogo			= false
local pogoSound			= function() return ("physics/cardboard/cardboard_cup_impact_hard" .. math.random(2,3) .. ".wav") end
hoverSound				= NULL

local nc			= {} 					-- returned for the calc view for third person
	  nc.origin		= Vector(0,0,0)
	  nc.fov		= 180
	  nc.angles		= Angle(0,0,0)
	  
	  
-- play the wall run sound
hook.Add("Think", "effects", function()
	ply = LocalPlayer()
	
	if (hoverSound == NULL) then -- initialize
		hoverSound 	= CreateSound(LocalPlayer(), hoverSoundName)
	end
	
	-- wall running
	if (ply:KeyDown(IN_USE) && ply:GetNetworkedInt("lobbyMoveType") == 0) then
		local view 				= ply:GetAimVector()
		local right				= Vector(view.y, -view.x, 0):GetNormal()
		local left				= -right
		local forward 			= Vector(view.x, view.y, 0):GetNormal()
		local backward			= -forward
		
		local traceResRight 	= util.QuickTrace(ply:GetLocalPos(), right * multView, {ply})
		local traceResLeft 		= util.QuickTrace(ply:GetLocalPos(), left * multView, {ply})
		local traceResForward 	= util.QuickTrace(ply:GetLocalPos(), forward * multView, {ply})
		local traceResBackward 	= util.QuickTrace(ply:GetLocalPos(), backward * multView, {ply})
		
		local shouldUseSound 	= false
		
		if (traceResRight.HitWorld || traceResLeft.HitWorld || traceResForward.HitWorld || traceResBackward.HitWorld) then
			shouldUseSound = true
		end 

		if (shouldUseSound) then
			if (CurTime() - lastSoundTime > soundCD()) then
				ply:EmitSound(wrSound(), wrSoundLevel, wrPitch)
				lastSoundTime	= CurTime()
			end
		end
	elseif (ply:GetNetworkedInt("lobbyMoveType") == 4) then
		local checkGround = util.QuickTrace(ply:GetLocalPos(), Vector(0,0,-1) * 100, {ply})
		
		if (!checkGround.HitWorld && lastPogo) then
			ply:EmitSound(pogoSound(), 0, 90)
		end
		
		lastPogo = checkGround.HitWorld
	end
	
	local floatDist = 100
	
	if (ply:KeyDown(IN_JUMP) || ply:KeyDown(IN_DUCK)) then
		floatDist = floatDist/10
	end
	
	local checkGround = util.QuickTrace(ply:GetLocalPos(), Vector(0,0,-1) * floatDist, {ply})
	
	if (checkGround.HitWorld && ply:GetNetworkedInt("lobbyMoveType") == 2  && !ply:KeyDown(IN_DUCK)) then
		if (!hoverSound:IsPlaying()) then
			hoverSound:Play() -- starts the sound
			hoverSound:ChangeVolume(.3, 0)
			hoverSound:ChangePitch(60, 0)
		end
	else
		if (hoverSound:IsPlaying()) then
			hoverSound:Stop() -- stops the sound
		end
	end
	
	if (hoverSound:IsPlaying()) then
		hoverSound:ChangePitch(ply:GetVelocity():Length()/100 * 4, 0)
	end
end)



-- draw the spiderman web
hook.Add("HUDPaint", "effects hud", function()
	if (LocalPlayer():GetObserverTarget() != nil) then
		ply = LocalPlayer():GetObserverTarget()
	else
		ply = LocalPlayer()
	end
	
	-- shot web
	if (ply:GetNetworkedVector("webPos") != Vector(0,0,0)) then
		screenWebPos		= ply:GetNetworkedVector("webPos"):ToScreen()
		if (shouldThird) then
			start  			= (ply:GetShootPos() + Vector(0,0,-20)):ToScreen()
		else
			start			= Vector(ScrW()/2, ScrH(), 0)
		end		  
		
		surface.SetDrawColor(255,255,255,255)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x - 1, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x + 1, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x - 2, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x + 2, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x - 3, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x + 3, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x - 4, start.y)
		surface.DrawLine(screenWebPos.x, screenWebPos.y, start.x + 4, start.y)
		
		--chat.AddText(Color(255,20,20), "Console: ", Color(255,255,255), "hello")
	end
end)

-- third person
hook.Add( "CalcView", "third person", function(ply, pos, angles, fov)
	if (shouldThird) then
		traceRes = util.QuickTrace(pos, angles:Forward() * -200, {player})
		
		local info 	= {}
		info.origin = traceRes.HitPos + (angles:Forward() * 30)
		info.angles = angles
		info.fov 	= fov
 		return info
	end
end)

hook.Add( "ShouldDrawLocalPlayer", "third person", function( ply )
    return shouldThird
end)
