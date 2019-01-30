if rw_agi == nil then
    rw_agi = class({})
end

function rw_agi:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_agi:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b),true)
    end
end


function rw_agi:IsHidden() return false end
function rw_agi:IsPermanent() return false end
function rw_agi:IsPurgable() return true end
function rw_agi:AllowIllusionDuplicate() return false end

function rw_agi:OnCreated(keys)
	if IsServer() then
         self:SuperOnCreated(keys)
            self:SetStackCount(self.power_a)
            self:SetDuration(self.power_b,true)
    end
end


function rw_agi:DeclareFunctions()
	local funcs = {}
		funcs = {
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS
		}
	return funcs
end


function rw_agi:GetModifierBonusStats_Agility()
	return self:GetStackCount()*10
end

function rw_agi:IsDebuff() return false end

function rw_agi:GetEffectName()
	return "particles/rw_modifiers/rw_agi.vpcf"
end
 
function rw_agi:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_agi:GetTexture()
	return "rw_mod/rw_agi"
end