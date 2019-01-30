if wizard_spell_component_base == nil then
    wizard_spell_component_base = class({})
end

LinkLuaModifier( "wizard_casting_modifier", "lua_abilities/spell_components/casting_modifier.lua", LUA_MODIFIER_MOTION_NONE )

function wizard_spell_component_base:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	if self:GetCaster():HasModifier("wizard_casting_modifier") then
		behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
    return behav
end

function wizard_spell_component_base:OnSpellStart()
	local hCaster = self:GetCaster()
	self.m_hMasterSpell = hCaster:FindAbilityByName("wizard_spell_manager")
	if self.m_hMasterSpell ~= nil then
		local stage = self.m_hMasterSpell:GetStage()
		if stage > 0 then
				self.m_hMasterSpell:NewComponent(self:GetSpecialValueFor( "id" ),self:GetLevel(), Vector(self:GetSpecialValueFor("red"),self:GetSpecialValueFor("green"),self:GetSpecialValueFor("blue")))

		else
			self:SetupSpell()
		end
	end
end


function wizard_spell_component_base:SetupSpell()
	local hCaster = self:GetCaster()
	local keys = {}
	keys.m_hCaster = hCaster
  keys.m_bTargetSelf = false
  keys.m_bTargetAlly = false
	keys.m_bNoTarget = self:GetCursorTargetingNothing()
	keys.m_vPointTarget = self:GetCursorPosition()
	--Get target
		local iTeam = hCaster:GetTeam()
		local tTargets = FindUnitsInRadius(iTeam,
		keys.m_vPointTarget,
		nil,
		300,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_CLOSEST,
		false)
		if (#tTargets > 0) then
			keys.m_hUnitTarget = tTargets[1]
			keys.m_bNoTarget = false
			if (hCaster == tTargets[1]) then
				print("Caster is closest")
			else
				print("Found someone!")
			end
		else
			print("search came empty!")
			keys.m_hUnitTarget = hCaster
			keys.m_bNoTarget = true
		end
		
  keys.m_bTargetAlly = false
  if keys.m_bNoTarget == false then
    if keys.m_hUnitTarget ~= nil and keys.m_hUnitTarget:GetTeam() == hCaster:GetTeam() then
      keys.m_bTargetAlly = true
    end
  end
  if keys.m_bNoTarget == false then
    if keys.m_hUnitTarget ~= nil and hCaster == keys.m_hUnitTarget then
      keys.m_bTargetAlly = true
      keys.m_bTargetSelf = true
    end
	end
	
	if keys.m_bNoTarget then 
		keys.m_bTargetSelf = true
		keys.m_bTargetAlly = true
		keys.m_hUnitTarget = hCaster
	end
	hCaster:AddNewModifier(hCaster, self, "wizard_casting_modifier",{})
	self.m_hMasterSpell:StartSpell(keys)
	self.m_hMasterSpell:NewComponent(self:GetSpecialValueFor( "id" ),self:GetLevel(), Vector(self:GetSpecialValueFor("red"),self:GetSpecialValueFor("green"),self:GetSpecialValueFor("blue")))


end

function wizard_spell_component_base:ModifySpell()
	self.m_hMasterSpell:NewComponent(self:GetSpecialValueFor( "id" ),self:GetLevel(), Vector(self:GetSpecialValueFor("red"),self:GetSpecialValueFor("green"),self:GetSpecialValueFor("blue")))
end

function wizard_spell_component_base:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName("wizard_casting_modifier")
	if (hModifier ~= nil) then hModifier:Destroy() end
	self.m_hMasterSpell:SpellChannelFinish(bInterrupted)
end

function wizard_spell_component_base:OnChannelThink(flInterval)
end

function wizard_spell_component_base:GetChannelTime()
	return 5.0
end

function wizard_spell_component_base:OnUpgrade()
	local hCaster = self:GetCaster()
	local hCaster = self:GetCaster()
	self.m_hMasterSpell = hCaster:FindAbilityByName("wizard_spell_manager")
	if self.m_hMasterSpell ~= nil then
		if self:GetLevel() == 1 then
			self.m_hMasterSpell:InitWizzard()
		else
			self.m_hMasterSpell:SetLevel(self.m_hMasterSpell:GetLevel()+1)
			--print(self.m_hMasterSpell:GetLevel())
		end
	end
end

return wizard_spell_component_base
