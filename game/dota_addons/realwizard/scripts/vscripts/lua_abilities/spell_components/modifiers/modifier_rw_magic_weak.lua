if rw_magic_weak == nil then
    rw_magic_weak = class({})
end

function rw_magic_weak:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_magic_weak:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end


function rw_magic_weak:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys) 
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    end
end


function rw_magic_weak:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
		}
	return funcs
end


function rw_magic_weak:GetModifierMagicalResistanceBonus()
	return self:GetStackCount()*-3
end


function rw_magic_weak:IsDebuff() return true end

function rw_magic_weak:GetEffectName()
	return "particles/rw_modifiers/rw_magic_weak.vpcf"
end
 
function rw_magic_weak:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_magic_weak:GetTexture()
	return "rw_mod/rw_magic_weak"
end