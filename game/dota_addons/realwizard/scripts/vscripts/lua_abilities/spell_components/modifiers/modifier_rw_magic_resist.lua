if rw_magic_resist == nil then
    rw_magic_resist = class({})
end

function rw_magic_resist:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_magic_resist:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end


function rw_magic_resist:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys) 
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    end
end


function rw_magic_resist:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
		}
	return funcs
end


function rw_magic_resist:GetModifierMagicalResistanceBonus()
	return self:GetStackCount()*2
end


function rw_magic_resist:IsDebuff() return false end

function rw_magic_resist:GetEffectName()
	return "particles/rw_modifiers/rw_magic_resist.vpcf"
end
 
function rw_magic_resist:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_magic_resist:GetTexture()
	return "rw_mod/rw_magic_resist"
end