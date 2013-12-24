class 'Godmode'

function Godmode:__init()
	-- Variables
	self.godModeOn = false
	
	-- Subscribe to events
	Events:Subscribe("LocalPlayerBulletHit", self, self.GodmodeHandle)
	Events:Subscribe("LocalPlayerExplosionHit", self, self.GodmodeHandle)
	Events:Subscribe("LocalPlayerForcePulseHit", self, self.GodmodeHandle)
	Network:Subscribe("GodmodeToggle", self, self.GodmodeToggle)
end

-- ========================= Godmode toggle =========================
function Godmode:GodmodeToggle(args)
	self.godModeOn = args
	if self.godModeOn then
		Chat:Print("God mode enabled.", Color(255, 0, 0))
	else
		Chat:Print("God mode disabled.", Color(255, 0, 0))
	end
end

-- ========================= Godmode =========================
function Godmode:GodmodeHandle(args)
	return not self.godModeOn
end

-- ========================= Initialize =========================
godMode = Godmode()