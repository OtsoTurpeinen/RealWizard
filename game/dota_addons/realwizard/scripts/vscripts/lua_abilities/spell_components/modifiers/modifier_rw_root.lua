if rw_root == nil then
    rw_root = class({})
end

function rw_root:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_root:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = math.max(keys.power_a,self.power_a)
		self.power_b = math.max(keys.power_b,self.power_b)
		self:SetStackCount(self.power_b)
		self:StartIntervalThink(self.power_b*0.25/self.power_a)
		self:SetDuration(self.power_b*0.25,true)
    end
end

function rw_root:IsHidden() return false end
function rw_root:IsPermanent() return false end
function rw_root:IsPurgable() return true end
function rw_root:AllowIllusionDuplicate() return false end

function rw_root:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
            self:SetStackCount(self.power_b)
			self:StartIntervalThink(self.power_b*0.25/self.power_a)
            self:SetDuration(self.power_b*0.25,true)
    end
end

function rw_root:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local nDamageCalc = self:GetStackCount() * 3
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = nDamageCalc,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility
		}
		ApplyDamage(damageTable)
	end
end


function rw_root:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function rw_root:IsDebuff()
	return true
end
 
function rw_root:IsStunDebuff()
	return true
end

 function rw_root:IsPurgable() 
	return false
end

function rw_root:IsPurgeException()
	return true
end
 
function rw_root:GetEffectName()
	return "particles/rw_modifiers/rw_root.vpcf"
end
 
function rw_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
 
function rw_root:GetTexture()
	return "rw_mod/rw_root"
end