print("Loaded cl_hud.lua")

local nextTime 		= 0
local average 		= 0
local numSpeeds		= 0
local totalSpeed	= 0
local topSpeed		= 0
local speedCalcMod	= 0
local hBarLength	= 0
local hBarColor		= Color(0, 255, 0, 255)
local speedBar 		= Color(100, 0, 100, 255)
local roundSpeed	= 0
local aBarLength	= 0
local ammoBarColor	= Color(255, 0, 0, 255)
local curClip		= 0
local extraClip		= 0
local altCurClip	= 0
local altExtraClip	= 0
local radius		= 400				-- distance to show indicators on the circle
local teamType		= ""
shouldThird			= false
shouldDrawHud 		= 0
crossHairColor		= Color(255, 255, 255, 200)


hook.Add("HUDPaint", "parkour hud", function()
	if (!shouldDrawHud) then
		return
	end
	
	crossHairColor = team.GetColor(ply:Team())
	
	-- are they spectating? if so use the spectator
	if (LocalPlayer():GetObserverTarget()!= nil) then
		ply = LocalPlayer():GetObserverTarget()
	else
		ply = LocalPlayer()
	end

	
	
	
	local speed = ply:GetVelocity():Length()/10
	
	-- update the average speed
	if (CurTime() >= nextTime) then
		if (speed > 10) then
			totalSpeed 	= speed + totalSpeed
			numSpeeds	= numSpeeds + 1
			average 	= totalSpeed/numSpeeds
			nextTime 	= CurTime() + 1
		else -- reset average
			totalSpeed 	= 0
			numSpeeds 	= 0
			average 	= 0
		end
	end
	
	-- top speed check
	if (speed > topSpeed) then
		topSpeed = speed
		topSpeed = math.Round(topSpeed)
	end
	
	fakeAverage = math.Round(average, -1)
	roundSpeed 	= math.Round(speed, -1)
	
	-- speed
	draw.SimpleText(roundSpeed, "TargetIDSmall", ScrW()/2, (ScrH()/2) -30,  crossHairColor, TEXT_ALIGN_CENTER)
		
	-- average
	draw.SimpleText(fakeAverage, "TargetIDSmall", ScrW()/2, (ScrH()/2) + 16,  crossHairColor, TEXT_ALIGN_CENTER)
	
	-- top Speed
	draw.SimpleText("Top Speed: " .. topSpeed, "TargetIDSmall", ScrW()/2, ScrH() - 105,  crossHairColor, TEXT_ALIGN_CENTER)
	
	-- crosshair
	draw.SimpleText("[  ]", "TargetIDSmall", ScrW()/2, ScrH()/2 - 7, crossHairColor, TEXT_ALIGN_CENTER)
	draw.SimpleText(".", "TargetIDSmall", ScrW()/2, ScrH()/2 - 10, crossHairColor, TEXT_ALIGN_CENTER)

	-- team
	if (team.GetName(ply:Team()) != "None") then
		draw.SimpleText("You are a: " .. team.GetName(ply:Team()), "TargetID", 30, 10, crossHairColor, TEXT_ALIGN_LEFT)
	end
	
	-- health bar
	draw.RoundedBoxEx(0, 30, ScrH()-90, 300, 30, Color(0, 0, 0, 145), false, false, false, false)
	if (ply:Health() > 0) then
		draw.RoundedBoxEx(0, 32, ScrH()-88, (ply:Health()/100)*296, 26, crossHairColor, false, false, false, false)
	end

	draw.SimpleText(ply:Health() .. "/100", "TargetID", 38, ScrH() - 83, Color(255,255,255,200))
	
	-- speed bar
	speedCalcMod = 296 - (296 * speed / 500)
	
	draw.RoundedBoxEx(0, ScrW() - 330, ScrH()-90, 300, 30, Color(0, 0, 0, 145), false, false, false, false)
	if (ply:Alive()) then
		draw.RoundedBoxEx(0, ScrW() - 328 + speedCalcMod, ScrH()-88, 296 - speedCalcMod, 26, crossHairColor, false, false, false, false)	
	else 
		speed = 0
	end
	
	draw.SimpleText(math.Round(speed), "TargetID", ScrW() - 38, ScrH()-83, Color(255,255,255,255), TEXT_ALIGN_RIGHT)
	
	--draw.SimpleText(ply:GetNetworkedBool("lobbyShouldLava"), "TargetID", 200, 300, Color(255,255,255,255), TEXT_ALIGN_RIGHT)
	--draw.SimpleText(ply:GetNetworkedBool("lobbyHasPass"), "TargetID", 200, 320, Color(255,255,255,255), TEXT_ALIGN_RIGHT)
	
	
	-- indicators
	for k,v in pairs ( player.GetAll() ) do
 		if (ply != v && ply:GetNetworkedString("lobbyID") == v:GetNetworkedString("lobbyID")) then 
			local indColor	= team.GetColor(v:Team())
			local position 	= ( v:GetPos() + Vector( 0,0,80 ) ):ToScreen() 
			local center	= Vector(ScrW()/2, ScrH()/2)
			local dist 		= (math.sqrt((position.x - center.x)^2 + (position.y - center.y)^2))
			

			
			if  (dist > radius) then
				local indicator = Vector(position.x - center.x, position.y - center.y, 80)
					  indicator:Normalize()
					  indicator = indicator * radius
					  
				draw.DrawText( "X", "TargetID", indicator.x + center.x, indicator.y + center.y, indColor, TEXT_ALIGN_CENTER )
			elseif (dist < 50) then
				draw.DrawText(v:Nick() , "TargetIDSmall", position.x, position.y, indColor,TEXT_ALIGN_CENTER )
			else
				draw.RoundedBoxEx(2, position.x, position.y - 9, 1, 20, indColor, true, true, true, true)
				draw.RoundedBoxEx(2, position.x - 9, position.y, 20, 3,indColor , true, true, true, true)
			end
		end
 	end
	
	if (LobbyMenu != NULL && LobbyMenu:IsVisible()) then
		--surface.SetDrawColor( 10, 10, 10, 200)
		surface.SetDrawColor( 10, 10, 10, 0)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end)

hook.Add("HUDShouldDraw", "RemovedHUD", function(HUD)
 local Items = {
  "CHudHealth",
  "CHudBattery",
  "CHudCrosshair",
  "CHudAmmo"
 }
 return !table.HasValue(Items, HUD)
end)