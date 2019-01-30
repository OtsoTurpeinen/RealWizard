if rw_haste == nil then
    rw_haste = class({})
end

function rw_haste:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_haste:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end

function rw_haste:IsHidden() return false end
function rw_haste:IsPermanent() return false end
function rw_haste:IsPurgable() return true end
function rw_haste:AllowIllusionDuplicate() return false end

function rw_haste:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    end
end


function rw_haste:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
		}
	return funcs
end


function rw_haste:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*20
end


function rw_haste:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()*20
end



function rw_haste:IsDebuff() return false end

function rw_haste:GetEffectName()
	return "particles/rw_modifiers/rw_haste.vpcf"
end
 
function rw_haste:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_haste:GetTexture()
	return "rw_mod/rw_haste"
end