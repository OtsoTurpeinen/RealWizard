if rw_slow == nil then
    rw_slow = class({})
end

function rw_slow:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_slow:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end
function rw_slow:IsHidden() return false end
function rw_slow:IsPermanent() return false end
function rw_slow:IsPurgable() return true end
function rw_slow:AllowIllusionDuplicate() return false end

function rw_slow:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self:SetDuration(self.power_b,true)
    end
end


function rw_slow:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
		}
	return funcs
end


function rw_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*-20
end


function rw_slow:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()*-20
end


function rw_slow:IsDebuff() return false end

function rw_slow:GetEffectName()
	return "particles/rw_modifiers/rw_slow.vpcf"
end
 
function rw_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_slow:GetTexture()
	return "rw_mod/rw_slow"
end