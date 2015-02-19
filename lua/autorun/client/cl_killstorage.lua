

function KillTrackerDrawInfo()
	local ply = LocalPlayer()
	
	
	local possibleranks = {
		"literally trash",
		"trash",
		"garbage",
		"scrub",
		"noob",
		"faggot",
		"gay",
		"homosexual",
		"bisexual"}
	

	local kills = ply:GetNWInt("KTKills",0)
	local deaths = ply:GetNWInt("KTDeaths",0)
	local rank = math.floor( (kills/deaths) * kills/10 ) + 1
	

	draw.DrawText("RANK: "..rank.." \nKILLS: "..kills.." \nDEATHS: ".. deaths, "DermaLarge" , ScrW()*0.75, ScrH()*0.75, Color(255,255,255,255) , TEXT_ALIGN_LEFT )


end

hook.Add("HUDPaint","KillTracker Draw Stats",KillTrackerDrawInfo)


net.Receive("KillTrackerPrint", function(len,ply)

	local Table = net.ReadTable()
	timer.Simple(1, function()
		for k,v in pairs (player.GetAll()) do
		
		
			local KDR 
			
			if Table[v][1] == 0 then
				KDR = 0
			elseif Table[v][2] == 0 then
				KDR = Table[v][1]
			else
				KDR = Table[v][1] / Table[v][2]
			end
			
			local ColorMod = Color( math.Clamp(255 - 255*KDR,0,255) , math.Clamp(255*KDR,0,255) , 0, 255)
		
			chat.AddText( team.GetColor(v:Team()),
				v:Nick() .. " ",
				Color(255,255,255,255),
				"Kills: ",
				Color(0,255,0,255),
				Table[v][1] .. " ",
				Color(255,255,255,255),
				"Deaths: ",
				Color(255,0,0,255),
				Table[v][2] .. " ",
				Color(255,255,255,255),
				"Ratio: ",
				ColorMod,
				math.Round(KDR,2) .. " "
			)
		
		
		end
	end)
	
	

end)