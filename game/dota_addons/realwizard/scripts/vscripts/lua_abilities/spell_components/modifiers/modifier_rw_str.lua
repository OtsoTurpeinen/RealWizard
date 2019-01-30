if rw_str == nil then
    rw_str = class({})
end

function rw_str:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_str:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end

function rw_str:IsHidden() return false end
function rw_str:IsPermanent() return false end
function rw_str:IsPurgable() return true end
function rw_str:AllowIllusionDuplicate() return false end

function rw_str:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self:SetDuration(self.power_b,true)
    end
end


function rw_str:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
		}
	return funcs
end


function rw_str:GetModifierBonusStats_Strength()
	return self:GetStackCount()*10
end


function rw_str:IsDebuff() return false end

function rw_str:GetEffectName()
	return "particles/rw_modifiers/rw_str.vpcf"
end
 
function rw_str:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_str:GetTexture()
	return "rw_mod/rw_str"
end