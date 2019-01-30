if rw_freeze == nil then
    rw_freeze = class({})
end

function rw_freeze:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_freeze:IsHidden() return false end
function rw_freeze:IsPermanent() return false end
function rw_freeze:IsPurgable() return true end
function rw_freeze:AllowIllusionDuplicate() return false end

function rw_freeze:OnCreated(keys)
	if IsServer() then
		self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self.interval = 0.05*self.power_b
		self:StartIntervalThink(self.interval)
		self:CalculateDuration()
	end
end


function rw_freeze:OnRefresh( keys )
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

function rw_freeze:CalculateDuration()
	self:SetDuration( self:GetStackCount()*self.interval, true )
end

function rw_freeze:GetTexture()
	return "rw_mod/rw_freeze"
end

function rw_freeze:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local nDamageCalc = self:GetStackCount()*3
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
function rw_freeze:IsDebuff() return true end

function rw_freeze:DeclareFunctions()
	local funcs = {}
		funcs = {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
		}
	return funcs
end


function rw_freeze:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*-10
end


function rw_freeze:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()*-10
end


function rw_freeze:GetEffectName()
	return "particles/rw_modifiers/rw_freeze.vpcf"
end
 
function rw_freeze:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
 

function rw_freeze:IsDebuff() return true end