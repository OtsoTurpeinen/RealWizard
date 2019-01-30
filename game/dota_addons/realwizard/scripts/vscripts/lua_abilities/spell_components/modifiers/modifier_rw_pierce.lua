if rw_pierce == nil then
    rw_pierce = class({})
end

function rw_pierce:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_pierce:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end


function rw_pierce:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys) 
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    end
end


function rw_pierce:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
		}
	return funcs
end


function rw_pierce:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()*-3
end


function rw_pierce:IsDebuff() return true end

function rw_pierce:GetEffectName()
	return "particles/rw_modifiers/rw_pierce.vpcf"
end
 
function rw_pierce:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
 
function rw_pierce:GetTexture()
	return "rw_mod/rw_pierce"
end