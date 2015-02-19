folder = "killtracker/"

CreateConVar("sv_bur_saveinterval", "120", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE , "Interval for the data save time for each player" )
	
function KillTrackerSetupPlayer( ply )
	local storename = string.gsub(ply:SteamID(), ":", "_")

	if not file.Exists( folder, "DATA") then file.CreateDir( folder ) end

	if not file.Exists( folder.."/"..storename .. ".txt", "DATA" ) then 
		file.Write( folder.."/"..storename..".txt", "0_0" )
		
		ply.kills = 0
		ply.deaths = 0
		
		ply:SetNWInt("KTKills",ply.kills)
		ply:SetNWInt("KTDeaths",ply.deaths)
		
	else	
		TrackerString = string.Explode("_",file.Read(folder.."/"..storename ..".txt"))

		ply.kills = TrackerString[1]
		ply.deaths = TrackerString[2]
		
		ply:SetNWInt("KTKills",ply.kills)
		ply:SetNWInt("KTDeaths",ply.deaths)
		
	end
	
	timer.Create( "trackersave-"..storename, GetConVar("sv_bur_saveinterval"):GetInt(), 0, function()
	
		if not IsValid(ply) then
			timer.Destroy("trackersave-"..storename)
		return end
		
		ply:PrintMessage( HUD_PRINTTALK, "Data Saved")
		print("WRITING: " .. ply.kills .. "_" .. ply.deaths)
		

		file.Write( folder.."/"..storename..".txt", ply.kills .. "_" .. ply.deaths )
		
	end	)
	
	
end
hook.Add( "PlayerInitialSpawn", "KillTracker Setup Player", KillTrackerSetupPlayer )

function KillTrackerPlayerDeath( victim, inflictor, attacker )
	
	if victim.deaths == nil then
		victim.deaths = 1
	else
		victim.deaths = victim.deaths+1
	end
	
	if attacker:IsPlayer() and attacker ~= victim then
		if attacker.kills == nil then
			attacker.kills = 1
		else
			attacker.kills = attacker.kills + 1
		end	
	end
	
	attacker:SetNWInt("KTKills",attacker.kills)
	victim:SetNWInt("KTDeaths",victim.deaths)
	
end

hook.Add("PlayerDeath", "KillTracker Player Death", KillTrackerPlayerDeath)

util.AddNetworkString( "KillTrackerPrint" )

function KillTrackerChatCommands( ply, text, public )
	
	local Trigger = "!killtracker"
	
	
	if string.sub(text, 1, string.len(Trigger) ) == Trigger then
	
		local Table = {}
		
		for k,v in pairs(player.GetAll()) do
		
			Table[v] = {v.kills,v.deaths}
		
		end
	
	
	
		net.Start("KillTrackerPrint")
		
			net.WriteTable(Table)
			
		net.Broadcast()
	
	end


end

hook.Add( "PlayerSay", "KillTracker Chat Commands", KillTrackerChatCommands )















