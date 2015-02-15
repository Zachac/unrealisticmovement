print("Loaded sv_lobbies.lua")

xCatchMin	= 70
yCatchMin	= 70
zCatchMin	= 90



hook.Add("Think", "lobbies update", function()
	for k,v in pairs (player.GetAll()) do
		if (v.lobbyType != 0 && v.lobbyID == v:SteamID()) then -- do they own a lobby?
			if (v.lobbyType == 1) then -- what type of lobby?
				huntedLobby(v) -- execute that lobbys function and give the owner of the lobby
			elseif (v.lobbyType == 2) then
				tagLobby(v)
			elseif (v.lobbyType == 3) then
				handicappedLobby(v)
			elseif (v.lobbyType == 4) then
				eliminationLobby(v)
			elseif (v.lobbyType == 5) then
				miscLobby(v)
			elseif (v.lobbyType == 6) then
				freezeTagLobby(v)
			elseif (v.lobbyType == 7) then
				deathmatchLobby(v)
			end
		end
	end
end)



huntedLobby = function(v)
	local found = false
	
	for m,n in pairs (v.lobby) do -- everyone in the lobby
		if (v.lobbyShouldLava && n:IsOnGround()) then -- should we hurt them?
			n:TakeDamage(1, n, n:GetActiveWeapon())
		end
		
		if (n:Team() == 2) then -- are they a hunter?
			for r,t in pairs (v.lobby) do
				if (n != t && t:Alive() && n:Team() != t:Team()) then
					if (math.abs(n:GetPos().x - t:GetPos().x) < xCatchMin && math.abs(n:GetPos().y - t:GetPos().y) < yCatchMin && math.abs(n:GetPos().z - t:GetPos().z) < zCatchMin) then
						n:SetTeam(1)
						t:SetTeam(2)
						n:Spawn()
						
						updateTrail(n)
						updateTrail(t)
						MessageLobby(t:Nick() .. " has caught " .. n:Nick(), v.lobby)
					end
				end
			end				
			found = true
		end				
	end
				
	if (!found) then -- are there any hunted?
		rp = table.Random(v.lobby)
		if (rp:Alive()) then -- is the random player dead?
			rp:SetTeam(2)
			updateTrail(rp)
			MessageLobby(rp:Nick() .. " has been randomly selected as hunted!", v.lobby)
		end
	end
end

tagLobby = function(v)
	local found = false
	
	for m,n in pairs (v.lobby) do
		if (v.lobbyShouldLava && n:IsOnGround()) then
			n:TakeDamage(1, n, n:GetActiveWeapon() )
		end
		
		if (n:Team() == 3) then
			if (!n:Alive()) then
				n:Spawn()
			end
			
			for r,t in pairs (v.lobby) do
				if (n != t && t:Alive() && n:Team() != t:Team()) then
					if (math.abs(n:GetPos().x - t:GetPos().x) < xCatchMin && math.abs(n:GetPos().y - t:GetPos().y) < yCatchMin && math.abs(n:GetPos().z - t:GetPos().z) < zCatchMin) then
						n:SetTeam(4)
						t:SetTeam(3)
						t:Spawn()
						
						updateTrail(n)
						updateTrail(t)
						MessageLobby(n:Nick() .. " has caught " .. t:Nick(), v.lobby)
					end
				end
			end				
			found = true
		end				
	end
				
	if (!found) then
		rp = table.Random(v.lobby)
		if (rp:Alive()) then
			rp:SetTeam(3)
			
			updateTrail(rp)
			MessageLobby(rp:Nick() .. " has been randomly selected as tagger!", v.lobby)
		end
	end
end

handicappedLobby = function(v)
	local found = false
	
	for m,n in pairs (v.lobby) do
		if (v.lobbyShouldLava && n:IsOnGround()) then
			n:TakeDamage(1, n, n:GetActiveWeapon() )
		end
		
		if (n:Team() == 5) then
			for r,t in pairs (v.lobby) do
				if (n != t && t:Alive() && n:Team() != t:Team()) then
					if (math.abs(n:GetPos().x - t:GetPos().x) < xCatchMin && math.abs(n:GetPos().y - t:GetPos().y) < yCatchMin && math.abs(n:GetPos().z - t:GetPos().z) < zCatchMin) then
						t:SetTeam(5)
						t:Give("weapon_crossbow")
						t:SetAmmo(1000,"XBowBolt")
						n:SetTeam(1)
						n:StripWeapons()
						n:Spawn()
						
						updateTrail(n)
						updateTrail(t)
						MessageLobby(t:Nick() .. " has caught " .. n:Nick(), v.lobby)
					end
				end
			end				
			found = true
		end				
	end
				
	if (!found) then
		rp = table.Random(v.lobby)
		if (rp:Alive()) then
			rp:SetTeam(5)
			rp:Give("weapon_crossbow")
			rp:SetAmmo(1000,"XBowBolt")
			
			updateTrail(rp)
			MessageLobby(rp:Nick() .. " has been randomly selected as handicapped!", v.lobby)
		end
	end
end


