if wizard_default_modifier == nil then
    wizard_default_modifier = class({})
end


function wizard_default_modifier:OnCreated(keys)
    if IsServer() then
        self.spell_count = 10
        self.maxSpellCount = 10
		local hCaster = self:GetCaster()
        local hAbility
        for i = 1,6 do
            hAbility = hCaster:FindAbilityByName("wizard_spell_component_"..i)
            hAbility:SetLevel(hAbility:GetLevel()+1)
        end
        self:SetStackCount(self.spell_count)
    end
end

function wizard_default_modifier:CooldownDone()
    self:IncrementStackCount()
    if (self.spell_count == self.maxSpellCount) then
        self:SetDuration(0,true)
    end 
end

function wizard_default_modifier:SpendCooldown(cool)
    self:PutOnCooldown(cool)
    --[[
        
    if (self:GetStackCount() > 0) then
        self:DecrementStackCount()
        --if (self.spell_count == self.maxSpellCount) then
            self:SetDuration(math.max(self:GetDuration(),cool),true)
            local hCaster = self:GetCaster()
			hCaster:AddNewModifier(hCaster, self:GetAbility(),"wizard_cooldown_modifier" ,{duration = cool})
        --end
        if (self:GetStackCount() == 0) then
            self:PutOnCooldown(cool)
        end
    end
    ]]
end


function wizard_default_modifier:PutOnCooldown(cool)
    local hCaster = self:GetCaster()
    --[[
    local tCooldowns = hCaster:FindAllModifiersByName("wizard_cooldown_modifier")
    local lowest = cool
    for i = 1,#tCooldowns do
        lowest = math.min(lowest,tCooldowns[i]:GetDuration()-tCooldowns[i]:GetElapsedTime())
    end
    ]]--
	local hAbility
	for i = 1,6 do
		hAbility = hCaster:FindAbilityByName("wizard_spell_component_"..i)
		if (hAbility ~= nil) then
			hAbility:StartCooldown(cool)
		end
	end
end

function wizard_default_modifier:IsDebuff() return false end
 
function wizard_default_modifier:GetTexture()
	return "rw_mod/wizard_default_modifier"
end

function wizard_default_modifier:DestroyOnExpire() return false end
function wizard_default_modifier:IsDebuff() return false end
function wizard_default_modifier:IsHidden() return false end
function wizard_default_modifier:IsPermanent() return true end
function wizard_default_modifier:IsPurgable() return false end
function wizard_default_modifier:IsPurgeException() return false end
function wizard_default_modifier:IsStunDebuff() return false end
function wizard_default_modifier:AllowIllusionDuplicate() return false end
function wizard_default_modifier:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

if wizard_cooldown_modifier == nil then
    wizard_cooldown_modifier = class({})
end

function wizard_cooldown_modifier:IsHidden() return true end


function wizard_cooldown_modifier:OnCreated(keys)
    if IsServer() then
        self.callback = self:GetParent():FindModifierByName("wizard_default_modifier")
        self:StartIntervalThink(keys.duration)
    end
end

function wizard_cooldown_modifier:OnIntervalThink()
    if IsServer() then
        self:Destroy()
    end
end
function wizard_cooldown_modifier:OnDestroy()
    if IsServer() then
        self.callback:CooldownDone()
    end
end

function wizard_cooldown_modifier:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

