-- Generated from template

if CRealWizardGameMode == nil then
	CRealWizardGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

function Activate()
	GameRules.GameMode = CRealWizardGameMode()
	GameRules.GameMode:InitGameMode()
end


function CRealWizardGameMode:InitGameMode()

	print("Creating Component Keys")
	self.compSeed = {}
	for i = 1,16 do
		self.compSeed[i] = RandomInt(1000000000,10000000000)
	end
	--[[
	self.compSeed[1] = 8923485654
	self.compSeed[2] = 8923485654
	self.compSeed[3] = 9734129861
	self.compSeed[4] = 3026471561
	self.compSeed[5] = 5392529169
	self.compSeed[6] = 7838181963
	self.compSeed[7] = 6230967614
	self.compSeed[8] = 8196328381
	self.compSeed[9] = 2916953925
	self.compSeed[10] = 8196378381
	self.compSeed[11] = 1462309676
	self.compSeed[12] = 2838963181
	self.compSeed[13] = 2525399169
	self.compSeed[14] = 9637838181
	self.compSeed[15] = 6423096761
	self.compSeed[16] = 4374289234]]

	print( "Real Wizard Loaded" )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )


end

function CRealWizardGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CRealWizardGameMode:GetComponentKeys()
	return self.compSeed
end