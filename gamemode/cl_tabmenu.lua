print("Loaded cl_tabmenu.lua")

local lastTime		= 0
local playerAmnt	= 0

hook.Add("HUDPaint", "score board", function()
	if(LocalPlayer():KeyDown(IN_SCORE)) then
		xPos 	= ScrW()/4 + 10
		yPos 	= ScrH()/2 - (playerAmnt * 13)
		width	= ScrW()/2 - 10
		hight	= 26
		
		local shouldUpdate	= false
		if (CurTime() - lastTime > .1) then
			shouldUpdate	= true
		end
		
		for k,v in pairs(player.GetAll()) do
			if (shouldUpdate || !v.localSpeed) then
				v.localSpeed	= math.Round(v:GetVelocity():Length()/10)
				lastTime		= CurTime()
			end
		end

		draw.SimpleText("Players", "TargetIDSmall",  xPos + 10,  yPos - 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		draw.SimpleText("Ping", "TargetIDSmall",  xPos + width - 100,  yPos - 15, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
		draw.SimpleText("Speed", "TargetIDSmall",  xPos + width - 10, yPos - 15, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
		
		for k,v in pairs(player.GetAll()) do
			local teamColor = team.GetColor(v:Team())
			surface.SetDrawColor(Color(teamColor.r,teamColor.g,teamColor.b,145))
			surface.SetMaterial(Material( "vgui/white" ))
			surface.DrawTexturedRect(xPos,yPos,width,hight)
			
			draw.SimpleText(math.Round(v:GetVelocity():Length()/100) * 10, "TargetIDSmall",  xPos + width - 10, yPos + hight/5, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
			draw.SimpleText(v:Nick(), "TargetID",  xPos + 10,  yPos + hight/6, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText(v:Ping(), "TargetID",  xPos + width - 100,  yPos + hight/6, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)

			yPos		= yPos + hight + 1
			playerAmnt 	= k
		end
	end
end)


hook.Add("ScoreboardShow", "test", function()
		return true
end)