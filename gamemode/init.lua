print("Loaded init.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_settings.lua")
AddCSLuaFile("cl_effects.lua")
AddCSLuaFile("cl_tabmenu.lua")
AddCSLuaFile("cl_lobbies.lua")
AddCSLuaFile("cl_lobbies_menu_functions.lua")
AddCSLuaFile("cl_lobbies_menu.lua")
AddCSLuaFile("cl_lobby_make_Settings.lua")

AddCSLuaFile("sh_air_strafing.lua")
AddCSLuaFile("sh_movement.lua")

include("shared.lua")
include("sh_movement.lua")
include("sv_trail.lua")
include("sv_heal.lua")
include("sv_commands.lua")
include("sv_lobbies.lua")
include("sv_lobby_switching.lua")
include("sh_air_strafing.lua")

RunConsoleCommand("sv_gravity", "300")
RunConsoleCommand("sv_sticktoground", "0")
RunConsoleCommand("sv_airaccelerate", "10")
RunConsoleCommand("sv_maxvelocity", "10000")
RunConsoleCommand("sv_rollangle", "0")
RunConsoleCommand("sv_rollspeed", "0")
RunConsoleCommand("sv_alltalk", "1")



hook.Add("PlayerInitialSpawn", "initial spawn", function(ply)	
	ply:SetWalkSpeed(400)
	ply:SetRunSpeed(400)														-- changes frequently, walk speed is actually the defualt speed for starting the sprint
	ply:SetCrouchedWalkSpeed(400)
	ply:SetJumpPower(200)
	ply:SetTeam(0)
	ply:SetNoCollideWithTeammates(true)
	ply:SetCustomCollisionCheck()
	
	ply.lobby							= {}									-- holds all players in the lobby
	ply.lobbyHasPass					= false									
	ply.lobbyShouldLava					= false	
	ply.lobbyMoveType					= 1										-- determines what moves each player can use
	ply.lobbyPass						= ""
	ply.lobbyID							= ""
	ply.lobbyType						= 0
	ply.hasWJ							= false									-- wut
	ply.radius							= 0										-- used for spiderman calculations
	ply.webPos							= Vector(0,0,0)							-- used for spiderman calculations
	ply.lastWtime						= 0										-- essentially used for any timer between moves
		
	
	-- update for clientside values
	ply:SetNetworkedBool("lobbyShouldLava", ply.lobbyShouldLava)
	ply:SetNetworkedBool("lobbyHasPass", ply.lobbyHasPass)
	ply:SetNetworkedVector("webPos", ply.webPos)
	ply:SetNetworkedInt("lobbyMoveType", ply.lobbyMoveType)
	ply:SetNetworkedInt("lobbyType", ply.lobbyType)
	ply:SetNetworkedString("lobbyID", ply.lobbyID)
end)

hook.Add("PlayerSetModel", "set playermodel", function(ply)
	ply:SetModel(player_manager.TranslatePlayerModel(ply:GetInfo("cl_playermodel")) )
end)

hook.Add("DoPlayerDeath", "player dies", function(ply)
	SafeRemoveEntity(ply.Trail)
	ply:SetArmor(0)
end)

-- copy pasta from somewhere else =/
hook.Add("PlayerSpawn", "hands", function(ply)
	local oldhands = ply:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		ply:SetHands( hands )
		hands:SetOwner( ply )

		local cl_playermodel = ply:GetInfo( "cl_playermodel" )
		local info = player_manager.TranslatePlayerHands( cl_playermodel )
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		local vm = ply:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		ply:DeleteOnRemove( hands )

		hands:Spawn()
 	end
end)

hook.Add("GetFallDamage", "calcFallDamage", function(ply, speed)
	return ( (speed / 20) - 30)
end)

hook.Add("PlayerShouldTakeDamage", "playershouldtakedamage", function(ply, attacker)
	if (!attacker:IsWorld() && (attacker:GetName() == "Roller Mine" || ply.lobbyID != attacker.lobbyID)) then
		return false -- disable rollermine damage. return true to allow damage
	end
end)


-- apears on everyones screen
function MessageLobby(message, lobby)
	umsg.Start("Messaging", lobby) 
	umsg.String(message)
	umsg.End()
end