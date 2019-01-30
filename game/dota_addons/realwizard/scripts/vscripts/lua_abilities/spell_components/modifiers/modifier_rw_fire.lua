if rw_fire == nil then
    rw_fire = class({})
end

function rw_fire:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_fire:IsHidden() return false end
function rw_fire:IsPermanent() return false end
function rw_fire:IsPurgable() return true end
function rw_fire:AllowIllusionDuplicate() return false end


function rw_fire:OnCreated(keys)
	if IsServer() then
		self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self.interval = 0.05*self.power_b
		self:StartIntervalThink(self.interval)
		self:CalculateDuration()
	end
end


function rw_fire:OnRefresh( keys )
	if IsServer() then
		self.power_a = keys.power_a
		self.power_b = keys.power_b
		local stacks = self:GetStackCount() + self.power_a
		if stacks > 9999 then stacks = 9999 end
		self:SetStackCount(stacks)
		self.interval = 0.05*self.power_b
		self:StartIntervalThink(self.interval)
		self:CalculateDuration()
	end
end

function rw_fire:CalculateDuration()
	self:SetDuration( self:GetStackCount()*self.interval, true )
end

function rw_fire:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local nDamageCalc = self:GetStackCount() * 5
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = nDamageCalc,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility
		}
		ApplyDamage(damageTable) 
		self:DecrementStackCount()
		if self:GetStackCount() < 1 then
			self:Destroy()
		end
	end
end
function rw_fire:IsDebuff() return true end

function rw_fire:GetEffectName()
	return "particles/rw_modifiers/rw_fire.vpcf"
end
 
function rw_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 
function rw_fire:GetTexture()
	return "rw_mod/rw_fire"
end
