if rw_invis == nil then
    rw_invis = class({})
end

function rw_invis:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_invis:OnRefresh( keys )
    self.invisBrokenAt = 0
    if IsServer() then
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetDuration(self.power_b,true)
    end
end

function rw_invis:OnCreated(keys)
	self.invisBrokenAt = 0
    if IsServer() then
        self:SuperOnCreated(keys)
        self:SetDuration(self.power_b,true)
    end
end

function rw_invis:OnAbilityExecuted(event)
		if event.unit == self:GetParent() then
            self:Destroy()
		end
end

function rw_invis:CheckState()
    local state = {}

	if IsServer() then
			state[MODIFIER_STATE_INVISIBLE] = self:CalculateInvisibilityLevel() == 1.0
    end

    return state
end

function rw_invis:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_ATTACK,
			MODIFIER_PROPERTY_INVISIBILITY_LEVEL
		}
    return funcs
end

function rw_invis:CalculateInvisibilityLevel()
    return math.min((self:GetElapsedTime() - self.invisBrokenAt) / self.power_a*10, 1.0)
end

function rw_invis:GetModifierInvisibilityLevel(params)
    if IsClient() then
        return self:GetStackCount() / 100
    end

    local level = self:CalculateInvisibilityLevel()

    if IsServer() then
        self:SetStackCount(math.ceil(level * 100))
    end

    return level
end

function rw_invis:OnAttack(event)
    if event.attacker == self:GetParent() then
        self:Destroy()
    end
end


function rw_invis:IsDebuff() return false end
--[[
function rw_invis:GetEffectName()
	return "particles/rw_modifiers/rw_invis.vpcf"
end
 
function rw_invis:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end]]
 
function rw_invis:GetTexture()
	return "rw_mod/rw_invis"
end