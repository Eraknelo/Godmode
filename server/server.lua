class 'Godmode'

function Godmode:__init()
	self.admins = {}
	self.godmodePlayers = {}
	self.timer = Timer()
	self.updateRate = 10
	
	-- Add admins
	self:AddAdmin("STEAM_0:0:16870054")
	self:AddAdmin("STEAM_0:1:40939579")
	
	-- Subscribe to events
	Events:Subscribe("PlayerChat", self, self.PlayerChat)
	Events:Subscribe("PostTick", self, self.PreTick)
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

function Godmode:PreTick()
	if self.timer:GetMilliseconds() < self.updateRate then return end

	for steamId, player in pairs(self.godmodePlayers) do
		if not IsValid(player) then
			self.godmodePlayers[player] = nil
			return
		end
		player:SetHealth(99999999999999)
		
		if player:InVehicle() then
			local playerVehicle = player:GetVehicle()
			if playerVehicle ~= nil and IsValid(playerVehicle) then
				playerVehicle:SetHealth(99999999999999)
			end
		end
	end
	
	self.timer:Restart()
end

local godmode = Godmode()