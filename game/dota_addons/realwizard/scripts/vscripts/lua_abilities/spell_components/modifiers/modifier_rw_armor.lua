if rw_armor == nil then
    rw_armor = class({})
end

function rw_armor:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_armor:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end


function rw_armor:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys) 
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    end
end


function rw_armor:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
		}
	return funcs
end


function rw_armor:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()*2
end


function rw_armor:IsDebuff() return false end

function rw_armor:GetEffectName()
	return "particles/rw_modifiers/rw_armor.vpcf"
end
 
function rw_armor:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
 
function rw_armor:GetTexture()
	return "rw_mod/rw_armor"
end