eliminationLobby = function(v)
	local found = false
	local count = 0
	
	for m,n in pairs (v.lobby) do
		if (v.lobbyShouldLava && n:IsOnGround()) then
			n:TakeDamage(1, n, n:GetActiveWeapon() )
		end
		
		if (n:Team() == 7) then
			for r,t in pairs (v.lobby) do
				if (n != t && t:Alive() && n:Team() != t:Team()) then
					if (math.abs(n:GetPos().x - t:GetPos().x) < xCatchMin && math.abs(n:GetPos().y - t:GetPos().y) < yCatchMin && math.abs(n:GetPos().z - t:GetPos().z) < zCatchMin) then
						n:SetTeam(6)
						updateTrail(n)
						MessageLobby(t:Nick() .. " has caught " .. n:Nick(), v.lobby)
					end
				end
			end				
			found = true
		end	
		count = count + 1
	end
				
	if (!found && count > 1) then
		for m,n in pairs (v.lobby) do 
			n:SetTeam(7)
		end
		
		rp = table.Random(v.lobby)
		if (rp:Alive()) then
			rp:SetTeam(6)
			rp:Spawn()
			
			updateTrail(rp)
			MessageLobby(rp:Nick() .. " has been randomly selected as infected!", v.lobby)
		end
	end
end

miscLobby = function(v)
	for m,n in pairs (v.lobby) do
		if (v.lobbyShouldLava && n:IsOnGround()) then
			n:TakeDamage(1, n, n:GetActiveWeapon() )
		end
	end
end

freezeTagLobby = function(v)
	local found = false
	local count = 0
	
	for m,n in pairs (v.lobby) do
		if (v.lobbyShouldLava && n:IsOnGround()) then
			n:TakeDamage(1, n, n:GetActiveWeapon() )
		end
		
		if (n:Team() == 10) then
			for r,t in pairs (v.lobby) do
				if (n != t && t:Alive() && n:Team() != t:Team()) then
					if (t:Team() == 11) then
						if (math.abs(n:GetPos().x - t:GetPos().x) < xCatchMin && math.abs(n:GetPos().y - t:GetPos().y) < yCatchMin && math.abs(n:GetPos().z - t:GetPos().z) < zCatchMin) then
							n:SetTeam(9)
							
							updateTrail(n)
							MessageLobby(t:Nick() .. " has caught " .. n:Nick(), v.lobby)
							n.lastWtime = CurTime()
						end
					else
						if (CurTime() - t.lastWtime > 1 && math.abs(n:GetPos().x - t:GetPos().x) < xCatchMin && math.abs(n:GetPos().y - t:GetPos().y) < yCatchMin && math.abs(n:GetPos().z - t:GetPos().z) < zCatchMin) then
							t:SetTeam(10)
							
							updateTrail(t)
							MessageLobby(n:Nick() .. " has unfrozen " .. t:Nick(), v.lobby)
						end
					end
				end
			end				
			found = true
		end	
		count = count + 1
	end
				
	if (!found && count > 1) then
		for m,n in pairs (v.lobby) do 
			n:SetTeam(10)
		end
		
		rp = table.Random(v.lobby)
		if (rp:Alive()) then
			rp:SetTeam(11)
			rp:Spawn()
			
			updateTrail(rp)
			MessageLobby(rp:Nick() .. " has been randomly selected as the freezer!", v.lobby)
		end
	end
end

deathmatchLobby = function(v)
	for m,n in pairs (v.lobby) do
		if (v.lobbyShouldLava && n:IsOnGround()) then
			n:TakeDamage(1, n, n:GetActiveWeapon() )
		end
		
		
		for r,t in pairs (v.lobby) do
			if (n != t && t:Alive() && n:Alive()) then
				if (math.abs(n:GetPos().x - t:GetPos().x) < xCatchMin && math.abs(n:GetPos().y - t:GetPos().y) < yCatchMin && math.abs(n:GetPos().z - t:GetPos().z) < zCatchMin) then
					if (n:GetVelocity():Length() > t:GetVelocity():Length()) then
						t:Kill()
						MessageLobby(n:Nick() .. " has killed " .. t:Nick(), v.lobby)
					else
						n:Kill()
						MessageLobby(t:Nick() .. " has killed " .. n:Nick(), v.lobby)
					end
				end
			end
		end					
	end
end

hook.Add("PlayerSpawn", "give weapons", function(ply)
	if (ply:Team() == 12) then
		ply:Give("weapon_crossbow")
		ply:Give("weapon_rpg")
		ply:Give("weapon_frag")
		ply:Give("weapon_slam")
		ply:SetAmmo(1000,"XBowBolt")
		ply:SetAmmo(1000,"RPG_Round")
		ply:SetAmmo(1000,"Grenade")
		ply:SetAmmo(1000,"slam")
	end
end)

-- determines what happens for each lobby
hook.Add("PlayerDeath", "death penalty", function(ply)
	if (ply.lobbyType == 1) then
		if (ply:Team() == 2) then
			ply:SetTeam(1)
		end
	elseif (ply.lobbyType == 2) then
	elseif (ply.lobbyType == 3) then
		if (ply:Team() == 5) then
			ply:SetTeam(1)
		end
	end
end)