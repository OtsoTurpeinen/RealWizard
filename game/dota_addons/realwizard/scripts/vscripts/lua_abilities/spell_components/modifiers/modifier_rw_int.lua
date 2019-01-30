if rw_int == nil then
    rw_int = class({})
end

function rw_int:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_int:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end

function rw_int:IsHidden() return false end
function rw_int:IsPermanent() return false end
function rw_int:IsPurgable() return true end
function rw_int:AllowIllusionDuplicate() return false end

function rw_int:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self:SetDuration(self.power_b,true)
    end
end


function rw_int:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
		}
	return funcs
end


function rw_int:GetModifierBonusStats_Intellect()
	return self:GetStackCount()*10
end



function rw_int:IsDebuff() return false end

function rw_int:GetEffectName()
	return "particles/rw_modifiers/rw_int.vpcf"
end
 
function rw_int:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_int:GetTexture()
	return "rw_mod/rw_int"
end