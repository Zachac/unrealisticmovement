print("Loaded cl_lobbies_menu.lua")
LobbyMenu				= NULL
local lastTimeQDown 	= false
local initialized	 	= false
local updateCD 			= 10
local lastUpdate		= CurTime() - 10
local lastLobbyList		= 0
local ply				= LocalPlayer()				-- doesn't actually do anything as local player is not valid right now
passFieldCurText		= "Password"				
shouldUpdateColors 		= false

makeLobbyMenu = function()
	LobbyMenu = vgui.Create("DFrame")
	LobbyMenu:SetSize(ScrW(), ScrH())
	LobbyMenu:SetPos(10,10)
	LobbyMenu:SetName("LobbyMenu")
	LobbyMenu:SetTitle("")
	LobbyMenu:SetDraggable(false)
	LobbyMenu:ShowCloseButton(false)
	LobbyMenu:SetVisible(false)
	LobbyMenu:SetBackgroundBlur(true)
	LobbyMenu:MakePopup()
	LobbyMenu.Paint = function()
		surface.SetDrawColor(Color(0, 0, 0, 0))
		surface.DrawRect(0, 0, LobbyMenu:GetWide(), LobbyMenu:GetTall())
	end
		
	LobbyMenu.Think = function()
		// used to be stuff here...
	end
	
	
	
	local MakeHuntedLobby = vgui.Create("DButton", LobbyMenu)
	MakeHuntedLobby:SetSize(280, 80)
	MakeHuntedLobby:SetPos(20, 20)
	MakeHuntedLobby:SetText("Hunted")
	MakeHuntedLobby:SetTextColor(Color(0,0,0,255))
	MakeHuntedLobby.color = defaultColor()
	MakeHuntedLobby.lastCHColor = crossHairColor
	MakeHuntedLobby.Paint = function()
		if (MakeHuntedLobby.lastCHColor != crossHairColor) then
			MakeHuntedLobby.color = defaultColor()
			MakeHuntedLobby.lastCHColor = crossHairColor
		end							
		surface.SetDrawColor(MakeHuntedLobby.color)
		surface.DrawRect( 0, 0, MakeHuntedLobby:GetWide(), MakeHuntedLobby:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, MakeHuntedLobby:GetWide(), MakeHuntedLobby:GetTall())
						
	end
	
	MakeHuntedLobby.OnMousePressed = function() 
		MakeHuntedLobby.color = clickColor()				
		MakeHuntedLobby:DoClick()			
	end
	
	 MakeHuntedLobby.OnMouseReleased = function() 
		MakeHuntedLobby.color = defaultColor()
	end
	
	MakeHuntedLobby.OnCursorEntered = function() 
		MakeHuntedLobby.color = hoverColor()
	end

	MakeHuntedLobby.OnCursorExited = function() 
		MakeHuntedLobby.color = defaultColor()
	end

	MakeHuntedLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "1") end

	
	
	
	local MakeTagLobby = vgui.Create("DButton", LobbyMenu)
	MakeTagLobby:SetSize(280, 80)
	MakeTagLobby:SetPos(20, 100)
	MakeTagLobby:SetText("Tag")
	MakeTagLobby:SetTextColor(Color(0,0,0,255))
	MakeTagLobby.color = defaultColor()
	MakeTagLobby.lastCHColor = crossHairColor
	MakeTagLobby.Paint = function()
		if (MakeTagLobby.lastCHColor != crossHairColor) then
			MakeTagLobby.color = defaultColor()
			MakeTagLobby.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(MakeTagLobby.color)
		surface.DrawRect( 0, 0, MakeTagLobby:GetWide(), MakeTagLobby:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, MakeTagLobby:GetWide(), MakeTagLobby:GetTall())
	end
	
	MakeTagLobby.OnMousePressed = function() 
		MakeTagLobby.color = clickColor()				
		MakeTagLobby:DoClick()			
	end
	
	 MakeTagLobby.OnMouseReleased = function() 
		MakeTagLobby.color = defaultColor()
	end
	
	MakeTagLobby.OnCursorEntered = function() 
		MakeTagLobby.color = hoverColor()
	end

	MakeTagLobby.OnCursorExited = function() 
		MakeTagLobby.color = defaultColor()
	end

	MakeTagLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "2") end
		

		
	local MakeHandicappedLobby = vgui.Create("DButton", LobbyMenu)
	MakeHandicappedLobby:SetSize(280, 80)
	MakeHandicappedLobby:SetPos(20, 180)
	MakeHandicappedLobby:SetText("Handicapped")
	MakeHandicappedLobby:SetTextColor(Color(0,0,0,255))
	MakeHandicappedLobby.color = defaultColor()
	MakeHandicappedLobby.lastCHColor = crossHairColor
	MakeHandicappedLobby.Paint = function()
		if (MakeHandicappedLobby.lastCHColor != crossHairColor) then
			MakeHandicappedLobby.color = defaultColor()
			MakeHandicappedLobby.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(MakeHandicappedLobby.color)
		surface.DrawRect( 0, 0, MakeHandicappedLobby:GetWide(), MakeHandicappedLobby:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, MakeHandicappedLobby:GetWide(), MakeHandicappedLobby:GetTall())
	end
	
	MakeHandicappedLobby.OnMousePressed = function() 
		MakeHandicappedLobby.color = clickColor()				
		MakeHandicappedLobby:DoClick()			
	end
	
	 MakeHandicappedLobby.OnMouseReleased = function() 
		MakeHandicappedLobby.color = defaultColor()
	end
	
	MakeHandicappedLobby.OnCursorEntered = function() 
		MakeHandicappedLobby.color = hoverColor()
	end

	MakeHandicappedLobby.OnCursorExited = function() 
		MakeHandicappedLobby.color = defaultColor()
	end

	MakeHandicappedLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "3") end	
	
	
	
	local MakeEliminationLobby = vgui.Create("DButton", LobbyMenu)
	MakeEliminationLobby:SetSize(280, 80)
	MakeEliminationLobby:SetPos(20, 260)
	MakeEliminationLobby:SetText("Elimination")
	MakeEliminationLobby:SetTextColor(Color(0,0,0,255))
	MakeEliminationLobby.color = defaultColor()
	MakeEliminationLobby.lastCHColor = crossHairColor
	MakeEliminationLobby.Paint = function()
		if (MakeEliminationLobby.lastCHColor != crossHairColor) then
			MakeEliminationLobby.color = defaultColor()
			MakeEliminationLobby.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(MakeEliminationLobby.color)
		surface.DrawRect( 0, 0, MakeEliminationLobby:GetWide(), MakeEliminationLobby:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, MakeEliminationLobby:GetWide(), MakeEliminationLobby:GetTall())
	end
	
	MakeEliminationLobby.OnMousePressed = function() 
		MakeEliminationLobby.color = clickColor()				
		MakeEliminationLobby:DoClick()			
	end
	
	 MakeEliminationLobby.OnMouseReleased = function() 
		MakeEliminationLobby.color = defaultColor()
	end
	
	MakeEliminationLobby.OnCursorEntered = function() 
		MakeEliminationLobby.color = hoverColor()
	end

	MakeEliminationLobby.OnCursorExited = function() 
		MakeEliminationLobby.color = defaultColor()
	end

	MakeEliminationLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "4") end	
	
	
	
	local MakeMiscLobby = vgui.Create("DButton", LobbyMenu)
	MakeMiscLobby:SetSize(280, 80)
	MakeMiscLobby:SetPos(20, 340)
	MakeMiscLobby:SetText("Miscellaneous")
	MakeMiscLobby:SetTextColor(Color(0,0,0,255))
	MakeMiscLobby.color = defaultColor()
	MakeMiscLobby.lastCHColor = crossHairColor
	MakeMiscLobby.Paint = function()
		if (MakeMiscLobby.lastCHColor != crossHairColor) then
			MakeMiscLobby.color = defaultColor()
			MakeMiscLobby.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(MakeMiscLobby.color)
		surface.DrawRect( 0, 0, MakeMiscLobby:GetWide(), MakeMiscLobby:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, MakeMiscLobby:GetWide(), MakeMiscLobby:GetTall())
	end
	
	MakeMiscLobby.OnMousePressed = function() 
		MakeMiscLobby.color = clickColor()				
		MakeMiscLobby:DoClick()			
	end
	
	 MakeMiscLobby.OnMouseReleased = function() 
		MakeMiscLobby.color = defaultColor()
	end
	
	MakeMiscLobby.OnCursorEntered = function() 
		MakeMiscLobby.color = hoverColor()
	end

	MakeMiscLobby.OnCursorExited = function() 
		MakeMiscLobby.color = defaultColor()
	end

	MakeMiscLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "5") end	
	
	
	
	local MakeFTLobby = vgui.Create("DButton", LobbyMenu)
	MakeFTLobby:SetSize(280, 80)
	MakeFTLobby:SetPos(20, 420)
	MakeFTLobby:SetText("FreezeTag")
	MakeFTLobby:SetTextColor(Color(0,0,0,255))
	MakeFTLobby.color = defaultColor()
	MakeFTLobby.lastCHColor = crossHairColor
	MakeFTLobby.Paint = function()
		if (MakeFTLobby.lastCHColor != crossHairColor) then
			MakeFTLobby.color = defaultColor()
			MakeFTLobby.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(MakeFTLobby.color)
		surface.DrawRect( 0, 0, MakeFTLobby:GetWide(), MakeFTLobby:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, MakeFTLobby:GetWide(), MakeFTLobby:GetTall())
	end
	
	MakeFTLobby.OnMousePressed = function() 
		MakeFTLobby.color = clickColor()				
		MakeFTLobby:DoClick()			
	end
	
	 MakeFTLobby.OnMouseReleased = function() 
		MakeFTLobby.color = defaultColor()
	end
	
	MakeFTLobby.OnCursorEntered = function() 
		MakeFTLobby.color = hoverColor()
	end

	MakeFTLobby.OnCursorExited = function() 
		MakeFTLobby.color = defaultColor()
	end

	MakeFTLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "6") end		
	
	
	local MakeDMLobby = vgui.Create("DButton", LobbyMenu)
	MakeDMLobby:SetSize(280, 80)
	MakeDMLobby:SetPos(20, 500)
	MakeDMLobby:SetText("DeathMatch")
	MakeDMLobby:SetTextColor(Color(0,0,0,255))
	MakeDMLobby.color = defaultColor()
	MakeDMLobby.lastCHColor = crossHairColor
	MakeDMLobby.Paint = function()
		if (MakeDMLobby.lastCHColor != crossHairColor) then
			MakeDMLobby.color = defaultColor()
			MakeDMLobby.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(MakeDMLobby.color)
		surface.DrawRect( 0, 0, MakeDMLobby:GetWide(), MakeDMLobby:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, MakeDMLobby:GetWide(), MakeDMLobby:GetTall())
	end
	
	MakeDMLobby.OnMousePressed = function() 
		MakeDMLobby.color = clickColor()				
		MakeDMLobby:DoClick()			
	end
	
	 MakeDMLobby.OnMouseReleased = function() 
		MakeDMLobby.color = defaultColor()
	end
	
	MakeDMLobby.OnCursorEntered = function() 
		MakeDMLobby.color = hoverColor()
	end

	MakeDMLobby.OnCursorExited = function() 
		MakeDMLobby.color = defaultColor()
	end

	MakeDMLobby.DoClick = function() RunConsoleCommand("um_make_lobby", "7") end		
	
	
	local ShowLobbySettings = vgui.Create("DButton", LobbyMenu)
	ShowLobbySettings:SetSize(280, 80)
	ShowLobbySettings:SetPos(20, 580)
	ShowLobbySettings:SetText("More Options")
	ShowLobbySettings:SetTextColor(Color(0,0,0,255))
	ShowLobbySettings.color = defaultColor()
	ShowLobbySettings.lastCHColor = crossHairColor
	ShowLobbySettings.Paint = function()
		if (ShowLobbySettings.lastCHColor != crossHairColor) then
			ShowLobbySettings.color = defaultColor()
			ShowLobbySettings.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(ShowLobbySettings.color)
		surface.DrawRect( 0, 0, ShowLobbySettings:GetWide(), ShowLobbySettings:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, ShowLobbySettings:GetWide(), ShowLobbySettings:GetTall())
	end
	
	ShowLobbySettings.OnMousePressed = function() 
		ShowLobbySettings.color = clickColor()				
		ShowLobbySettings:DoClick()			
	end
	
	 ShowLobbySettings.OnMouseReleased = function() 
		ShowLobbySettings.color = defaultColor()
	end
	
	ShowLobbySettings.OnCursorEntered = function() 
		ShowLobbySettings.color = hoverColor()
	end

	ShowLobbySettings.OnCursorExited = function() 
		ShowLobbySettings.color = defaultColor()
	end

	ShowLobbySettings.DoClick = function() LobbySettings:SetVisible(true) end	
end

hook.Add("Think", "show lobby menu", function()
	--LobbyMenu:SetVisible(input.IsKeyDown(KEY_Q))
	
	if (!initialized) then
		initialized = true
		makeLobbyMenu()
		initializeLobbys()
		initializePlayerList()
	end
	
	local curLobbyList	= 0
	
	for k,v in pairs (player.GetAll()) do
		if (v:GetNetworkedString("LobbyID") != "") then
			curLobbyList = curLobbyList + 1
		end
	end	
	
	if (curLobbyList != lastLobbyList) then
		updateLobbyList()
		updatePlayerList()
	end
	
	lastLobbyList = curLobbyList
end)

function GM:OnSpawnMenuOpen()
	LobbyMenu:SetVisible(true)
end

function GM:OnSpawnMenuClose()
	LobbyMenu:SetVisible(false)
end

--chat.AddText(Color(0,100,255,255), LocalPlayer():Nick(), Color(255,255,255,255), "has made a" , Color(0,100,255,255), "Hunted", Color(255,255,255,255), "lobby")