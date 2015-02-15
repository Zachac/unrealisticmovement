print("Loaded sv_movement.lua")

local multView 		= 23			-- how far should we check for wall climbing?
local pMultView 	= 30			-- how far should we check for parkour?
local wallRunSlower	= 5				-- how much should we slow the player each time?
local webRange		= 10000			-- how far can they shot web?
local webSpeedAdd	= 0				-- how much speed is added every time?
local webBoost		= 600			-- how much defualt speed is added?
local webBoostCD	= 1				-- cooldown for the web boost. parkour CD is 1/4 of this
local wjSound		= function() return ("npc/footsteps/hardboot_generic" .. math.random(6) .. ".wav") end -- what sound should we use for the wall jump?
local wjSoundLevel	= 100			-- how far should wall jump sounds travel?
local wjPitch		= 100			-- defualt pitch for wall jumps?
local floatDist 	= 100			-- how high shall we float?
local floatSpeedAdd	= 40			-- how high much speed should we add each time?
local floatUpAdd	= 1000			-- how high much speed should go upwards with?



hook.Add("KeyPress", "Spiderman Movement key press", function(ply, key)
	if (ply:Team() != 5) then
		if (ply.lobbyMoveType == 0) then -- they are in spiderman mode and not handicapped
			if (key == IN_ATTACK && ply:Alive()) then -- are they alive and are they trying to shoot web?
				local traceRes 	= util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * webRange, {ply}) -- check where the web would go
				
				if (traceRes.HitWorld && !traceRes.HitSky) then -- did they actually shoot to a valid position?
					ply.radius	= (traceRes.HitPos - ply:GetPos()):Length() -- set radius
					ply.webPos 	= traceRes.HitPos -- set where the radius starts
					ply:SetNetworkedVector("webPos", ply.webPos) -- let the client know this info
					ply:EmitSound("weapons/crossbow/fire1.wav", 38, 200) -- play a sound to let them know it worked
				else
					ply:EmitSound("weapons/shotgun/shotgun_empty.wav", 38, 100) -- play a sound to let them know it failed
				end
			elseif (key == IN_ATTACK2 && ply:Alive() && CurTime() - ply.lastWtime > webBoostCD) then -- should they boost?
				if (ply.webPos != Vector(0,0,0)) then -- do they have a valid web position?
					speed = ply:GetVelocity():Length() 
					if (speed < 1000) then -- determine how much speed to add
						ply:SetVelocity((ply.webPos - ply:GetLocalPos()):GetNormal() * webBoost)
					elseif (speed < 2000) then
						ply:SetVelocity((ply.webPos - ply:GetLocalPos()):GetNormal() * (webBoost - 200))
					elseif (speed < 3000) then
						ply:SetVelocity((ply.webPos - ply:GetLocalPos()):GetNormal() * (webBoost - 400))
					else
						ply:SetVelocity((ply.webPos - ply:GetLocalPos()):GetNormal() * (webBoost - 500))
					end
					
					ply:EmitSound("physics/cardboard/cardboard_box_impact_hard2.wav", 100, 200) -- emit a sound to let them know it worked
					ply.radius	= 0 -- reset values
					ply.webPos	= Vector(0,0,0)
					ply:SetNetworkedVector("webPos", ply.webPos)
					ply.lastWtime = CurTime()
				end
			elseif (key == IN_JUMP && CurTime() - ply.lastWtime > webBoostCD/4) then -- wall jump only for when they use space
				local view 				= ply:GetAimVector()
				local right				= Vector(view.y, -view.x, 0):GetNormal()
				local left				= -right
				local forward 			= Vector(view.x, view.y, 0):GetNormal()
				local backward			= -forward
				
				local traceResRight 	= util.QuickTrace(ply:GetLocalPos(), right * pMultView, {ply})
				local traceResLeft 		= util.QuickTrace(ply:GetLocalPos(), left * pMultView, {ply})
				local traceResForward 	= util.QuickTrace(ply:GetLocalPos(), forward * pMultView, {ply})
				local traceResBackward 	= util.QuickTrace(ply:GetLocalPos(), backward * pMultView, {ply})
				
					
				
				
				if (traceResRight.HitWorld && ply:KeyDown(IN_MOVELEFT)) then
					ply:SetVelocity(left * 200 + Vector(0,0,200))
					ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
					ply.lastWtime = CurTime()
				elseif (traceResLeft.HitWorld && ply:KeyDown(IN_MOVERIGHT)) then
					ply:SetVelocity(right * 200 + Vector(0,0,200))
					ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
					ply.lastWtime = CurTime()
				elseif (traceResForward.HitWorld && ply:KeyDown(IN_BACK)) then
					ply:SetVelocity(backward * 200 + Vector(0,0,200))
					ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
					ply.lastWtime = CurTime()
				elseif (traceResBackward.HitWorld && ply:KeyDown(IN_FORWARD)) then
					ply:SetVelocity(forward * 400 + Vector(0,0,400))
					ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
					ply.lastWtime = CurTime()
				end
			end
		elseif (ply.lobbyMoveType == 2 && CurTime() - ply.lastWtime > .1) then
			local checkGround = util.QuickTrace(ply:GetLocalPos(), Vector(0,0,-1) * floatDist, {ply})
			if (checkGround.HitWorld && key == IN_JUMP) then
				ply:SetVelocity(Vector(0,0,300))
				ply:EmitSound("npc/manhack/bat_away.wav", 40, 100)
				ply.lastWtime = CurTime()
			end		
		end
	end
