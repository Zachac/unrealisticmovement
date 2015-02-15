print("Loaded cl_lobbies_menu_functions.lua")

local ply 		= LocalPlayer()
LobbyButtonMenu = NULL
PlayerListFrame = NULL
InfoLabel 		= NULL
PassField 		= NULL
DeleteLobby		= NULL
JoinLobby		= NULL
openLobbies		= {}
InLobby			= {}

initializeLobbys = function()
	if (!ply:IsValid() || ply:GetNetworkedString("lobbyID") == ply:SteamID()) then
		ply = LocalPlayer()
	end

	if (LobbyButtonMenu != NULL) then
		LobbyButtonMenu:Remove()
	end
	
	LobbyButtonMenu = vgui.Create("DFrame", LobbyMenu)
	LobbyButtonMenu:SetSize(ScrW() - 640, ScrH() - 30)
	LobbyButtonMenu:SetPos(320, 30)
	LobbyButtonMenu:SetTitle("")
	LobbyButtonMenu:SetDraggable(false)
	LobbyButtonMenu:ShowCloseButton(false)
	LobbyButtonMenu:SetVisible(true)
	LobbyButtonMenu:MakePopup()
	LobbyButtonMenu.Paint = function()
		surface.SetDrawColor(Color(0, 0, 0, 145))
		surface.DrawRect(0, 0, LobbyButtonMenu:GetWide(), LobbyButtonMenu:GetTall())
	end

	
	local lobbyPos		= {}
	lobbyPos.x			= 0
	lobbyPos.y			= 0

	for k,v in pairs (player.GetAll()) do
		if (openLobbies[k] != nil) then 
			openLobbies[k]:Remove()
			openLobbies[k] = nil
		end
		
		if (v:GetNetworkedString("lobbyID") == v:SteamID()) then
			local lobbyType = "Error"
			if (v:GetNetworkedInt("lobbyType") == 1) then
				lobbyType = "Hunted"
			elseif (v:GetNetworkedInt("lobbyType") == 2) then
				lobbyType = "Tag"
			elseif (v:GetNetworkedInt("lobbyType") == 3) then
				lobbyType = "Handicapped"
			elseif (v:GetNetworkedInt("lobbyType") == 4) then
				lobbyType = "Elimination"
			elseif (v:GetNetworkedInt("lobbyType") == 5) then
				lobbyType = "Miscellaneous"
			elseif (v:GetNetworkedInt("lobbyType") == 6) then
				lobbyType = "FreezeTag"
			elseif (v:GetNetworkedInt("lobbyType") == 7) then
				lobbyType = "DeathMatch"
			end

			openLobbies[k] = vgui.Create("DButton", LobbyButtonMenu)
			openLobbies[k]:SetSize(ScrW() - 640, 40)
			openLobbies[k]:SetPos(lobbyPos.x, lobbyPos.y)
			openLobbies[k]:SetText(v:Nick() .. "'s lobby of " .. lobbyType)
			openLobbies[k]:SetTextColor(Color(0,0,0,255))
			openLobbies[k].color = defaultColor()
			openLobbies[k].lastCHColor = crossHairColor
			openLobbies[k].Paint = function()
				if (openLobbies[k].lastCHColor != crossHairColor) then
					openLobbies[k].color = defaultColor()
					openLobbies[k].lastCHColor 	= crossHairColor
				end
				
				surface.SetDrawColor(openLobbies[k].color)
				surface.DrawRect( 0, 0, openLobbies[k]:GetWide(), openLobbies[k]:GetTall())
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, openLobbies[k]:GetWide(), openLobbies[k]:GetTall())
						
				for n,m in pairs (player.GetAll()) do
					if (openLobbies[k]:GetText() == v:SteamID() && v:GetNetworkedString("lobbyID") != v:SteamID()) then
						openLobbies[k]:Close()
					end
				end
			end
			
			openLobbies[k].OnMousePressed = function() 
				openLobbies[k].color = clickColor()				
				openLobbies[k]:DoClick()			
			end
			
			openLobbies[k].OnMouseReleased = function() 
				openLobbies[k].color = defaultColor()
			end
			
			openLobbies[k].OnCursorEntered = function() 
				openLobbies[k].color = hoverColor()
			end
			  
			openLobbies[k].OnCursorExited = function() 
				openLobbies[k].color = defaultColor()
			end
			
			openLobbies[k].DoClick = function() 
				ply = v 
				lastUpdate = CurTime() - 10
			end	
			
			lobbyPos.y = lobbyPos.y + openLobbies[k]:GetTall()
			end
		end
end

