print("Loaded sv_commands.lua")

concommand.Add("um_remove_ball", function(ply, command, args)
	if (IsValid(ply.rm)) then
		ply.rm:Remove()
	end
end)

-- makes a ball
concommand.Add("um_get_ball", function(ply, command, args)
	if (IsValid(ply.rm)) then
		ply.rm:Remove()
	end
	
	ply.rm = ents.Create( "npc_rollermine" )
	ply.rm:SetPos(ply:GetShootPos())
	ply.rm:SetName("Roller Mine")
	ply.rm:Spawn()
	
	ply.rm.Trail				  	= util.SpriteTrail(ply.rm, 0, Color(255,100,200,155), false, trailSW, trailEW, trailLife, trailRes, trailTexture)
end)

-- fix a persons trail =/
concommand.Add("um_trail_update", function(ply, command, args)
	updateTrail(ply)
end)

-- get guns
concommand.Add("um_get_gun", function(ply, command, args)
	-- allowed weapons
	if(args[1] == "weapon_crowbar" || args[1] == "weapon_physcannon") then
		ply:Give(args[1])
	end
end)

-- make lobby
concommand.Add("um_make_lobby", function(ply, command, args)
	if (args[1] == "0") then -- delete lobby
		leaveLobby(ply)
	elseif (ply.lobbyType != 0) then -- make sure that they are not in a lobby
		ply:ChatPrint("Error: you already have a lobby!")
	elseif (args[1] != nil) then
		makeLobby(ply, args)
	end
end)

-- join lobby
concommand.Add("um_join_lobby", function(ply, command, args)
	if (ply.lobbyID != "") then
		ply:ChatPrint("Error: you already have a lobby!")
		return
	end
	
	for k,v in pairs (player.GetAll()) do
		if (args[1] == v:SteamID()) then
			if (v.lobbyHasPass && v.lobbyPass != args[2]) then
				return
			else
				joinLobby(ply, v)
			end
		end
	end
end)

-- force everyone to make a lobby, as long as the command giver is me
concommand.Add("um_force_make_lobby", function(ply, command, args)
	if (ply:SteamID() == "STEAM_0:1:47291765") then
		for k,v in pairs (player.GetAll()) do
			if (ply != v) then
				leaveLobby(v)
				makeLobby(v, {"1"})
				PrintMessage(HUD_PRINTTALK, v:Nick() .. " has made a lobby")
			end
		end
	else
		ply:ChatPrint("lol, no")
	end
end)

-- force everyone to join my lobby as long as they are me
concommand.Add("um_force_join_lobby", function(ply, command, args)
	if (ply:SteamID() == "STEAM_0:1:47291765") then
		for k,v in pairs (player.GetAll()) do
			if (ply != v) then
				leaveLobby(v)
				joinLobby(v, ply)
			end
		end
	else
		ply:ChatPrint("lol, no")
	end
end)

-- kick from lobby
concommand.Add("um_remove_player", function(ply, command, args)
	if (ply:SteamID() != ply.lobbyID || ply.lobbyID == "") then return end -- are they the owner of their own lobby?
	
	if (ply:SteamID() == args[1]) then -- make sure they are not kicking themselves
		ply:ChatPrint("Error: you cannot kick yourself")
		return
	end
	
	kickPlayer(ply, args[1])
end)


-- remove guns
concommand.Add("um_remove_guns", function(ply, command, args)
	ply:StripWeapons()
end)

-- spectate
concommand.Add("um_spectate", function(ply, command, args)
	for k,v in pairs(player.GetAll()) do
		if (v:Nick() == args[1] && v != ply && ply:IsOnGround()) then -- found the player to spectate and are they they trying to spectate themselves?
			ply:Spectate(4)
			ply:SpectateEntity(v)
		end
	end
end)

-- unspectate
concommand.Add("um_unspectate", function(ply, command, args)
	local position = ply:GetPos()
	ply:UnSpectate()
	ply:Spawn()
	ply:SetPos(position)
end)

-- set playermodel, probably should make a better system for this =/
concommand.Add("um_move_mode", function(ply, command, args)
	if (ply.lobbyID != "") then
		ply:ChatPrint("Error: Only available outside a lobby")
		return
	end
	
	
	if (args[1] == "0") then
		ply.lobbyMoveType = 0
	elseif (args[1] == "1") then
		ply.lobbyMoveType = 1
	elseif (args[1] == "2") then
		ply.lobbyMoveType = 2
	elseif (args[1] == "3") then
		ply.lobbyMoveType = 3
	elseif (args[1] == "4") then
		ply.lobbyMoveType = 4
	end
	
	ply:SetNetworkedInt("lobbyMoveType", ply.lobbyMoveType)
end)

-- my random commands
concommand.Add("um_foo", function(ply, command, args)
	if (ply:SteamID() != "STEAM_0:1:47291765") then
		ply:ChatPrint("lol, no")
		return
	end
	
	if (args[1] == "noclip") then
		if (ply:GetMoveType() != MOVETYPE_NOCLIP) then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		else
			ply:SetMoveType(MOVETYPE_WALK)
		end
	end
	
	ply:SetHealth(100)
end)