print("Loaded shared.lua")

include("sh_air_strafing.lua")
include("sh_movement.lua")

GM.Name 	= "Unrealistic Movement"
GM.Author 	= "Sparky"
GM.Email 	= "N/A"
GM.Website 	= "N/A"

team.SetUp(0, "None", Color(255,255,255,200))
team.SetUp(1, "Hunter", Color(0,100,255,200))
team.SetUp(2, "Runner", Color(255,100,0,200))
team.SetUp(3, "Tagger", Color(255,255,100,200))
team.SetUp(4, "Runner", Color(100,255,0,200))
team.SetUp(5, "Handicapped", Color(255,255,100,200))
team.SetUp(6, "Infected", Color(200,0,255,200))
team.SetUp(7, "Runner", Color(0,100,255,200))
team.SetUp(8, "None", Color(200,225,255,200))
team.SetUp(9, "Frozen", Color(200,225,255,200))
team.SetUp(10, "Unfreezer", Color(255,0,25,200))
team.SetUp(11, "Freezer", Color(100,100,255,200))
team.SetUp(12, "Deathmatch", Color(200,0,0,200))
team.SetUp(1001, "None", Color(255,255,255,200))



hook.Add("ShouldCollide", "prevent players collision", function(ent1, ent2)
	if (ent1:IsPlayer() && ent2:IsPlayer() && ent1:Alive() && ent2:Alive()) then
		return false -- also makes it so people can't actually attack eachother...
	end
end)