end)


hook.Add("Think", "spiderman movement think", function()
	for k,v in pairs (player.GetAll()) do
		
		-- running accelerate
		local speed		= v:GetVelocity():Length()
	
		if (v:KeyDown(IN_SPEED)) then
			if (speed < 744 && v:IsOnGround()) then
				v:SetRunSpeed(speed + 1)
			end
		else
			v:SetRunSpeed(v:GetWalkSpeed()) -- reset run speed
		end
		
		
		if (v:Team() != 5 && v:Alive()) then -- non handicapped moves only
			if (v.lobbyMoveType == 0) then -- spiderman 
				-- web update
				if (v.webPos != Vector(0,0,0)) then
					if (v:KeyDown(IN_ATTACK) && v:Alive()) then
						local pos 		= v:GetPos()
						local velocity 	= v:GetVelocity()
						local speed 	= velocity:Length()
						local predict	= pos + velocity -- where will they be?
						local plyDist	= (predict - v.webPos):Length() -- will projected radius
						
						if (plyDist > v.radius) then -- will they be outside the radius?
							
							circlePos		= (((predict - v.webPos):GetNormal() * v.radius) + v.webPos)
							newVelocity		= (circlePos - pos):GetNormal()
							v:SetLocalVelocity(newVelocity * (speed + webSpeedAdd))
						end
					else -- they aren't holding in +attack or they are dead
						v.radius	= 0 -- reset there values
						v.webPos	= Vector(0,0,0)
						v:SetNetworkedVector("webPos", v.webPos)
					end
				end
				
				-- wall running
				if (v:KeyDown(IN_USE)) then
					local pos				= v:GetPos()
					local velocity			= v:GetVelocity():GetNormal()
					local speed				= v:GetVelocity():Length()
					local view 				= v:GetAimVector()
					local right				= Vector(view.y, -view.x, 0):GetNormal()
					local left				= -right
					local forward 			= Vector(view.x, view.y, 0):GetNormal()
					local backward			= -forward
					
					local traceResRight 	= util.QuickTrace(v:GetLocalPos(), right * multView, {v})
					local traceResLeft 		= util.QuickTrace(v:GetLocalPos(), left * multView, {v})
					local traceResForward 	= util.QuickTrace(v:GetLocalPos(), forward * multView, {v})
					local traceResBackward 	= util.QuickTrace(v:GetLocalPos(), backward * multView, {v})
					
					local shouldAdjust		= false
					
					
					
					if (traceResRight.HitWorld) then
						shouldAdjust		= true
						hitRes				= traceResRight
					elseif (traceResLeft.HitWorld) then
						shouldAdjust		= true
						hitRes				= traceResLeft
					elseif (traceResForward.HitWorld) then
						shouldAdjust		= true
						hitRes				= traceResForward
					elseif (traceResBackward.HitWorld) then
						shouldAdjust		= true
						hitRes				= traceResBackward
					end
			
					if (shouldAdjust) then
						if (speed < v:GetRunSpeed()) then
							speed = v:GetRunSpeed()
						end
						
						if (math.abs(hitRes.HitNormal.x) == 1 && math.abs(hitRes.HitNormal.y) == 0) then -- are these walls not slanted
							-- which directection are these walls?
							local adjView 	= Vector(0, view.y, view.z):GetNormal()
							local newSpeed	= speed
							if (wallRunSlower) then
								local newSpeed	= speed * math.abs((wallRunSlower - (velocity:GetNormal() - adjView):Length())/ wallRunSlower)
							end
							v:SetLocalVelocity(adjView * newSpeed) 
						elseif (math.abs(hitRes.HitNormal.x) == 0 && math.abs(hitRes.HitNormal.y) == 1) then -- are the walls not slanted?
							-- which directection are these walls?
							local adjView 	= Vector(view.x, 0, view.z):GetNormal()
							local newSpeed	= speed
							if (wallRunSlower) then
								local newSpeed	= speed * math.abs((wallRunSlower - (velocity:GetNormal() - adjView):Length())/ wallRunSlower)
							end
							v:SetLocalVelocity(adjView * newSpeed)
						end
					end
				end
			elseif (v.lobbyMoveType == 2 && !v:KeyDown(IN_DUCK)) then -- hover mode
				local pFloatDist = floatDist
				
				if (v:KeyDown(IN_JUMP)) then
					pFloatDist = 8
				end
				
				local checkGround 			= util.QuickTrace(v:GetLocalPos(), Vector(0,0,-1) * pFloatDist, {v})
				local startVelocity 		= v:GetVelocity()
				local aim					= v:GetAimVector()
				local aimHorizontal			= Vector(aim.x, aim.y, 0):GetNormal()
				local horizontalVelocity	= Vector(startVelocity.x, startVelocity.y, 0)
				
				if (checkGround.Fraction < 1) then
					v:SetLocalVelocity(horizontalVelocity + (Vector(0,0,floatUpAdd) * (.5 - checkGround.Fraction)))
				end
			elseif (v.lobbyMoveType == 3 && v:IsOnGround()) then -- bunny mode and on the ground? we can't have that!
				v:SetVelocity(Vector(0,0,250))
			elseif (v.lobbyMoveType == 4) then -- pogo mode
				local checkGround 			= util.QuickTrace(v:GetLocalPos(), Vector(0,0,-1) * floatDist, {v})
				local startVelocity 		= v:GetVelocity()
				local aim					= v:GetAimVector()
				local aimHorizontal			= Vector(aim.x, aim.y, 0):GetNormal()
				
				v:SetLocalVelocity(startVelocity + (Vector(0,0,floatUpAdd/2) * (1 - checkGround.Fraction)) + (aimHorizontal * (1 - checkGround.Fraction) * floatSpeedAdd))
			end
		end
	end
end)

