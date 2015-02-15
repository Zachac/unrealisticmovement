print("Loaded cl_init.lua")

include("shared.lua")
include("cl_hud.lua")
include("cl_settings.lua")
include("cl_effects.lua")
include("cl_tabmenu.lua")
include("cl_lobbies.lua")
include("cl_lobbies_menu_functions.lua")
include("cl_lobbies_menu.lua")
include("cl_lobby_make_Settings.lua")

-- 8 lines for MesseageAll to use
local line1Alpha	= 0
local line2Alpha	= 0
local line3Alpha	= 0
local line4Alpha	= 0
local line5Alpha	= 0
local line6Alpha	= 0
local line7Alpha	= 0
local line8Alpha	= 0
local line1Message	= ""
local line2Message	= ""
local line3Message	= ""
local line4Message	= ""
local line5Message	= ""
local line6Message	= ""
local line7Message	= ""
local line8Message	= ""


-- copy pasta =/
hook.Add("PostDrawViewModel", "draw hands", function( vm, ply, weapon )
	if (weapon.UseHands || !weapon:IsScripted()) then
		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
	end
end)

-- you moved? we will unspectate you
hook.Add("KeyPress", "un spectate", function(ply, key)
	if (ply:GetObserverTarget() != nil && (key == 2 || key == 512 || key == 1024 || key == 8 || key == 16 )) then
		RunConsoleCommand("um_unspectate")
	end
end)

-- format text sent to client
hook.Add("ChatText", "color format", function(index, name, text, messageType)
	local words 		= string.Explode(" ", text, false)
	local textArgs		= {}
	local textArgsPos	= 1
	
	for m,n in pairs (words) do
		local found = false 
		for k,v in pairs (player.GetAll()) do
			if (n == v:Nick()) then -- is this word a name?
				found = v
			end
		end
		
		if (IsValid(found)) then
			textArgs[textArgsPos] = team.GetColor(found:Team())
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif(n == "You") then
			textArgs[textArgsPos] = team.GetColor(LocalPlayer():Team())
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif(n == "Error:") then
			textArgs[textArgsPos] = Color(255,0,0,255)
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif (n == "Hunted") then
			textArgs[textArgsPos] = Color(255,100,0,255)
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif (n == "Tag") then
			textArgs[textArgsPos] = Color(255,255,100,255)
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif (n == "Handicapped") then
			textArgs[textArgsPos] = Color(0,100,255,255)
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif (n == "Elimination") then
			textArgs[textArgsPos] = Color(200,0,255,255)
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif (n == "Miscellaneous") then
			textArgs[textArgsPos] = Color(200,225,255,255)
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		elseif (n == "FreezeTag") then
			textArgs[textArgsPos] = Color(100,100,255,255)
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		else
			textArgs[textArgsPos] = Color(100,100,100,255) -- defualt chat color
			textArgsPos = textArgsPos + 1
			textArgs[textArgsPos] = (n .. " ")
			textArgsPos = textArgsPos + 1
		end
	end
	
	
	chat.AddText(unpack(textArgs)) -- actually print the stuff
	return true
end)

-- shift all text upwards by one
usermessage.Hook( "Messaging", function(data)
	local message	= data:ReadString()

	line8Message = line7Message
	line8Alpha = line7Alpha

	line7Message = line6Message
	line7Alpha = line6Alpha

	line6Message = line5Message
	line6Alpha = line5Alpha

	line5Message = line4Message
	line5Alpha = line4Alpha

	line4Message = line3Message
	line4Alpha = line3Alpha

	line3Message = line2Message
	line3Alpha = line2Alpha

	line2Message = line1Message
	line2Alpha = line1Alpha

	line1Message	= message
	line1Alpha	 	= 1000

	print(message)
end) 

hook.Add("HUDPaint", "Message stuffs", function()
	draw.SimpleText(line1Message, "TargetID", ScrW()/2, ScrH()/2 - 100, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line1Alpha), TEXT_ALIGN_CENTER)
	draw.SimpleText(line2Message, "TargetID", ScrW()/2, ScrH()/2 - 120, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line2Alpha), TEXT_ALIGN_CENTER)
	draw.SimpleText(line3Message, "TargetID", ScrW()/2, ScrH()/2 - 140, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line3Alpha), TEXT_ALIGN_CENTER)
	draw.SimpleText(line4Message, "TargetID", ScrW()/2, ScrH()/2 - 160, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line4Alpha), TEXT_ALIGN_CENTER)
	draw.SimpleText(line5Message, "TargetID", ScrW()/2, ScrH()/2 - 180, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line5Alpha), TEXT_ALIGN_CENTER)
	draw.SimpleText(line6Message, "TargetID", ScrW()/2, ScrH()/2 - 200, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line6Alpha), TEXT_ALIGN_CENTER)
	draw.SimpleText(line7Message, "TargetID", ScrW()/2, ScrH()/2 - 220, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line7Alpha), TEXT_ALIGN_CENTER)
	draw.SimpleText(line8Message, "TargetID", ScrW()/2, ScrH()/2 - 240, Color(crossHairColor.r,crossHairColor.g,crossHairColor.b, line8Alpha), TEXT_ALIGN_CENTER)
	
	line1Alpha	= line1Alpha - 10
	line2Alpha	= line2Alpha - 10
	line3Alpha	= line3Alpha - 10
	line4Alpha	= line4Alpha - 10
	line5Alpha	= line5Alpha - 10
	line6Alpha	= line6Alpha - 10
	line7Alpha	= line7Alpha - 10
	line8Alpha	= line8Alpha - 10
end)