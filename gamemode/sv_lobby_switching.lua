print("Loaded sv_lobby_switching.lua")

joinLobby = function(ply1, ply2)
	local lobbyIndex = -1
	for k,v in pairs (ply2.lobby) do 
		lobbyIndex = k + 1
	end
	
	ply2.lobby[lobbyIndex] = ply1 -- place ply1 in ply2's lobby
		
	-- sync ply1 lobby values with ply2's
	ply1.lobby = {}
	ply1.lobbyType = ply2.lobbyType
	ply1.lobbyID = ply2:SteamID()
	ply1.lobbyPass = ply2.lobbyPass
	ply1.lobbyHasPass = ply2.lobbyHasPass
	ply1.lobbyShouldLava	= ply2.lobbyShouldLava
	ply1.lobbyMoveType = ply2.lobbyMoveType
	ply1:SetNetworkedInt("lobbyType", ply1.lobbyType)
	ply1:SetNetworkedString("lobbyID", ply1.lobbyID)
	ply1:SetNetworkedBool("lobbyShouldLava", ply1.lobbyShouldLava)
	ply1:SetNetworkedBool("lobbyHasPass", ply1.lobbyHasPass)
	ply1:SetNetworkedInt("lobbyMoveType", ply1.lobbyMoveType)
	
	local lobbyType = "error" -- did not find lobby name
		
	if (ply1.lobbyType == 1) then
		ply1:SetTeam(1) -- defualt team
		lobbyType = "Hunted"
	elseif (ply1.lobbyType == 2) then
		ply1:SetTeam(4) -- defualt team
		lobbyType = "Tag"
	elseif (ply1.lobbyType == 3) then
		ply1:SetTeam(1) -- defualt team
		lobbyType = "Handicapped"
	elseif (ply1.lobbyType == 4) then
		ply1:SetTeam(6) -- defualt team
		lobbyType = "Elimination"
	elseif (ply1.lobbyType == 5) then
		ply1:SetTeam(8) -- defualt team
		lobbyType = "Miscellaneous"
	elseif (ply1.lobbyType == 6) then
		ply1:SetTeam(9) -- defualt team
		lobbyType = "FreezeTag"
	elseif (ply1.lobbyType == 7) then
		ply1:SetTeam(12) -- defualt team
		ply1:Give("weapon_crossbow")
		ply1:Give("weapon_rpg")
		ply1:Give("weapon_frag")
		ply1:Give("weapon_slam")
		ply1:SetAmmo(1000,"XBowBolt")
		ply1:SetAmmo(1000,"RPG_Round")
		ply1:SetAmmo(1000,"Grenade")
		ply1:SetAmmo(1000,"slam")
		lobbyType = "DeathMatch"
	end
	
	updateTrail(ply1)
	PrintMessage(HUD_PRINTTALK, ply1:Nick() .. " has joined " .. ply2:Nick() .. "'s lobby of " ..  lobbyType)
end

makeLobby = function(ply, args)
	local shouldMakeLobby  	= false
	local lobbyName  		= ""
	local toMakeType 		= 0
	local defaultTeam		= 0
	
	if (args[1] == "1") then
		toMakeType 		= 1
		defaultTeam		= 1
		lobbyName 		= "Hunted"
		shouldMakeLobby = true
	elseif (args[1] == "2") then
		toMakeType 		= 2
		defaultTeam		= 4
		lobbyName 		= "Tag"
		shouldMakeLobby = true
	elseif (args[1] == "3") then
		toMakeType 		= 3
		defaultTeam		= 1
		lobbyName 		= "Handicapped"
		shouldMakeLobby = true
	elseif (args[1] == "4") then
		toMakeType 		= 4
		defaultTeam		= 6
		lobbyName 		= "Elimination"
		shouldMakeLobby = true
	elseif (args[1] == "5") then
		toMakeType 		= 5
		defaultTeam		= 8
		lobbyName 		= "Miscellaneous"
		shouldMakeLobby = true
	elseif (args[1] == "6") then
		toMakeType 		= 6
		defaultTeam		= 9
		lobbyName 		= "FreezeTag"
		shouldMakeLobby = true
	elseif (args[1] == "7") then
		toMakeType 		= 7
		defaultTeam		= 12
		lobbyName 		= "DeathMatch"
		shouldMakeLobby = true
		ply:Give("weapon_crossbow")
		ply:Give("weapon_rpg")
		ply:Give("weapon_frag")
		ply:Give("weapon_slam")
		ply:SetAmmo(1000,"XBowBolt")
		ply:SetAmmo(1000,"RPG_Round")
		ply:SetAmmo(1000,"Grenade")
		ply:SetAmmo(1000,"slam")
	else
		ply:ChatPrint("Error: lobby type not found!") -- they gave a value that isn't recognized
	end
	
	if (shouldMakeLobby) then -- they actually gave a correct lobby and they are not already in a lobby
		-- set password if aplicable
		if (args[2] != nil && args[2] != "") then
			ply.lobbyPass 		= args[2]
			ply.lobbyHasPass 	= true
		else
			ply.lobbyHasPass 	= false
			ply.lobbyPass 		= ""
		end
		
		-- floor is lava?
		if (args[3] != nil && args[3] != "0") then
			ply.lobbyShouldLava	= true
		else
			ply.lobbyShouldLava	= false			
		end
		
		-- what kind of movement do they want?
		if (args[4] != nil && args[4] == "0") then -- parkour
			ply.lobbyMoveType 	= 0
		elseif (args[4] != nil && args[4] == "2") then -- hover
			ply.lobbyMoveType 	= 2
		elseif (args[4] != nil && args[4] == "3") then -- auto hop
			ply.lobbyMoveType 	= 3
		elseif (args[4] != nil && args[4] == "4") then -- pogo
			ply.lobbyMoveType 	= 4
		else -- defualt spiderman
			ply.lobbyMoveType 	= 1
		end
		
		-- set the values
		ply.lobby = {}
		ply.lobby[0] = ply
		ply.lobbyType = toMakeType
		ply.lobbyID	= ply:SteamID()
		ply:SetTeam(defaultTeam)
		ply:SetNetworkedInt("lobbyType", ply.lobbyType)
		ply:SetNetworkedString("lobbyID", ply.lobbyID)
		ply:SetNetworkedBool("lobbyShouldLava", ply.lobbyShouldLava)
		ply:SetNetworkedBool("lobbyHasPass", ply.lobbyHasPass)
		ply:SetNetworkedInt("lobbyMoveType", ply.lobbyMoveType)
		
		updateTrail(ply)
		PrintMessage(HUD_PRINTTALK, ply:Nick() .. " has made a " .. lobbyName .. " lobby")
	end
