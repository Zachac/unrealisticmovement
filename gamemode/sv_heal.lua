print("Loaded sv_heal.lua")

local hRegenAdd			= 1
local aRegenAdd			= 1
local NextTime 			= 0	
local healthCoolDown 	= .5									-- cooldown for next healing

hook.Add("Think", "ThinkFunc", function()
    if (CurTime() - NextTime  > healthCoolDown) then
		for k,v in pairs (player.GetAll()) do
			if (v:Alive()) then
				-- health regen
				if (v:Health() < 100 && v:Health() > 0) then
					v:SetHealth(v:Health() + 1)
				end

				if (v:Health() > 100) then -- overflow?
					v:SetHealth(100)
				end
			end
		end
		
		NextTime = CurTime() + healthCoolDown 
    end
end)