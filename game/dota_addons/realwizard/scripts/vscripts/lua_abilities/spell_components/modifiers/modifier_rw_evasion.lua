if rw_evasion == nil then
    rw_evasion = class({})
end

function rw_evasion:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_evasion:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end


function rw_evasion:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys) 
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    end
end


function rw_evasion:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_EVASION_CONSTANT
		}
	return funcs
end


function rw_evasion:GetModifierEvasion_Constant()
	return self:GetStackCount()*2
end



function rw_evasion:IsDebuff() return false end

function rw_evasion:GetEffectName()
	return "particles/rw_modifiers/rw_evasion.vpcf"
end
 
function rw_evasion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_evasion:GetTexture()
	return "rw_mod/rw_evasion"
end