print("Loaded cl_lobbies.lua")

hook.Add("CreateMove", "Freezeing", function(cmd)
	if (LocalPlayer():Team() == 9) then
		if (bit.band(cmd:GetButtons(), IN_JUMP) > 0) then
			cmd:SetButtons( cmd:GetButtons() - IN_JUMP )
		end
		
		if (bit.band(cmd:GetButtons(), IN_ATTACK) > 0) then
			cmd:SetButtons( cmd:GetButtons() - IN_ATTACK )
		end
		
		cmd:SetUpMove(0)
		cmd:SetForwardMove(0)
		cmd:SetSideMove(0)
	end
end)


hook.Add("Think", "Auto-Hop", function()
	if (LocalPlayer():GetNetworkedInt("lobbyMoveType")  == 3 && LocalPlayer():Team() != 5) then
		 RunConsoleCommand(((LocalPlayer():IsOnGround() or LocalPlayer():WaterLevel() > 0) and "+" or "-").."jump")
	end
end)
