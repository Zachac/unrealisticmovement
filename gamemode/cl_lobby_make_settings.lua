print("Loaded cl_lobby_make_Settings.lua")

LobbySettings = NULL

makeLobbySettingsMenu = function()
	LobbySettings = vgui.Create("DFrame")
	LobbySettings:SetSize(150, 135)
	LobbySettings:SetPos((ScrW()/2) - (LobbySettings:GetWide()/2), (ScrH()/2)  - (LobbySettings:GetTall()/2))
	LobbySettings:SetName("Lobby Settings")
	LobbySettings:SetDraggable(true)
	LobbySettings:ShowCloseButton(false)
	LobbySettings:SetTitle("Lobby Settings")
	LobbySettings:SetVisible(false)
	LobbySettings:MakePopup()
	LobbySettings.Paint = function()
		surface.SetDrawColor(Color(100, 100, 100, 160))
		surface.DrawRect( 0, 0, LobbySettings:GetWide(), LobbySettings:GetTall() )
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, LobbySettings:GetWide(), LobbySettings:GetTall() )
		surface.DrawOutlinedRect( 0, 25, LobbySettings:GetWide(), 0)
	end
	
	
	local CloseButton = vgui.Create("DButton", LobbySettings)
	CloseButton:SetPos(LobbySettings:GetWide() - 55, 5)
	CloseButton:SetSize( 50, 15 )
	CloseButton:SetText("Close")
	CloseButton:SetTextColor(Color(0,0,0,255))
	CloseButton.DoClick = function() LobbySettings:SetVisible(false) end
	
	ToggleLava = vgui.Create("DCheckBoxLabel", LobbySettings)
	ToggleLava:SetPos(20, 30)
	ToggleLava:SetSize(20, 20)
	ToggleLava:SetText("Floor is Lava")
	ToggleLava:SizeToContents()	
	
	MovementMode = vgui.Create("DComboBox", LobbySettings)
	MovementMode:SetPos(20, 45)
	MovementMode:SetSize(110, 20)
	MovementMode:SetValue("Parkour")
	MovementMode:AddChoice("Parkour")
	MovementMode:AddChoice("Spiderman")
	MovementMode:AddChoice("Hover")
	MovementMode:AddChoice("Auto Hop")
	--MovementMode:AddChoice("Pogo")
			
	LobbyTypeChoice = vgui.Create("DComboBox", LobbySettings)
	LobbyTypeChoice:SetPos(20, 65)
	LobbyTypeChoice:SetSize(110, 20)
	LobbyTypeChoice:SetValue("Hunted")
	LobbyTypeChoice:AddChoice("Hunted")
	LobbyTypeChoice:AddChoice("Tag")
	LobbyTypeChoice:AddChoice("Handicapped")
	LobbyTypeChoice:AddChoice("Elimination")
	LobbyTypeChoice:AddChoice("Miscellaneous")
	LobbyTypeChoice:AddChoice("FreezeTag")
	LobbyTypeChoice:AddChoice("DeathMatch")
		
	PasswordEntry = vgui.Create("DTextEntry", LobbySettings)
	PasswordEntry:SetPos(20, 85)
	PasswordEntry:SetSize(110, 20)
	PasswordEntry:SetValue("Password")
			
	MakeLobby = vgui.Create("DButton", LobbySettings)
	MakeLobby:SetPos(20, 105)
	MakeLobby:SetSize(110, 20)
	MakeLobby:SetText("Make Lobby")
	MakeLobby.DoClick = function()
		local lobbyType		= "1"		-- hunted
		local password 		= ""		-- no password
		local floorIsLava 	= "0"		-- not lava
		local movementMode 	= "0"		-- Spiderman
		
		if (LobbyTypeChoice:GetValue() == "Hunted") then
			lobbyType 	= "1"
		elseif (LobbyTypeChoice:GetValue() == "Tag") then
			lobbyType 	= "2"
		elseif (LobbyTypeChoice:GetValue() == "Handicapped") then
			lobbyType 	= "3"
		elseif (LobbyTypeChoice:GetValue() == "Elimination") then
			lobbyType 	= "4"
		elseif (LobbyTypeChoice:GetValue() == "Miscellaneous") then
			lobbyType 	= "5"
		elseif (LobbyTypeChoice:GetValue() == "FreezeTag") then
			lobbyType 	= "6"
		elseif (LobbyTypeChoice:GetValue() == "DeathMatch") then
			lobbyType 	= "7"
		end
					
		if (PasswordEntry:GetValue() != "Password") then
			password 	= PasswordEntry:GetValue()
		end
					
		if (ToggleLava:GetChecked()) then
			floorIsLava 	= "1"
		end
		
		if (MovementMode:GetValue() == "Spiderman") then
			movementMode 	= "0"
		elseif (MovementMode:GetValue() == "Hover") then
			movementMode 	= "2"
		elseif (MovementMode:GetValue() == "Auto Hop") then
			movementMode 	= "3"
		elseif (MovementMode:GetValue() == "Pogo") then
			movementMode 	= "4"
		else
			movementMode 	= "1"
		end
	
		passFieldCurText = PasswordEntry:GetValue()
		RunConsoleCommand("um_make_lobby", lobbyType, password, floorIsLava, movementMode)
		LobbySettings:SetVisible(false)
	end
end


makeLobbySettingsMenu()