initializePlayerList = function()
	if (PlayerListFrame != NULL) then
		PlayerListFrame:Remove()
	end
	
	PlayerListFrame = vgui.Create("DFrame", LobbyMenu)
	PlayerListFrame:SetSize(280, ScrH() - 30)
	PlayerListFrame:SetPos(ScrW() - 290, 30)
	PlayerListFrame:SetTitle("")
	PlayerListFrame:SetDraggable(false)
	PlayerListFrame:ShowCloseButton(false)
	PlayerListFrame:SetVisible(true)
	PlayerListFrame:MakePopup()
	PlayerListFrame.Paint = function()
		surface.SetDrawColor(Color(0, 0, 0, 145))
		surface.DrawRect(0, 0, PlayerListFrame:GetWide(), PlayerListFrame:GetTall())
	end


	local action 			= ""
	local count 			= 0
	local infoLabelLength 	= 65
	local playerPos			= {}
	playerPos.x				= 0
	playerPos.y				= 0
	
	
	if (ply:GetNetworkedString("lobbyID") == LocalPlayer():SteamID()) then
		action 		= "Kick "
	end

	
	playerPos.y = playerPos.y + infoLabelLength + 10
	
	for k,v in pairs (player.GetAll()) do
		InLobby[k] = nil
		if (v:GetNetworkedString("lobbyID") == ply:SteamID()) then
			InLobby[k] = vgui.Create("DButton", PlayerListFrame)
			InLobby[k]:SetSize(PlayerListFrame:GetWide(), 30)
			InLobby[k]:SetPos(playerPos.x, playerPos.y)
			InLobby[k]:SetText(action .. v:Nick())
			InLobby[k]:SetTextColor(Color(0,0,0,255))
			InLobby[k].color = defaultColor()
			InLobby[k].lastCHColor = crossHairColor
			InLobby[k].Paint = function()
				if (InLobby[k].lastCHColor != crossHairColor) then
					InLobby[k].color = defaultColor()
					InLobby[k].lastCHColor 	= crossHairColor
				end
				
				surface.SetDrawColor(InLobby[k].color)
				surface.DrawRect( 0, 0, InLobby[k]:GetWide(), InLobby[k]:GetTall())
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, InLobby[k]:GetWide(), InLobby[k]:GetTall())
						
				for n,m in pairs (player.GetAll()) do
					if (InLobby[k]:GetText() == v:SteamID() && v:GetNetworkedString("lobbyID") != v:SteamID()) then
						InLobby[k]:Close()
					end
				end
			end
			
			InLobby[k].OnMousePressed = function() 
				InLobby[k].color = clickColor()				
				InLobby[k]:DoClick()			
			end
			
			InLobby[k].OnMouseReleased = function() 
				InLobby[k].color = defaultColor()
			end
			
			InLobby[k].OnCursorEntered = function() 
				InLobby[k].color = hoverColor()
			end
			  
			InLobby[k].OnCursorExited = function() 
				InLobby[k].color = defaultColor()
			end
			
			InLobby[k].DoClick = function() RunConsoleCommand("um_remove_player", v:SteamID()); print(v:SteamID()) end	
			
			playerPos.y = playerPos.y + InLobby[k]:GetTall()
			count 		= count + 1
		end
	end
		
	if (ply:GetNetworkedString("lobbyID") != "") then
		local movemode 	= "Error"
		local lobbytype	= "Error"
		
		if (ply:GetNetworkedInt("lobbyMoveType") == 0) then
			movemode 	= "Spiderman"
		elseif (ply:GetNetworkedInt("lobbyMoveType") == 1) then
			movemode 	= "Parkour"
		elseif (ply:GetNetworkedInt("lobbyMoveType") == 2) then
			movemode 	= "Hover"
		elseif (ply:GetNetworkedInt("lobbyMoveType") == 3) then
			movemode 	= "Auto Hop"
		end
		
		if (ply:GetNetworkedInt("lobbyType") == 0) then
			lobbytype 	= "None"
		elseif (ply:GetNetworkedInt("lobbyType") == 1) then
			lobbytype 	= "Hunted"
		elseif (ply:GetNetworkedInt("lobbyType") == 2) then
			lobbytype 	= "Tag"
		elseif (ply:GetNetworkedInt("lobbyType") == 3) then
			lobbytype 	= "Handicapped"
		elseif (ply:GetNetworkedInt("lobbyType") == 4) then
			lobbytype 	= "Elimination"
		elseif (ply:GetNetworkedInt("lobbyType") == 5) then
			lobbytype 	= "Miscellaneous"
		elseif (ply:GetNetworkedInt("lobbyType") == 6) then
			lobbytype 	= "FreezeTag"
		end
		
		InfoLabel = vgui.Create("DLabel", PlayerListFrame)
		InfoLabel:SetSize(PlayerListFrame:GetWide(), infoLabelLength)
		InfoLabel:SetPos(0, 0)
		InfoLabel:SetTextInset(5,5)
		InfoLabel:SetContentAlignment(7)
		InfoLabel:SetText("Players: " .. count .. "\nFloor is lava: " .. tostring(ply:GetNetworkedBool("lobbyShouldLava")) .. "\nMove Mode: " .. movemode .. "\nType: " .. lobbytype)
		InfoLabel:SetTextColor(Color(0,0,0,255))
		InfoLabel.color = defaultColor()
		InfoLabel.lastCHColor = crossHairColor
		InfoLabel.Paint = function()
			if (InfoLabel.lastCHColor != crossHairColor) then
				InfoLabel.color = defaultColor()
				InfoLabel.lastCHColor 	= crossHairColor
			end
			
			surface.SetDrawColor(InfoLabel.color)
			surface.DrawRect( 0, 0, InfoLabel:GetWide(), InfoLabel:GetTall())
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, InfoLabel:GetWide(), InfoLabel:GetTall())
		end
		
	end
	
		playerPos.y = playerPos.y + 10
	
	if (ply:GetNetworkedBool("lobbyHasPass")) then
		if (ply:SteamID() == LocalPlayer():SteamID()) then
			PassField = vgui.Create("DLabel", PlayerListFrame)
			PassField:SetText("Password: " .. passFieldCurText)
			PassField.Paint = function()
				surface.SetDrawColor(PassField.color)
				surface.DrawRect( 0, 0, PassField:GetWide(), PassField:GetTall())
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, PassField:GetWide(), PassField:GetTall())
			end
		else
			PassField = vgui.Create("DTextEntry", PlayerListFrame)
			PassField:SetText(passFieldCurText)
			PassField.OnEnter = function() RunConsoleCommand("um_join_lobby", ply:GetNetworkedString("lobbyID"), PassField:GetValue()) end
		end
		
		PassField:SetSize(PlayerListFrame:GetWide(), 30)
		PassField:SetPos(playerPos.x, playerPos.y)
		PassField:SetTextInset(5,0)
		PassField:SetTextColor(Color(0,0,0,255))
		PassField.color = defaultColor()
		PassField.lastCHColor = crossHairColor
		PassField.Think = function() passFieldCurText = PassField:GetValue() end
		
		 playerPos.y =  playerPos.y + PassField:GetTall() + 10
	end	
	
	if (ply:GetNetworkedString("lobbyID") != "") then	
		if (ply:GetNetworkedString("lobbyID") == LocalPlayer():GetNetworkedString("lobbyID")) then
			local DeleteLobby = vgui.Create("DButton", PlayerListFrame)
			DeleteLobby:SetSize(280, 120)
			DeleteLobby:SetPos(playerPos.x, playerPos.y)
			DeleteLobby:SetText("Leave Lobby")
			DeleteLobby:SetTextColor(Color(0,0,0,255))
			DeleteLobby.color = defaultColor()
			DeleteLobby.lastCHColor = crossHairColor
			DeleteLobby.Paint = function()
				if (DeleteLobby.lastCHColor != crossHairColor) then
					DeleteLobby.color = defaultColor()
					DeleteLobby.lastCHColor = crossHairColor
				end	
				surface.SetDrawColor(DeleteLobby.color)
				surface.DrawRect( 0, 0, DeleteLobby:GetWide(), DeleteLobby:GetTall())
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, DeleteLobby:GetWide(), DeleteLobby:GetTall())
			end
			
			DeleteLobby.OnMousePressed = function() 
				DeleteLobby.color = clickColor()				
				DeleteLobby:DoClick()			
			end
			
			DeleteLobby.OnMouseReleased = function() 
				DeleteLobby.color = defaultColor()
			end
			
			DeleteLobby.OnCursorEntered = function() 
				DeleteLobby.color = hoverColor()
			end
			
			DeleteLobby.OnCursorExited = function() 
				DeleteLobby.color = defaultColor()
			end
			
			DeleteLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "0") end
		else
			local JoinLobby = vgui.Create("DButton", PlayerListFrame)
			JoinLobby:SetSize(280, 120)
			JoinLobby:SetPos(playerPos.x, playerPos.y)
			JoinLobby:SetText("Join Lobby")
			JoinLobby:SetTextColor(Color(0,0,0,255))
			JoinLobby.color = defaultColor()
			JoinLobby.lastCHColor = crossHairColor
			JoinLobby.Paint = function()
				if (JoinLobby.lastCHColor != crossHairColor) then
					JoinLobby.color = defaultColor()
					JoinLobby.lastCHColor = crossHairColor
				end	
				surface.SetDrawColor(JoinLobby.color)
				surface.DrawRect( 0, 0, JoinLobby:GetWide(), JoinLobby:GetTall())
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, JoinLobby:GetWide(), JoinLobby:GetTall())
			end
			
			JoinLobby.OnMousePressed = function() 
				JoinLobby.color = clickColor()				
				JoinLobby:DoClick()			
			end
			
			JoinLobby.OnMouseReleased = function() 
				JoinLobby.color = defaultColor()
			end
			
			JoinLobby.OnCursorEntered = function() 
				JoinLobby.color = hoverColor()
			end
			
			JoinLobby.OnCursorExited = function() 
				JoinLobby.color = defaultColor()
			end
			
			JoinLobby.DoClick = function() RunConsoleCommand("um_join_lobby", ply:GetNetworkedString("lobbyID"), passFieldCurText) end
		end
	end
