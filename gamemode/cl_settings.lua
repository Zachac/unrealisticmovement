print("Loaded cl_settings.lua")

ply = LocalPlayer()

local Settings

defaultColor = function()
	return (Color(crossHairColor.r, crossHairColor.g, crossHairColor.b, 200)) 
end

hoverColor = function() 
	local fixedColor = Color(crossHairColor.r - 55, crossHairColor.g - 55, crossHairColor.b - 55, 200)
	
	if (fixedColor.r < 0) then
		fixedColor.r = 0
	end
		
	if (fixedColor.g < 0) then
		fixedColor.g = 0
	end
		
	if (fixedColor.b < 0) then
		fixedColor.b = 0
	end
	
	return fixedColor
end

clickColor = function() 
	local fixedColor = Color(crossHairColor.r - 110, crossHairColor.g - 110, crossHairColor.b - 110, 200)
	
	if (fixedColor.r < 0) then
		fixedColor.r = 0
	end
		
	if (fixedColor.g < 0) then
		fixedColor.g = 0
	end
		
	if (fixedColor.b < 0) then
		fixedColor.b = 0
	end
	
	return fixedColor
end

optionColor = function() 
	local fixedColor = Color(crossHairColor.r - 55, crossHairColor.g - 55, crossHairColor.b - 55, 255)
	
	if (fixedColor.r < 0) then
		fixedColor.r = 0
	end
		
	if (fixedColor.g < 0) then
		fixedColor.g = 0
	end
		
	if (fixedColor.b < 0) then
		fixedColor.b = 0
	end
	
	return fixedColor
end



