if rw_damage_in == nil then
    rw_damage_in = class({})
end

function rw_damage_in:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_damage_in:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b*2),true)
    end
end


function rw_damage_in:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys) 
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b*2,true)
    end
end


function rw_damage_in:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
		}
	return funcs
end


function rw_damage_in:GetModifierIncomingDamage_Percentage()
	return self:GetStackCount()*2
end



function rw_damage_in:IsDebuff() return true end

function rw_damage_in:GetEffectName()
	return "particles/rw_modifiers/rw_damage_in.vpcf"
end
 
function rw_damage_in:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_damage_in:GetTexture()
	return "rw_mod/rw_damage_in"
end