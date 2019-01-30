if rw_stun == nil then
    rw_stun = class({})
end

function rw_stun:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_stun:IsHidden() return false end
function rw_stun:IsPermanent() return false end
function rw_stun:IsPurgable() return true end
function rw_stun:AllowIllusionDuplicate() return false end

function rw_stun:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
            self:SetStackCount(1)
            self:SetDuration(self.power_b*0.25+self.power_a*0.05,true)
        
    end
end



function rw_stun:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function rw_stun:IsDebuff()
	return true
end
 
function rw_stun:IsStunDebuff()
	return true
end

 function rw_stun:IsPurgable() 
	return false
end

function rw_stun:IsPurgeException()
	return true
end
 
function rw_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end
 
function rw_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
 

function rw_stun:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION 
	}
	return funcs
end

function rw_stun:GetOverrideAnimation( )
	return ACT_DOTA_DISABLED
end

 
function rw_stun:GetTexture()
	return "rw_mod/rw_stun"
end