MakeSettingsMenu = function()
	Settings = vgui.Create("DFrame")
	Settings:SetSize(300, 195)
	Settings:SetPos((ScrW()/2) - (Settings:GetWide()/2), (ScrH()/2)  - (Settings:GetTall()/2))
	Settings:SetName("Settings")
	Settings:SetDraggable(true)
	Settings:ShowCloseButton(false)
	Settings:SetTitle("Settings")
	Settings:SetVisible(false)
	Settings:MakePopup()
	Settings.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 160 )
		surface.DrawRect( 0, 0, Settings:GetWide(), Settings:GetTall() )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, Settings:GetWide(), Settings:GetTall() )
	end
	
	
	
	local SetTrail = vgui.Create("DButton", Settings)
	SetTrail:SetPos(10, 25)
	SetTrail:SetSize( 280, 20 )
	SetTrail:SetText("Button")
	SetTrail:SetTextColor(Color(0,0,0,255))
	SetTrail.color = defaultColor()
	SetTrail.lastCHColor = crossHairColor
	SetTrail.Paint = function()
		if (SetTrail.lastCHColor != crossHairColor) then
			SetTrail.color = defaultColor()
			SetTrail.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(SetTrail.color)
		surface.DrawRect( 0, 0, SetTrail:GetWide(), SetTrail:GetTall())
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, SetTrail:GetWide(), SetTrail:GetTall())
	end
	
	SetTrail.OnMousePressed = function() 
		SetTrail.color = clickColor()				
		SetTrail:DoClick()			
	end
	
	SetTrail.OnMouseReleased = function() 
		SetTrail.color = defaultColor()
	end

	SetTrail.OnCursorEntered = function() 
		SetTrail.color = hoverColor()
	end
	
	SetTrail.OnCursorExited = function() 
		SetTrail.color = defaultColor()
	end

	SetTrail.DoClick = function() Settings:SetVisible(false) end
	
	
	
	
	local ToggleHud = vgui.Create("DButton", Settings)
	ToggleHud:SetPos(10, 45)
	ToggleHud:SetSize(280, 20)
	ToggleHud:SetText("Toggle Hud")
	ToggleHud:SetTextColor(Color(0,0,0,255))
	ToggleHud.color = defaultColor()
	ToggleHud.lastCHColor = crossHairColor
	ToggleHud.DoClick = function() shouldDrawHud = !shouldDrawHud end
	ToggleHud.Paint = function()
		if (ToggleHud.lastCHColor != crossHairColor) then
			ToggleHud.color = defaultColor()
			ToggleHud.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(ToggleHud.color)
		surface.DrawRect( 0, 0, ToggleHud:GetWide(), ToggleHud:GetTall() )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, ToggleHud:GetWide(), ToggleHud:GetTall() )
	end
	
	ToggleHud.OnMousePressed = function() 
		ToggleHud.color = clickColor()				
		ToggleHud:DoClick()			
	end
	
	ToggleHud.OnMouseReleased = function() 
		ToggleHud.color = defaultColor()
	end

	ToggleHud.OnCursorEntered = function() 
		ToggleHud.color = hoverColor()
	end

	ToggleHud.OnCursorExited = function() 
		ToggleHud.color = defaultColor()
	end
	
	
	
	local SpectateMenu = vgui.Create("DButton", Settings)
	SpectateMenu:SetText("Spectate")
	SpectateMenu:SetTextColor(Color(0,0,0,255))
	SpectateMenu:SetPos(10, 65)
	SpectateMenu:SetSize(280, 20)
	SpectateMenu.color = defaultColor()
	SpectateMenu.lastCHColor = crossHairColor
	SpectateMenu.Paint = function()
		if (SpectateMenu.lastCHColor != crossHairColor) then
			SpectateMenu.color = defaultColor()
			SpectateMenu.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(SpectateMenu.color)
		surface.DrawRect(0, 0, SpectateMenu:GetWide(), SpectateMenu:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, SpectateMenu:GetWide(), SpectateMenu:GetTall())
	end
	
	SpectateMenu.OnMousePressed = function() 
		SpectateMenu.color = clickColor()				
		SpectateMenu:DoClick()			
	end
	
	SpectateMenu.OnMouseReleased = function() 
		SpectateMenu.color = defaultColor()
	end
	
	SpectateMenu.OnCursorEntered = function() 
		SpectateMenu.color = hoverColor()
	end
	
	SpectateMenu.OnCursorExited = function() 
		SpectateMenu.color = defaultColor()
	end
	
	SpectateMenu.DoClick = function()
		local SpectateMenuOptions = DermaMenu()
		SpectateMenuOptions.Paint = function()
			surface.SetDrawColor(optionColor()) 
			surface.DrawRect(0, 0, SpectateMenuOptions:GetWide(), SpectateMenuOptions:GetTall())
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawOutlinedRect( 0, 0, SpectateMenuOptions:GetWide(), SpectateMenuOptions:GetTall())
		end
		
		for k,v in pairs(player.GetAll()) do
			if (v:Nick() != LocalPlayer():Nick()) then
				SpectateMenuOptions:AddOption(v:Nick(), function() RunConsoleCommand("um_Spectate", v:Nick()) end)
			end
		end
		SpectateMenuOptions:Open()
	end	

	
	
	local ModelMenu = vgui.Create("DButton", Settings)
	ModelMenu:SetText("Change Model")
	ModelMenu:SetTextColor(Color(0,0,0,255))
	ModelMenu.color = defaultColor()
	ModelMenu.lastCHColor = crossHairColor
	ModelMenu:SetPos(10, 85)
	ModelMenu:SetSize(280, 20)
	ModelMenu.Paint = function()
		if (ModelMenu.lastCHColor != crossHairColor) then
			ModelMenu.color = defaultColor()
			ModelMenu.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(ModelMenu.color)
		surface.DrawRect( 0, 0, ModelMenu:GetWide(), ModelMenu:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, ModelMenu:GetWide(), ModelMenu:GetTall())
	end
	
	ModelMenu.OnMousePressed = function() 
		ModelMenu.color = clickColor()				
		ModelMenu:DoClick()			
	end
	
	ModelMenu.OnMouseReleased = function() 
		ModelMenu.color = defaultColor()
	end

	ModelMenu.OnCursorEntered = function() 
		ModelMenu.color = hoverColor()
	end

	ModelMenu.OnCursorExited = function() 
		ModelMenu.color = defaultColor()
	end

	ModelMenu.DoClick = function()
		local ModelMenuOptions = DermaMenu()
		ModelMenuOptions.Paint = function()
			surface.SetDrawColor(optionColor()) 
			surface.DrawRect(0, 0, ModelMenuOptions:GetWide(), ModelMenuOptions:GetTall())
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawOutlinedRect( 0, 0, ModelMenuOptions:GetWide(), ModelMenuOptions:GetTall())
		end
		ModelMenuOptions:AddOption("Alyx", function() RunConsoleCommand("cl_playermodel", "alyx") end)
		ModelMenuOptions:AddOption("Barney", function() RunConsoleCommand("cl_playermodel", "barney") end)
		ModelMenuOptions:AddOption("Burnt Corpse", function() RunConsoleCommand("cl_playermodel", "charple") end)
		ModelMenuOptions:AddOption("Corpse", function() RunConsoleCommand("cl_playermodel", "corpse") end)
		ModelMenuOptions:AddOption("Combine Soldier", function() RunConsoleCommand("cl_playermodel", "combine") end)
		ModelMenuOptions:AddOption("Prison Guard", function() RunConsoleCommand("cl_playermodel", "combineprison") end)
		ModelMenuOptions:AddOption("Combine Super", function() RunConsoleCommand("cl_playermodel", "combineelite") end)
		ModelMenuOptions:AddOption("Eli", function() RunConsoleCommand("cl_playermodel", "eli") end)
		ModelMenuOptions:AddOption("Gman", function() RunConsoleCommand("cl_playermodel", "gman") end)
		ModelMenuOptions:AddOption("Kleiner", function() RunConsoleCommand("cl_playermodel", "kleiner") end)
		ModelMenuOptions:AddOption("Father Grigori", function() RunConsoleCommand("cl_playermodel", "monk") end)
		ModelMenuOptions:AddOption("Magnusson", function() RunConsoleCommand("cl_playermodel", "magnusson") end)
		ModelMenuOptions:AddOption("Mossman", function() RunConsoleCommand("cl_playermodel", "mossman") end)
		ModelMenuOptions:AddOption("Odessa", function() RunConsoleCommand("cl_playermodel", "odessa") end)
		ModelMenuOptions:AddOption("Stripped Soldier", function() RunConsoleCommand("cl_playermodel", "stripped") end)
		ModelMenuOptions:AddOption("Zombie Soldier", function() RunConsoleCommand("cl_playermodel", "models/player/zombie_soldier.mdl") end)
		ModelMenuOptions:AddOption("Zombie", function() RunConsoleCommand("cl_playermodel", "zombie") end)
		ModelMenuOptions:AddOption("Fast Zombie", function() RunConsoleCommand("cl_playermodel", "zombiefast") end)
		ModelMenuOptions:AddOption("Male 1", function() RunConsoleCommand("cl_playermodel", "male01") end)
		ModelMenuOptions:AddOption("Male 2", function() RunConsoleCommand("cl_playermodel", "male02") end)
		ModelMenuOptions:AddOption("Male 3", function() RunConsoleCommand("cl_playermodel", "male03") end)
		ModelMenuOptions:AddOption("Male 4", function() RunConsoleCommand("cl_playermodel", "male04") end)
		ModelMenuOptions:AddOption("Male 5", function() RunConsoleCommand("cl_playermodel", "male05") end)
		ModelMenuOptions:AddOption("Male 6", function() RunConsoleCommand("cl_playermodel", "male06") end)
		ModelMenuOptions:AddOption("Male 7", function() RunConsoleCommand("cl_playermodel", "male07") end)
		ModelMenuOptions:AddOption("Male 8", function() RunConsoleCommand("cl_playermodel", "male08") end)
		ModelMenuOptions:AddOption("Male 9", function() RunConsoleCommand("cl_playermodel", "male09") end)
		ModelMenuOptions:AddOption("Female 1", function() RunConsoleCommand("cl_playermodel", "female01") end)
		ModelMenuOptions:AddOption("Female 2", function() RunConsoleCommand("cl_playermodel", "female02") end)
		ModelMenuOptions:AddOption("Female 3", function() RunConsoleCommand("cl_playermodel", "female03") end)
		ModelMenuOptions:AddOption("Female 4", function() RunConsoleCommand("cl_playermodel", "female04") end)
		ModelMenuOptions:AddOption("Female 5", function() RunConsoleCommand("cl_playermodel", "female05") end)
		ModelMenuOptions:AddOption("Female 6", function() RunConsoleCommand("cl_playermodel", "female06") end)
		ModelMenuOptions:Open()
	end
	
	
	
	local GunMenu = vgui.Create("DButton", Settings)
	GunMenu:SetText("Get Weapons")
	GunMenu:SetTextColor(Color(0,0,0,255))
	GunMenu.color = defaultColor()
	GunMenu.lastCHColor = crossHairColor
	GunMenu:SetPos(10, 105)
	GunMenu:SetSize( 140, 20 )
	GunMenu.Paint = function()
		if (GunMenu.lastCHColor != crossHairColor) then
			GunMenu.color = defaultColor()
			GunMenu.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(GunMenu.color)
		surface.DrawRect( 0, 0, GunMenu:GetWide(), GunMenu:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, GunMenu:GetWide(), GunMenu:GetTall())
	end
	
	GunMenu.OnMousePressed = function() 
		GunMenu.color = clickColor()				
		GunMenu:DoClick()			
	end

	GunMenu.OnMouseReleased = function() 
		GunMenu.color = defaultColor()
	end

	GunMenu.OnCursorEntered = function() 
		GunMenu.color = hoverColor()
	end

	GunMenu.OnCursorExited = function() 
		GunMenu.color = defaultColor()
	end

	GunMenu.DoClick = function()
		local GunMenuOptions = DermaMenu()
		GunMenuOptions.Paint = function()
			surface.SetDrawColor(optionColor()) 
			surface.DrawRect(0, 0, GunMenuOptions:GetWide(), GunMenuOptions:GetTall())
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawOutlinedRect( 0, 0, GunMenuOptions:GetWide(), GunMenuOptions:GetTall())
		end
		GunMenuOptions:AddOption("Crowbar", function() RunConsoleCommand("um_get_gun", "weapon_crowbar") end)
		GunMenuOptions:AddOption("Physcannon", function() RunConsoleCommand("um_get_gun", "weapon_physcannon") end)
		GunMenuOptions:Open()
	end	
	
	
	
    local StripWeaponsButton = vgui.Create("DButton", Settings)
	StripWeaponsButton:SetPos(150, 105)
	StripWeaponsButton:SetSize(140, 20)
	StripWeaponsButton:SetText("Remove Weapons")
	StripWeaponsButton:SetTextColor(Color(0,0,0,255))
	StripWeaponsButton.color = defaultColor()
	StripWeaponsButton.lastCHColor = crossHairColor
	StripWeaponsButton.Paint = function()
		if (StripWeaponsButton.lastCHColor != crossHairColor) then
			StripWeaponsButton.color = defaultColor()
			StripWeaponsButton.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(StripWeaponsButton.color)
		surface.DrawRect( 0, 0, StripWeaponsButton:GetWide(), StripWeaponsButton:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, StripWeaponsButton:GetWide(), StripWeaponsButton:GetTall())
	end
	
	StripWeaponsButton.OnMousePressed = function() 
		StripWeaponsButton.color = clickColor()				
		StripWeaponsButton:DoClick()			
	end
	
	StripWeaponsButton.OnMouseReleased = function() 
		StripWeaponsButton.color = defaultColor()
	end

	StripWeaponsButton.OnCursorEntered = function() 
		StripWeaponsButton.color = hoverColor()
	end

	StripWeaponsButton.OnCursorExited = function() 
		StripWeaponsButton.color = defaultColor()
	end

	StripWeaponsButton.DoClick = function() RunConsoleCommand("um_remove_guns") end



	
	local GetBall = vgui.Create("DButton", Settings)
	GetBall:SetPos(10, 125)
	GetBall:SetSize(140, 20)
	GetBall:SetText("Get Ball")
	GetBall:SetTextColor(Color(0,0,0,255))
	GetBall.color = defaultColor()
	GetBall.lastCHColor = crossHairColor
	GetBall.Paint = function()
		if (GetBall.lastCHColor != crossHairColor) then
			GetBall.color = defaultColor()
			GetBall.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(GetBall.color)
		surface.DrawRect(0, 0, GetBall:GetWide(), GetBall:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect(0, 0, GetBall:GetWide(), GetBall:GetTall())
	end
	
	GetBall.OnMousePressed = function() 
		GetBall.color = clickColor()				
		GetBall:DoClick()			
	end

	GetBall.OnMouseReleased = function() 
		GetBall.color = defaultColor()
	end

	GetBall.OnCursorEntered = function() 
		GetBall.color = hoverColor()
	end

	GetBall.OnCursorExited = function() 
		GetBall.color = defaultColor()
	end

	GetBall.DoClick = function() RunConsoleCommand("um_get_ball") end



	
	local RemoveBall = vgui.Create("DButton", Settings)
	RemoveBall:SetPos(150, 125)
	RemoveBall:SetSize(140, 20)
	RemoveBall:SetText("Remove Ball")
	RemoveBall:SetTextColor(Color(0,0,0,255))
	RemoveBall.color = defaultColor()
	RemoveBall.lastCHColor = crossHairColor
	RemoveBall.Paint = function()
		if (RemoveBall.lastCHColor != crossHairColor) then
			RemoveBall.color = defaultColor()
			RemoveBall.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(RemoveBall.color)
		surface.DrawRect(0, 0, RemoveBall:GetWide(), RemoveBall:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, RemoveBall:GetWide(), RemoveBall:GetTall())
	end
	
	RemoveBall.OnMousePressed = function() 
		RemoveBall.color = clickColor()				
		RemoveBall:DoClick()			
	end

	RemoveBall.OnMouseReleased = function() 
		RemoveBall.color = defaultColor()
	end

	RemoveBall.OnCursorEntered = function() 
		RemoveBall.color = hoverColor()
	end

	RemoveBall.OnCursorExited = function() 
		RemoveBall.color = defaultColor()
	end

	RemoveBall.DoClick = function() RunConsoleCommand("um_remove_ball") end	
	

	
	local ToggleThird = vgui.Create("DButton", Settings)
	ToggleThird:SetPos(10, 145)
	ToggleThird:SetSize(280, 20)
	ToggleThird:SetText("Toggle Third Person")
	ToggleThird:SetTextColor(Color(0,0,0,255))
	ToggleThird.color = defaultColor()
	ToggleThird.lastCHColor = crossHairColor
	ToggleThird.Paint = function()
		if (ToggleThird.lastCHColor != crossHairColor) then
			ToggleThird.color = defaultColor()
			ToggleThird.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(ToggleThird.color)
		surface.DrawRect(0, 0, ToggleThird:GetWide(), ToggleThird:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, ToggleThird:GetWide(), ToggleThird:GetTall())
	end
	
	ToggleThird.OnMousePressed = function() 
		ToggleThird.color = clickColor()				
		ToggleThird:DoClick()			
	end
	
	ToggleThird.OnMouseReleased = function() 
		ToggleThird.color = defaultColor()
	end
	
	ToggleThird.OnCursorEntered = function() 
		ToggleThird.color = hoverColor()
	end

	ToggleThird.OnCursorExited = function() 
		ToggleThird.color = defaultColor()
	end

	ToggleThird.DoClick = function() shouldThird = !shouldThird end	

	
	
	local SelectMode = vgui.Create("DButton", Settings)
	SelectMode:SetPos(10, 165)
	SelectMode:SetSize(280, 20)
	SelectMode:SetText("Select Move Mode")
	SelectMode:SetTextColor(Color(0,0,0,255))
	SelectMode.color = defaultColor()
	SelectMode.lastCHColor = crossHairColor
	SelectMode.Paint = function()
		if (SelectMode.lastCHColor != crossHairColor) then
			SelectMode.color = defaultColor()
			SelectMode.lastCHColor = crossHairColor
		end	
		surface.SetDrawColor(SelectMode.color)
		surface.DrawRect(0, 0, SelectMode:GetWide(), SelectMode:GetTall())
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect( 0, 0, SelectMode:GetWide(), SelectMode:GetTall())
	end
	
	SelectMode.OnMousePressed = function() 
		SelectMode.color = clickColor()				
		SelectMode:DoClick()			
	end
	
	SelectMode.OnMouseReleased = function() 
		SelectMode.color = defaultColor()
	end
	
	SelectMode.OnCursorEntered = function() 
		SelectMode.color = hoverColor()
	end

	SelectMode.OnCursorExited = function() 
		SelectMode.color = defaultColor()
	end

	SelectMode.DoClick = function() 
		local SelectModeOptions = DermaMenu()
		SelectModeOptions.Paint = function()
			surface.SetDrawColor(optionColor()) 
			surface.DrawRect(0, 0, SelectModeOptions:GetWide(), SelectModeOptions:GetTall())
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawOutlinedRect( 0, 0, SelectModeOptions:GetWide(), SelectModeOptions:GetTall())
		end
		SelectModeOptions:AddOption("Parkour", function() RunConsoleCommand("um_move_mode", "1") end)
		SelectModeOptions:AddOption("Spiderman", function() RunConsoleCommand("um_move_mode", "0") end)
		SelectModeOptions:AddOption("Hover", function() RunConsoleCommand("um_move_mode", "2") end)
		SelectModeOptions:AddOption("Auto Hop", function() RunConsoleCommand("um_move_mode", "3") end)
		SelectModeOptions:AddOption("Pogo", function() RunConsoleCommand("um_move_mode", "4") end)
		SelectModeOptions:Open()
	end	
end

MakeSettingsMenu()

function GM:OnContextMenuOpen()
     Settings:SetVisible(true)
end

function GM:OnContextMenuClose()
     Settings:SetVisible(false)
end
