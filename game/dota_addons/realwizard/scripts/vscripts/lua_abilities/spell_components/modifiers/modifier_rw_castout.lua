if rw_castout == nil then
    rw_castout = class({})
end

function rw_castout:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
--[[
function rw_castout:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end
	
]]--

function rw_castout:IsHidden() return false end
function rw_castout:IsPermanent() return false end
function rw_castout:IsPurgable() return true end
function rw_castout:AllowIllusionDuplicate() return false end

function rw_castout:OnCreated(keys)
	if IsServer() then
		self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self:SetDuration(self.power_b*0.25+self.power_a*0.05,true)
		ProjectileManager:ProjectileDodge(self:GetCaster())
		 self:GetParent():AddNoDraw()
		  local nFXIndex = ParticleManager:CreateParticle( "particles/rw_modifiers/rw_castout.vpcf", PATTACH_WORLDORIGIN, nil )
		  ParticleManager:SetParticleControl( nFXIndex, 0,self:GetParent():GetAbsOrigin())
		  ParticleManager:SetParticleControlEnt(nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		  ParticleManager:SetParticleControl( nFXIndex, 6,self:GetParent():GetForwardVector())
		  ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end


function rw_castout:OnDestroy()
	if IsServer() then
	  	ProjectileManager:ProjectileDodge(self:GetCaster())
		self:GetParent():RemoveNoDraw()
		local nFXIndex = ParticleManager:CreateParticle( "particles/rw_modifiers/rw_castout.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0,self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
	end
end
function rw_castout:CheckState()
	local state = {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_ATTACK_IMMUNE] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
 -- [MODIFIER_STATE_MAGIC_IMMUNE] = true,
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_STUNNED] = true
	}
	return state
end



function rw_castout:IsDebuff() return true end

 
function rw_castout:GetTexture()
	return "rw_mod/rw_castout"
end