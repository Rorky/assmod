local PLUGIN = {}

PLUGIN.Name = "Default Writer"
PLUGIN.Author = "Slayer3032"
PLUGIN.Date = "01st May 2015"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = false
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

function PLUGIN.AddToLog(PLAYER, ACL, ACTION)

	if (ASS_Config["writer"] != PLUGIN.Name) then return end
	
	local fn = "assmod/logs/" .. ACL .. ".txt"
	local log = ""
	
	if (file.Exists(fn, "DATA")) then
		log = file.Read(fn, "DATA")
		
		if (#log > 80000) then
			log = "Logs cleared!\n"
		end
	end
	
	log = log .. os.time() .. " - " .. ASS_FullNick(PLAYER) .. " -> " .. ACTION .. "\n"
	
	file.Write(fn, log)

end

function PLUGIN.LoadPlayerRank(pl)
	if (ASS_Config["writer"] != PLUGIN.Name) then return false end
	if !pl then return false end
	if !file.Exists("assmod/users/"..pl:AssID()..".txt", "DATA") then return false end

	local ranks = file.Read("assmod/users/"..pl:AssID()..".txt", "DATA")
	
	if (!ranks || ranks == "") then return false end
	
	local ranktable = util.KeyValuesToTable(ranks)
	
	local tbl = {}
	tbl.Rank = ranktable.rank
	tbl.ASSPluginValues = ranktable.asspluginvalues or {}
	
	return tbl
end

function PLUGIN.SavePlayerRank(pl)
	if (ASS_Config["writer"] != PLUGIN.Name) then return end
	
	local r = {}

	if (pl.Rank != ASS_LVL_GUEST || table.Count(pl.ASSPluginValues) != 0) then
		r.Name = pl:Nick()
		r.Rank = pl:GetAssLevel()
		r.ASSPluginValues = {}
		for nm,val in pairs(pl.ASSPluginValues) do
			r.ASSPluginValues[nm] = tostring(val)
		end
			
		local rank = util.TableToKeyValues( r )
		file.Write("assmod/users/"..pl:AssID()..".txt", rank)		
	end
end

ASS_RegisterPlugin(PLUGIN)