end

leaveLobby = function(ply)
	if (ply.lobbyID == ply:SteamID()) then -- if they actually have a lobby then anounce that its closed
		if(ply.lobbyType == 0) then 
			ply:ChatPrint("Error: Cannot close a non-existent lobby!")
		elseif (ply.lobbyType == 1) then			
			lobbyName = "Hunted"
		elseif (ply.lobbyType == 2) then			
			lobbyName = "Tag"
		elseif (ply.lobbyType == 3) then			
			lobbyName = "Handicapped"
		elseif (ply.lobbyType == 4) then			
			lobbyName = "Elimination"
		elseif (ply.lobbyType == 5) then			
			lobbyName = "Miscellaneous"
		elseif (ply.lobbyType == 6) then			
			lobbyName = "FreezeTag"
		elseif (ply.lobbyType == 7) then			
			lobbyName = "DeathMatch"
		end
		
		if (lobbyName != "") then
			PrintMessage(HUD_PRINTTALK, ply:Nick() .. " has closed their " .. lobbyName .. " lobby")
		end
	end
	
	for k,v in pairs (player.GetAll()) do
		if (v:SteamID() == ply.lobbyID) then
			local lobbyIndex = -1
			for m,n in pairs (v.lobby) do
				if (n == ply) then
					lobbyIndex = m
				end
			end
			
			v.lobby[lobbyIndex] = nil
		end
	end
	
	-- reset all values for those in the lobby
	for k,v in pairs (ply.lobby) do
		if (v != ply) then
			v.lobby = {}
			v.lobbyType = 0
			v.lobbyMoveType = 1			-- defualt move type
			v.lobbyID	= ""
			v.lobbyPass = ""
			v.lobbyHasPass = false
			v.lobbyShouldLava	= false	
			v:SetTeam(0)
			v:StripWeapons()
			v:SetNetworkedInt("lobbyType", v.lobbyType)
			v:SetNetworkedString("lobbyID", v.lobbyID)
			v:SetNetworkedBool("lobbyShouldLava", v.lobbyShouldLava)
			v:SetNetworkedBool("lobbyHasPass", v.lobbyHasPass)
			v:SetNetworkedInt("lobbyMoveType", v.lobbyMoveType)
			updateTrail(v)
		end
	end
	
	-- reset ply values just in case
	ply.lobby = {}
	ply.lobbyType = 0
	ply.lobbyID	= ""
	ply.lobbyPass = ""
	ply.lobbyHasPass = false
	ply.lobbyShouldLava	= false	
	ply.lobbyMoveType = 0
	ply:StripWeapons()
	ply:SetTeam(0)
	ply:SetNetworkedInt("lobbyType", ply.lobbyType)
	ply:SetNetworkedString("lobbyID", ply.lobbyID)
	ply:SetNetworkedBool("lobbyShouldLava", ply.lobbyShouldLava)
	ply:SetNetworkedBool("lobbyHasPass", ply.lobbyHasPass)
	ply:SetNetworkedInt("lobbyMoveType", ply.lobbyMoveType)
	
	updateTrail(ply)
end

kickPlayer = function(ply, id)
	for k,v in pairs (player.GetAll()) do
		if (id == v:SteamID() && v.lobbyID == ply.lobbyID) then -- did we find them?
			-- reset their vaues
			ply.lobby[k] = nil
			
			v.lobby = {}			
			v.lobbyType = 0
			v.lobbyID = ""
			v.lobbyMoveType = 0
			v.lobbyPass = ""
			v.lobbyHasPass = false
			v.lobbyShouldLava	= false	
			v:SetTeam(0)
			v:SetNetworkedInt("lobbyType", v.lobbyType)
			v:SetNetworkedString("lobbyID", v.lobbyID)
			v:SetNetworkedBool("lobbyShouldLava", v.lobbyShouldLava)
			v:SetNetworkedBool("lobbyHasPass", v.lobbyHasPass)
			v:SetNetworkedInt("lobbyMoveType", v.lobbyMoveType)
			
			v:ChatPrint("You have been kicked!")
			updateTrail(v)
		end
	end
end