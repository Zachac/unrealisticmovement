print("Loaded sv_trail.lua")

trailTexture 		= "trails/smoke.vmt" 		-- defualt texture
trailSW			 	= 15						-- defualt start width
trailEW		 		= 1							-- defualt end width
trailLife	 		= 5							-- how many seconds should this last?
trailRes	 		= 1/(trailSW+trailEW)*0.5	-- trail resolution formula

updateTrail = function(ply)	
	SafeRemoveEntity(ply.Trail)
	ply.Trail				  	= util.SpriteTrail(ply, 0, team.GetColor(ply:Team()), false, trailSW, trailEW, trailLife, trailRes, trailTexture)
end


hook.Add("PlayerSpawn", "player trail spawn", function(ply)
	updateTrail(ply)
end)

function GM:PlayerDisconnected(ply)
	SafeRemoveEntity(ply.Trail)
end