

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