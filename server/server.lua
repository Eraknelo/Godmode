class 'Godmode'

function Godmode:__init()
	self.admins = {}
	self.godmodePlayers = {}
	
	-- Add admins
	self:AddAdmin("STEAM_0:0:16870054")
	
	-- Subscribe to events
	Events:Subscribe("PlayerChat", self, self.PlayerChat)
	Events:Subscribe("PlayerQuit", self, self.PlayerQuit)
end

function Godmode:AddAdmin(steamId)
	self.admins[steamId] = true
end

function Godmode:IsAdmin(player)
	return self.admins[player:GetSteamId().string] ~= nil
end

function Godmode:PlayerChat(args)
	if args.text ~= "/godmode" or not self:IsAdmin(args.player) then return true end
	
	local steamId = args.player:GetSteamId().id
	local currentGodmode = self.godmodePlayers[steamId]
	
	if steamId == nil then return end
	
	if currentGodmode ~= nil then -- Godmode on
		self.godmodePlayers[steamId] = nil
		Network:Send(args.player, "GodmodeToggle", false)
	else
		self.godmodePlayers[steamId] = args.player
		Network:Send(args.player, "GodmodeToggle", true)
	end
	
	return false
end

function Godmode:PlayerQuit(args)
	local steamId = args.player:GetSteamId().id
	local currentGodmode = self.godmodePlayers[steamId]
	
	if steamId == nil then return end
	
	if currentGodmode ~= nil then -- Godmode on
		self.godmodePlayers[steamId] = nil
	end
end

Godmode()