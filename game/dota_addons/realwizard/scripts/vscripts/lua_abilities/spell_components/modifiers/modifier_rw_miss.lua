if rw_miss == nil then
    rw_miss = class({})
end

function rw_miss:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_miss:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end

function rw_miss:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    
    end
end


function rw_miss:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_MISS_PERCENTAGE
		}
	return funcs
end


function rw_miss:GetModifierMiss_Percentage()
	return self:GetStackCount()*5
end

function rw_miss:IsDebuff() return false end

function rw_miss:GetEffectName()
	return "particles/rw_modifiers/rw_miss.vpcf"
end
 
function rw_miss:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_miss:GetTexture()
	return "rw_mod/rw_miss"
end
