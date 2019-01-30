if rw_health_rgn == nil then
    rw_health_rgn = class({})
end

function rw_health_rgn:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_health_rgn:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end

function rw_health_rgn:IsHidden() return false end
function rw_health_rgn:IsPermanent() return false end
function rw_health_rgn:IsPurgable() return true end
function rw_health_rgn:AllowIllusionDuplicate() return false end

function rw_health_rgn:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self:SetDuration(self.power_b,true)
    end
end


function rw_health_rgn:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
		}
	return funcs
end


function rw_health_rgn:GetModifierConstantHealthRegen()
	return self:GetStackCount()*5
end


function rw_health_rgn:IsDebuff() return false end

function rw_health_rgn:GetEffectName()
	return "particles/rw_modifiers/rw_health_rgn.vpcf"
end
 
function rw_health_rgn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_health_rgn:GetTexture()
	return "rw_mod/rw_health_rgn"
end