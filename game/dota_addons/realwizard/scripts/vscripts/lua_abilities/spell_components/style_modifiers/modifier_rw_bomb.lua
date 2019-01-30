if rw_bomb == nil then
	rw_bomb = class({})
end


function rw_bomb:OnCreated(keys)
	if IsServer() then
        self.data = keys
        --self.nFXIndex = ParticleManager:CreateParticle( self.data.spell_bomb, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        --ParticleManager:SetParticleControl( self.nFXIndex, 14, Vector( 1, 1, 1 ) )
        --ParticleManager:SetParticleControl( self.nFXIndex, 15, Vector( 255, 50, 0 ) )
		--self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		self.activateTime = 4.0
		self.duration = 20.0
        self:StartIntervalThink(0.33)
        
        self.btarget = EntIndexToHScript(self.data.bomb_target) --Find the target with the ent index
		self:GetParent():SetForceAttackTarget(self.btarget)
    end
end

function rw_bomb:OnIntervalThink()
	self.duration = self.duration - 0.33
    if self.duration <= 0.0 then
        self:Explode()
    end
end

function rw_bomb:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START
		}
    return funcs
end

function rw_bomb:CheckState()
    local state = {}
    state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
    return state
end



function rw_bomb:OnAttackStart(keys)
    if (keys.attacker == self:GetParent()) then
        self:Explode()
    end
end

function rw_bomb:Explode()
    local vLocation = self:GetParent():GetAbsOrigin()
    local hAbility = self:GetAbility()
	local hCaster = hAbility:GetCaster()
	local iTeam = hCaster:GetTeam()
	local sModifier = self.data.mod_a
	local sModifier_ex = self.data.mod_b
	local bDouble = (self.data.extra_style == 2) --1 = no extra, 2 = target extra, 3 = self extra
	local bReaction = (self.data.extra_style == 4) --1 = no extra, 2 = target extra, 3 = self extra
	local keys = {
		power_b = self.data.power_b,
		power_a = self.data.power_a
	}
	local dkeys = {
		power_a = self.data.power_b,
		power_b = self.data.power_a
	}
	local tTargets = FindUnitsInRadius(iTeam,
							  vLocation,
							  nil,
							  self.data.aoe_size * 55+50,
							  DOTA_UNIT_TARGET_TEAM_BOTH,
							  DOTA_UNIT_TARGET_ALL,
							  DOTA_UNIT_TARGET_FLAG_NONE,
							  FIND_ANY_ORDER,
							  false)
	for _,hUTarget in pairs(tTargets) do
		if (not hUTarget:IsMagicImmune()) then
			hUTarget:AddNewModifier(hCaster, hAbility, sModifier,keys)
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
	self.nFXIndex = ParticleManager:CreateParticle( self.data.spell_effect_aoe, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl(self.nFXIndex, 0, vLocation)
	ParticleManager:SetParticleControl(self.nFXIndex, 3, Vector(r,g,b))
	ParticleManager:SetParticleControl(self.nFXIndex, 4, Vector(r,g,b))
	ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(1,1,1))
	ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(self.data.aoe_size * 55,self.data.aoe_size * 55,self.data.aoe_size * 55))
    ParticleManager:ReleaseParticleIndex(self.nFXIndex)
    
    self:StartIntervalThink(-1)
    self:GetParent():ForceKill(false)
    self:GetParent():AddNoDraw()
end
function rw_bomb:GetEffectName()
	return "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile.vpcf"
end
 
function rw_bomb:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 