hook.Add("KeyPress", "Parkour Movement key press", function(ply, key)
	if (ply:Team() != 5 && ply.lobbyMoveType == 1 && CurTime() - ply.lastWtime > webBoostCD/4) then -- parkour mode and not handicapped
		local view 				= ply:GetAimVector()
		local right				= Vector(view.y, -view.x, 0):GetNormal()
		local left				= -right
		local forward 			= Vector(view.x, view.y, 0):GetNormal()
		local backward			= -forward
		local horVelocity		= Vector(ply:GetVelocity().x, ply:GetVelocity().y, 0)
		local vertVelocity		= Vector(0, 0, ply:GetVelocity().z)
		
		local traceResRight 	= util.QuickTrace(ply:GetLocalPos(), right * pMultView, {ply})
		local traceResLeft 		= util.QuickTrace(ply:GetLocalPos(), left * pMultView, {ply})
		local traceResForward 	= util.QuickTrace(ply:GetLocalPos(), forward * pMultView, {ply})
		local traceResBackward 	= util.QuickTrace(ply:GetLocalPos(), backward * pMultView, {ply})
		
		
		if (key == IN_ATTACK2 && ((!traceResRight.HitSky && traceResRight.HitWorld)|| (!traceResLeft.HitSky && traceResLeft.HitWorld) || (!traceResForward.HitSky && traceResForward.HitWorld) || (!traceResBackward.HitSky && traceResBackward.HitWorld))) then
			ply:SetVelocity(Vector(0,0,-ply:GetVelocity().z))
			ply:EmitSound(wjSound(), wjSoundLevel, wjPitch + 100)
		elseif (traceResRight.HitWorld && ply:KeyDown(IN_MOVELEFT) && ply:KeyDown(IN_JUMP)) then
			--ply:SetLocalVelocity((((left * 150) + horVelocity):GetNormal() * (ply:GetVelocity():Length() + 200)) + Vector(0,0,200) + vertVelocity)
			ply:SetVelocity(left * 200 + Vector(0,0,200))
			ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
			ply.lastWtime = CurTime()
		elseif (traceResLeft.HitWorld && ply:KeyDown(IN_MOVERIGHT) && ply:KeyDown(IN_JUMP)) then
			--ply:SetLocalVelocity((((right * 150) + horVelocity):GetNormal() * (ply:GetVelocity():Length() + 200)) + Vector(0,0,200) + vertVelocity)
			ply:SetVelocity(right * 200 + Vector(0,0,200))
			ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
			ply.lastWtime = CurTime()
		elseif (traceResForward.HitWorld && ply:KeyDown(IN_BACK) && ply:KeyDown(IN_JUMP)) then
			--ply:SetLocalVelocity((((backward * 150) + horVelocity):GetNormal() * (ply:GetVelocity():Length() + 200)) + Vector(0,0,200) + vertVelocity)
			ply:SetVelocity(backward * 200 + Vector(0,0,200))
			ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
			ply.lastWtime = CurTime()
		elseif (traceResBackward.HitWorld && ply:KeyDown(IN_FORWARD) && ply:KeyDown(IN_JUMP)) then
			--ply:SetLocalVelocity((((forward * 150) + horVelocity):GetNormal() * (ply:GetVelocity():Length() + 200)) + Vector(0,0,200) + vertVelocity)
			ply:SetVelocity(forward * 200 + Vector(0,0,200))
			ply:EmitSound(wjSound(), wjSoundLevel, wjPitch)
			ply.lastWtime = CurTime()
		end
	end
end)