end

updateLobbyList = function()
	for k,v in pairs (player.GetAll()) do
		if (v:GetNetworkedString("LobbyID") == v:SteamID()) then -- they own their lobby and a lobby button is theirs
			if (openLobbies[k] == nil) then -- we make the lobby
				local lobbyType = "Error"
				if (v:GetNetworkedInt("lobbyType") == 1) then
					lobbyType = "Hunted"
				elseif (v:GetNetworkedInt("lobbyType") == 2) then
					lobbyType = "Tag"
				elseif (v:GetNetworkedInt("lobbyType") == 3) then
					lobbyType = "Handicapped"
				elseif (v:GetNetworkedInt("lobbyType") == 4) then
					lobbyType = "Elimination"
				elseif (v:GetNetworkedInt("lobbyType") == 5) then
					lobbyType = "Miscellaneous"
				elseif (v:GetNetworkedInt("lobbyType") == 6) then
					lobbyType = "FreezeTag"
				elseif (v:GetNetworkedInt("lobbyType") == 7) then
					lobbyType = "DeathMatch"
				end

				openLobbies[k] = vgui.Create("DButton", LobbyButtonMenu)
				openLobbies[k]:SetSize(ScrW() - 640, 40)
				openLobbies[k]:SetPos(0, 0) -- temporary, we set this later on
				openLobbies[k]:SetText(v:Nick() .. "'s lobby of " .. lobbyType)
				openLobbies[k]:SetTextColor(Color(0,0,0,255))
				openLobbies[k].color = defaultColor()
				openLobbies[k].lastCHColor = crossHairColor
				openLobbies[k].Paint = function()
					if (openLobbies[k].lastCHColor != crossHairColor) then
						openLobbies[k].color = defaultColor()
						openLobbies[k].lastCHColor 	= crossHairColor
					end
					
					surface.SetDrawColor(openLobbies[k].color)
					surface.DrawRect( 0, 0, openLobbies[k]:GetWide(), openLobbies[k]:GetTall())
					surface.SetDrawColor( 0, 0, 0, 255 )
					surface.DrawOutlinedRect( 0, 0, openLobbies[k]:GetWide(), openLobbies[k]:GetTall())
							
					for n,m in pairs (player.GetAll()) do
						if (openLobbies[k]:GetText() == v:SteamID() && v:GetNetworkedString("lobbyID") != v:SteamID()) then
							openLobbies[k]:Close()
						end
					end
				end
				
				openLobbies[k].OnMousePressed = function() 
					openLobbies[k].color = clickColor()				
					openLobbies[k]:DoClick()			
				end
				
				openLobbies[k].OnMouseReleased = function() 
					openLobbies[k].color = defaultColor()
				end
				
				openLobbies[k].OnCursorEntered = function() 
					openLobbies[k].color = hoverColor()
				end
				  
				openLobbies[k].OnCursorExited = function() 
					openLobbies[k].color = defaultColor()
				end
				
				openLobbies[k].DoClick = function() 
					ply = v 
					lastUpdate = CurTime() - 10
				end	
			end
		elseif (openLobbies[k] != nil) then
			openLobbies[k]:Remove()
			openLobbies[k] = nil
		end
	end	
	
	local lobbyPos		= {}
	lobbyPos.x			= 0
	lobbyPos.y			= 0
	
	for k,v in pairs (openLobbies) do
		v:SetPos(lobbyPos.x, lobbyPos.y)		
		
		lobbyPos.y = lobbyPos.y + v:GetTall()
	end
end

updatePlayerList = function()
	print("bar2")

end