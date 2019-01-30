if wizard_spell_manager == nil then
    wizard_spell_manager = class({})
end


local modifier_names = {
	"rw_fire"
	,"rw_freeze"
	,"rw_slow"
	,"rw_haste"
	,"rw_health_rgn"
	,"rw_agi"
	,"rw_clarity"
	,"rw_evasion"
	,"rw_heal"
	,"rw_int"
	,"rw_invis"
	,"rw_magic_immune"
	,"rw_mana_rgn"
	,"rw_miss"
	,"rw_singl_magic"
	,"rw_singl_phys"
	,"rw_singl_pure"
	,"rw_str"
	,"rw_stun"
	,"rw_root"
	,"rw_damage_in"
	,"rw_damage_out"
  ,"rw_tele_self"
  ,"rw_tele_other"
  ,"rw_castout"
  ,"rw_hex"
  ,"rw_armor"
  ,"rw_pierce"
  ,"rw_magic_resist"
  ,"rw_magic_weak"
}
for i = 1,#modifier_names do
LinkLuaModifier( modifier_names[i], "lua_abilities/spell_components/modifiers/modifier_" .. modifier_names[i]  .. ".lua", LUA_MODIFIER_MOTION_NONE )
end
LinkLuaModifier( "wizard_default_modifier", "lua_abilities/spell_components/modifier_starting_init.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "wizard_cooldown_modifier", "lua_abilities/spell_components/modifier_starting_init.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "rw_trap", "lua_abilities/spell_components/style_modifiers/modifier_rw_trap.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "rw_bomb", "lua_abilities/spell_components/style_modifiers/modifier_rw_bomb.lua", LUA_MODIFIER_MOTION_NONE )


function wizard_spell_manager:GetIntrinsicModifierName()
	 return "wizard_default_modifier"
end

function wizard_spell_manager:InitWizzard()
	if self:GetLevel() < 1 then
		self:SetLevel(1)
	end
end


function wizard_spell_manager:GetRWModifierName(index)
	if (index > #self.modifier_names) then index = (index % #self.modifier_names)+1 end
	return self.modifier_names[index]
end

function wizard_spell_manager:GetRWTransportName(name)
	if (self.particle_transport_exist[name]) then return self.particle_transport_exist[name] end
	return self.generic_particle_transport_name
end

function wizard_spell_manager:GetRWModifierNames()
	return self.modifier_names
end

function wizard_spell_manager:GetRWModifierCount()
	return #self.modifier_names
end


function wizard_spell_manager:SpellChannelFinish(bInterrupted)
	--if (not bInterrupted) then 
		self:CastSpellComp(self.m_iSpellCollection,self.m_sKeys,self.m_sStage ) 
	--end
	self.m_sStage = 0
end


function wizard_spell_manager:StartSpell(keys)
		self.m_iSpellCollection = {}
		self.m_sKeys = keys
		self.m_sStage = 0
end

function wizard_spell_manager:GetStage()
	if self.m_sStage ~= nil then
		return self.m_sStage
	end
	return 0
end


function wizard_spell_manager:NewComponent(iComp,iLevel,vColor)
	--Add to spell composition
	self.m_sStage = self.m_sStage + iLevel
	local n = #self.m_iSpellCollection+1
	self.m_iSpellCollection[n] = iComp
	--Effect stuff:
	local hCaster = self:GetCaster()
	local vOrigin = hCaster:GetAbsOrigin()
	local nFx = ParticleManager:CreateParticle("particles/rw_signs/rw_sign.vpcf", PATTACH_ABSORIGIN, hCaster) 
	
	ParticleManager:SetParticleControl(nFx, 3, Vector(iComp,0,0))
	ParticleManager:SetParticleControl(nFx, 15,vColor)
	ParticleManager:ReleaseParticleIndex(nFx)
  	hCaster:EmitSound("RealWizard.Comp_" .. iComp) --Emit sound for the iComp
end

function wizard_spell_manager:GetRWModifierEffect(index,t)
	local s = self:GetRWTransportName(self:GetRWModifierName(index))
	if t == 1 then --Linear Projectile
		s = "particles/rw_linear/" .. s .. ".vpcf"
	elseif t == 2 then --Follow Projectile
		s = "particles/rw_follow/" .. s .. ".vpcf"
	elseif t == 3 then --Instant Target
		s = "particles/rw_target/" .. s .. ".vpcf"
	elseif t == 4 then --Instant Point (always small aoe min)
		s = "particles/rw_aoe/" .. s .. ".vpcf"
	elseif t == 5 then --Linear Wave
		s = "particles/rw_wave/" .. s .. ".vpcf"
	elseif t == 6 then --Trap Rune
		s = "particles/rw_trap/" .. s .. ".vpcf"
	elseif t == 7 then --Spell Bomber Summon
		s = "particles/rw_bomb/" .. s .. ".vpcf"
	elseif t == 8 then --Minion Summon
		s = "particles/rw_minion/" .. s .. ".vpcf"
	end
	return s
end

function wizard_spell_manager:LoadConstants()
	if (self.constantsLoaded) then return end

  self.modifier_names = {
	"rw_fire"
	,"rw_freeze"
	,"rw_slow"
	,"rw_haste"
	,"rw_health_rgn"
	,"rw_agi"
	,"rw_clarity"
	,"rw_evasion"
	,"rw_heal"
	,"rw_int"
	,"rw_invis"
	,"rw_magic_immune"
	,"rw_mana_rgn"
	,"rw_miss"
	,"rw_singl_magic"
	,"rw_singl_phys"
	,"rw_singl_pure"
	,"rw_str"
	,"rw_stun"
	,"rw_root"
	,"rw_damage_in"
	,"rw_damage_out"
  ,"rw_tele_self"
  ,"rw_tele_other"
  ,"rw_castout"
  ,"rw_hex"
  ,"rw_armor"
  ,"rw_pierce"
  ,"rw_magic_resist"
  ,"rw_magic_weak"
  --,"rw_knockback"
  --,rw_confuse"
  }
  self.generic_particle_transport_name = "rw_generic"
  self.particle_transport_exist = {
  }
		self.aoe_multiplier = 125
		self.dist_multiplier = 125
		self.compSeed = GameRules.GameMode:GetComponentKeys()
		--[[
		self.compSeed[1] = 4423789234
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
		self.effectNames = #self.modifier_names
		self.sm = {}
		self.sm_index = 1
		self.constantsLoaded = true

		--for debug
		self.dblines_transport = {
			"Linear Projectile"
			,"Follow Projectile"
			,"Instant Target"
			,"Instant Point"
			,"Linear Wave"
			,"Trap Rune"
			,"Missile"
			,"Spell Bomber Summon"
			,"Minion Summon"
		}
end

function wizard_spell_manager:SequenceCollapse(sequence)
	local s = #sequence
	local m = {0,0,0,0,0,0,0,0,0}
	
	for i = 1, s do
		for j = 1,9 do
			local seq = self.compSeed[(sequence[i]*(s+i*j))%#self.compSeed+1]
			m[j] = m[j] + (seq+i*i+j*j)
		end
	end
	m[1] = (m[1] % 6) + 1 --transport --Limit to 5 for now (rest require creatures)
	m[2] = (m[2] % self.effectNames) + 1 --effect
	m[3] = (m[2] % self.effectNames) + 1 --effect_extra
	m[4] = (m[4] % 4) + 1 --extra_style 
	m[5] = (m[5] % 6) + 1 --aoe
	m[6] = (m[6] % 15) + 1 --dist
	m[7] = (m[7] % 5) + 1 --power_a
	m[8] = (m[8] % 5) + 1 --power_b
	m[9] = (m[9] % 4) + 5 --boost
	m[m[9]] = m[m[9]] + s*0.25
	
	print(self.dblines_transport[m[1]] .. " with " .. self:GetRWModifierName(m[2]) .. " and " .. self:GetRWModifierName(m[3]))
	print("extra style " .. m[4] .. ", aoe " .. m[5] .. ", dist " .. m[6] .. ", power a " .. m[7] .. ", power b " .. m[8] .. ", boost " .. m[9])
	return m
end


function wizard_spell_manager:CastSpellComp(sequence,keys,power)
	self:LoadConstants()
	self.sm_index = self.sm_index + 1
	local m = self:SequenceCollapse(sequence)
	local n = self.sm_index
	self.sm[n] = {}
	self.sm[n].transport = m[1]
	self.sm[n].effect = m[2]
	self.sm[n].effect_extra = m[3]
	self.sm[n].extra_style = m[4] --1 = no extra, 2 = target extra, 3 = self extra
	self.sm[n].aoe_size = m[5]
	self.sm[n].distance = m[6] --targeted spells fizzle if target unit is out of range.
	self.sm[n].power_a = m[7]+power
	self.sm[n].power_b = m[8]+power
	self.sm[n].cooldown = m[7]+m[8]/power
	self.sm[n].keys = keys
	self.sm[n].spell_effect = self:GetRWModifierEffect(m[2],m[1])
	self.sm[n].spell_effect_linear = self:GetRWModifierEffect(m[2],1)
	self.sm[n].spell_effect_self = self:GetRWModifierEffect(m[3],3)
	self.sm[n].spell_effect_aoe = self:GetRWModifierEffect(m[2],4)
	self.sm[n].spell_effect_trap = self:GetRWModifierEffect(m[3],6)


	local x_keys = {
		power_a = self.sm[n].power_b,
		power_b = self.sm[n].power_a
		}
		local bSelf = (self.sm[n].extra_style == 3) --1 = no extra, 2 = target extra, 3 = self extra
		if (bSelf) then
			local sModifier_ex = self:GetRWModifierName(self.sm[n].effect_extra)
			self.sm[n].keys.m_hCaster:AddNewModifier(self.sm[n].keys.m_hCaster, self, sModifier_ex,x_keys)
		end


	local t = self.sm[n].transport
	if t == 1 then --Linear Projectile
		self:LinearProjectile(n)
	elseif t == 2 then --Follow Projectile
		self:FollowProjectile(n)
	elseif t == 3 then --Instant Target
		self:InstantTarget(n)
	elseif t == 4 then --Instant Point (always small aoe min)
		self:InstantPoint(n)
	elseif t == 5 then --Linear Wave
		self:LinearWave(n)
	elseif t == 6 then --Trap Rune
		self:TrapRune(n)
	elseif t == 7 then --Spell Bomber Summon
		self:SpellBomberSummon(n)
	--elseif t == 7 then
	--	self:MissileProjectile(n)
	--elseif t == 8 then
	--	self:MultiProjectile(n)
	--elseif t == 7 then --Spell Bomber Summon
		--self:SpellBomberSummon(n)
	--elseif t == 8 then --Minion Summon
		--self:MinionSummon(n)
	end

	self:PutOnCooldown(self.sm[n].cooldown)
end

function wizard_spell_manager:PutOnCooldown(cool)
	local hModifier = self:GetCaster():FindModifierByName("wizard_default_modifier")
	hModifier:SpendCooldown(cool)
end

function wizard_spell_manager:LinearProjectile(index)
	local hCaster = self:GetCaster()
	local info =
	{
		ExtraData = {extra_Index = index},
		Ability = self,
		EffectName = self.sm[index].spell_effect,
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		fDistance = self.sm[index].distance*200+self.sm[index].aoe_size*75,
		fStartRadius = 64,
		fEndRadius = 64,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = hCaster:GetForwardVector() * 1000,
		bProvidesVision = true,
		iVisionRadius = 64,
		iVisionTeamNumber = hCaster:GetTeamNumber()
	}
	self.sm[index].projectile_id = ProjectileManager:CreateLinearProjectile(info)
end

function wizard_spell_manager:MissileProjectile(index)
	local hCaster = self:GetCaster()
	local vLocation = self:ClampLocation(self.sm[index].keys.m_vPointTarget,self.sm[index].distance * self.dist_multiplier*self.sm[index].aoe_size * 120)
	--local hUnit = CreateUnitByName("rw_trap_unit",vLocation,true,hCaster:GetPlayerOwner(),hCaster,hCaster:GetTeam())
	local sModifier = self:GetRWModifierName(self.sm[index].effect)
	local sModifier_ex = self:GetRWModifierName(self.sm[index].effect_extra)
	local keys = self.sm[index]
	keys.keys = nil
	keys.mod_a = sModifier
	keys.mod_b = sModifier_ex
	--hUnit:AddNewModifier(hCaster, self, sModifier,keys)
	CreateModifierThinker(hCaster, self, "rw_trap",keys,vLocation,hCaster:GetTeam(),false)

end

function wizard_spell_manager:MultiProjectile(index)
	local hCaster = self:GetCaster()
	local count = math.ceil(self.sm[index].power_b * 0.5)--math.round(self.sm[index].power_b/2)
	local angle = 5
	local info =
	{
		ExtraData = {extra_Index = index},
		Ability = self,
		EffectName = self.sm[index].spell_effect_linear,
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		fDistance = self.sm[index].distance*160+self.sm[index].aoe_size*75,
		fStartRadius = 64,
		fEndRadius = 64,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		bProvidesVision = true,
		iVisionRadius = 64,
		iVisionTeamNumber = hCaster:GetTeamNumber()
	}
	for i = -count,count do
		info.vVelocity = (hCaster:GetForwardVector()*Vector(1,1,0) + Vector(math.sin(angle*i),math.cos(angle*i),0)):Normalized()*700
		local projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function wizard_spell_manager:FollowProjectile(index)
	if (self.sm[index].keys.m_bNoTarget) then
		self:NoTargetFizzle()
		return
	end
	local hCaster = self:GetCaster()
	local dist = CalcDistanceBetweenEntityOBB(self.sm[index].keys.m_hUnitTarget,hCaster)
	if (dist > self.sm[index].distance*200+400) then 
		self:DistanceFizzle()
		return
	 end
	local info =
	{
		ExtraData = {extra_Index = index},
		Target = self.sm[index].keys.m_hUnitTarget,
		Source = hCaster,
		Ability = self,
		EffectName = self.sm[index].spell_effect,
		iMoveSpeed = 800,
		vSourceLoc= hCaster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = true,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 20,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 64,                              -- Optional
		iVisionTeamNumber = hCaster:GetTeamNumber()        -- Optional
	}
	self.sm[index].projectile_id = ProjectileManager:CreateTrackingProjectile(info)
end

function wizard_spell_manager:InstantTarget(index)
	if (self.sm[index].keys.m_bNoTarget) then
		self:NoTargetFizzle()
		return
	end
	local hCaster = self:GetCaster()
	local hTarget = self.sm[index].keys.m_hUnitTarget
	local dist = CalcDistanceBetweenEntityOBB(hTarget,hCaster)
	if (dist > self.sm[index].distance*200+400) then 
		self:DistanceFizzle()
		return
	 end
	if (not hCaster:CanEntityBeSeenByMyTeam(hTarget)) then return end
	if (self.sm[index].aoe_size ~= 1) then
		self:AoeEffect(hTarget:GetAbsOrigin(), index)
		return
	end
	local sModifier = self:GetRWModifierName(self.sm[index].effect)
	local sModifier_ex = self:GetRWModifierName(self.sm[index].effect_extra)
	local bDouble = (self.sm[index].extra_style == 2) --1 = no extra, 2 = target extra, 3 = self extra
	local bReaction = (self.sm[index].extra_style == 4) --1 = no extra, 2 = target extra, 3 = self extra
	local keys = {
		power_b = self.sm[index].power_b,
		power_a = self.sm[index].power_a
	}
	local dkeys = {
		power_a = self.sm[index].power_b,
		power_b = self.sm[index].power_a
	}
	if (not hTarget:IsMagicImmune()) then
		hTarget:AddNewModifier(hCaster, self, sModifier,keys)
		if (bDouble) then
			hTarget:AddNewModifier(hCaster, self, sModifier_ex,dkeys)
		end
		if (bReaction) then
			hCaster:AddNewModifier(hCaster, self, sModifier_ex,dkeys)
		end
		local r = 255-- self:GetAbility():GetSpecialValueFor("red")
		local g = 255--self:GetAbility():GetSpecialValueFor("green")
		local b = 255--self:GetAbility():GetSpecialValueFor("blue")
		self.nFXIndex = ParticleManager:CreateParticle( self.sm[index].spell_effect_aoe, PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControl(self.nFXIndex, 3, Vector(r,g,b))
		ParticleManager:SetParticleControl(self.nFXIndex, 4, Vector(r,g,b))
		ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(1,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(50,50,50))
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end

function wizard_spell_manager:InstantPoint(index)
	local vTarget = self:ClampLocation(self.sm[index].keys.m_vPointTarget,self.sm[index].distance * self.dist_multiplier)
	self:AoeEffect(vTarget,index)
end

function wizard_spell_manager:LinearWave(index)
	local hCaster = self:GetCaster()
	local fAoe = 260--self.sm[index].aoe_size * 32 + 64
	local info =
	{
		ExtraData = {extra_Index = index},
		Ability = self,
		EffectName = self.sm[index].spell_effect,
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		fDistance = self.sm[index].distance*260,
		fStartRadius = fAoe,
		fEndRadius = fAoe,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = hCaster:GetForwardVector() * 1800,
		bProvidesVision = true,
		iVisionRadius = fAoe,
		iVisionTeamNumber = hCaster:GetTeamNumber()
	}
	self.sm[index].projectile_id = ProjectileManager:CreateLinearProjectile(info)

end

function wizard_spell_manager:TrapRune(index)
	local hCaster = self:GetCaster()
	local vLocation = self:ClampLocation(self.sm[index].keys.m_vPointTarget,self.sm[index].distance * self.dist_multiplier*self.sm[index].aoe_size * 120)
	--local hUnit = CreateUnitByName("rw_trap_unit",vLocation,true,hCaster:GetPlayerOwner(),hCaster,hCaster:GetTeam())
	local sModifier = self:GetRWModifierName(self.sm[index].effect)
	local sModifier_ex = self:GetRWModifierName(self.sm[index].effect_extra)
	local keys = self.sm[index]
	keys.keys = nil
	keys.mod_a = sModifier
	keys.mod_b = sModifier_ex
	--hUnit:AddNewModifier(hCaster, self, sModifier,keys)
	CreateModifierThinker(hCaster, self, "rw_trap",keys,vLocation,hCaster:GetTeam(),false)
end


function wizard_spell_manager:SpellBomberSummon(index)
	if (self.sm[index].keys.m_bNoTarget) then
		self:NoTargetFizzle()
		return
	end
	local hCaster = self:GetCaster()
	local vLocation = self:ClampLocation(self.sm[index].keys.m_vPointTarget,self.sm[index].distance * self.dist_multiplier)
	local hUnit = CreateUnitByName("npc_dota_creature_spell_bomb",hCaster:GetAbsOrigin(),true,hCaster:GetPlayerOwner(),hCaster,hCaster:GetTeam())
	local sModifier = self:GetRWModifierName(self.sm[index].effect)
	local sModifier_ex = self:GetRWModifierName(self.sm[index].effect_extra)
	local keys = self.sm[index]
	keys.bomb_target = self.sm[index].keys.m_hUnitTarget:GetEntityIndex()
	keys.keys = nil
	keys.mod_a = sModifier
	keys.mod_b = sModifier_ex
	hUnit:AddNewModifier(hCaster, self, "rw_bomb",keys)

end

function wizard_spell_manager:MinionSummon(index)
	local hCaster = self:GetCaster()
	local vLocation = self:ClampLocation(self.sm[index].keys.m_vPointTarget,self.sm[index].distance * self.dist_multiplier)
	local hUnit = CreateUnitByName("rw_minion_unit",vLocation,true,hCaster:GetPlayerOwner(),hCaster,hCaster:GetTeam())
	local sModifier = self:GetRWModifierName(self.sm[index].effect)
	local sModifier_ex = self:GetRWModifierName(self.sm[index].effect_extra)
	local bDouble = (self.sm[index].extra_style == 2) --1 = no extra, 2 = target extra, 3 = self extra
	self.sm[index].is_summon = true
	local keys = self.sm[index]
	hUnit:AddNewModifier(hCaster, self, sModifier,keys)
	if (bDouble) then hUnit:AddNewModifier(hCaster, self, sModifier_ex,keys) end

end

function wizard_spell_manager:OnProjectileHit_ExtraData( hTarget, vLocation, extra )
	local index = extra.extra_Index
	local hCaster = self:GetCaster()
	if (hCaster == hTarget) then return end
	if (self.sm[index].aoe_size ~= 1) then
		self:AoeEffect(vLocation, index)
		return (self.sm[index].transport ~= 5)
	end
	local iTeam = hCaster:GetTeam()
	local sModifier = self:GetRWModifierName(self.sm[index].effect)
	local sModifier_ex = self:GetRWModifierName(self.sm[index].effect_extra)
	local bDouble = (self.sm[index].extra_style == 2) --1 = no extra, 2 = target extra, 3 = self extra
	local bReaction = (self.sm[index].extra_style == 4) --1 = no extra, 2 = target extra, 3 = self extra
	local keys = {
		power_b = self.sm[index].power_b,
		power_a = self.sm[index].power_a
	}
	local dkeys = {
		power_a = self.sm[index].power_b,
		power_b = self.sm[index].power_a
	}
	if (hTarget ~= nil) then
		if (not hTarget:IsMagicImmune()) then
			hTarget:AddNewModifier(hCaster, self, sModifier,keys)
			if (bDouble) then
				hTarget:AddNewModifier(hCaster, self, sModifier_ex,dkeys)
			end
			if (bReaction) then
				hCaster:AddNewModifier(hCaster, self, sModifier_ex,dkeys)
			end
		end
	end
	return (self.sm[index].transport ~= 5)
end

function wizard_spell_manager:AoeEffect(vLocation, index)
	local hCaster = self:GetCaster()
	local iTeam = hCaster:GetTeam()
	local sModifier = self:GetRWModifierName(self.sm[index].effect)
	local sModifier_ex = self:GetRWModifierName(self.sm[index].effect_extra)
	local bDouble = (self.sm[index].extra_style == 2) --1 = no extra, 2 = target extra, 3 = self extra
	local bReaction = (self.sm[index].extra_style == 4) --1 = no extra, 2 = target extra, 3 = self extra
	local keys = {
		power_b = self.sm[index].power_b,
		power_a = self.sm[index].power_a
	}
	local dkeys = {
		power_a = self.sm[index].power_b,
		power_b = self.sm[index].power_a
	}
	local aoe_mult = self.aoe_multiplier
	if (self.sm[index].transport == 5) then
		aoe_mult = aoe_mult*0.25
	end

	local tTargets = FindUnitsInRadius(iTeam,
							  vLocation,
							  nil,
							  self.sm[index].aoe_size * aoe_mult,
							  DOTA_UNIT_TARGET_TEAM_BOTH,
							  DOTA_UNIT_TARGET_ALL,
							  DOTA_UNIT_TARGET_FLAG_NONE,
							  FIND_ANY_ORDER,
							  false)
	for _,hUTarget in pairs(tTargets) do
			if (not hUTarget:IsMagicImmune()) then
			hUTarget:AddNewModifier(hCaster, self, sModifier,keys)
			if (bDouble) then
				hUTarget:AddNewModifier(hCaster, self, sModifier_ex,dkeys)
			end
			if (bReaction) then
				hCaster:AddNewModifier(hCaster, self, sModifier_ex,dkeys)
			end
		end
	end
	local r = 255-- self:GetAbility():GetSpecialValueFor("red")
	local g = 255--self:GetAbility():GetSpecialValueFor("green")
	local b = 255--self:GetAbility():GetSpecialValueFor("blue")
	self.nFXIndex = ParticleManager:CreateParticle( self.sm[index].spell_effect_aoe, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl(self.nFXIndex, 0, vLocation)
	ParticleManager:SetParticleControl(self.nFXIndex, 3, Vector(r,g,b))
	ParticleManager:SetParticleControl(self.nFXIndex, 4, Vector(r,g,b))
	ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(1,1,1))
	ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(self.sm[index].aoe_size * self.aoe_multiplier,self.sm[index].aoe_size * self.aoe_multiplier,self.sm[index].aoe_size * self.aoe_multiplier))
	ParticleManager:ReleaseParticleIndex(self.nFXIndex)
end

function wizard_spell_manager:ClampLocation(vLocation, fMax)
	local hCaster = self:GetCaster()
	local vOrigin = hCaster:GetAbsOrigin()
	local vDiff = vLocation-vOrigin
   if vDiff:Length2D() > fMax then
        vLocation = vOrigin + (vLocation - vOrigin):Normalized() * fMax
  end
	return vLocation
end

function wizard_spell_manager:DistanceFizzle()
	local hCaster = self:GetCaster()
    local vOrigin = hCaster:GetAbsOrigin()
    --ParticleManager:CreateParticle("particles/rw_signs/sign_" .. iComp .. ".vpcf", PATTACH_ABSORIGIN, hCaster) --Create particle effect at our caster.
    local nFXIndex = ParticleManager:CreateParticle("particles/econ/events/ti8/msg_deny_ti8.vpcf", PATTACH_OVERHEAD_FOLLOW, hCaster) --Create particle effect at our caster.
	
	ParticleManager:SetParticleControl(nFXIndex, 3, Vector(255,255,255))
	ParticleManager:SetParticleControl(nFXIndex, 4, Vector(30,1,0))
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	hCaster:EmitSound("RealWizard.Error_Cast_Range")
end

function wizard_spell_manager:NoTargetFizzle()
	local hCaster = self:GetCaster()
    local vOrigin = hCaster:GetAbsOrigin()
    --ParticleManager:CreateParticle("particles/rw_signs/sign_" .. iComp .. ".vpcf", PATTACH_ABSORIGIN, hCaster) --Create particle effect at our caster.
    local nFXIndex = ParticleManager:CreateParticle("particles/econ/events/ti8/msg_deny_ti8.vpcf", PATTACH_OVERHEAD_FOLLOW, hCaster) --Create particle effect at our caster.
	
	ParticleManager:SetParticleControl(nFXIndex, 3, Vector(255,255,255))
	ParticleManager:SetParticleControl(nFXIndex, 4, Vector(30,1,0))
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	hCaster:EmitSound("RealWizard.Error_Cast_Range")
end

	--Transport:
		--Linear Projectile
		--Follow Projectile
		--Instant Target
		--Instant Point (always small aoe min)
		--Linear Wave
		--Trap Rune
		--Spell Bomber Summon
		--Minion Summon
	--Effects:
		--Fire Damage (magic damage per second)
		--Cold Damage (slow)
		--Freeze (Root)
		--Poison Damage (physical damage per second)
		--Acid Damage (armor reduction & physical damage per second)
		--Electric Damage (pure damage per second)
		--Plasma Damage (magic resistance reduction & damage per second)
		--Health Regen
		--Mana Regen
		--Instant Health
		--Instant Mana
		--Dark Damage (pure damage)
		--Light Damage (magic damage)
		--Teleport Self to Target
		--Teleport Target to Self.
		--Teleport Swap
		--Teleport Self to Target + Attack
		--Haste
		--Slow
		--Invisibility
		--Magic Immune
		--Armor Bonus
		--Magic Resist Bonus
		--Str Bonus
		--Agi Bonus
		--Int Bonus
		--Banish (out of game)
		--KnockBack
		--Confuse
	--Spell Modifiers:
		--Extra Effect
		--Aoe
