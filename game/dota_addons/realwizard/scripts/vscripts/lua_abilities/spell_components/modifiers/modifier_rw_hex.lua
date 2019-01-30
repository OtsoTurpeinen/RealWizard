
if rw_hex == nil then
    rw_hex = class({})
end

function rw_hex:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_hex:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
        self.power_b = keys.power_b
        self:SetStackCount(math.max(self.power_a,self:GetStackCount()))
        self:SetDuration(math.max(duration,self.power_b*0.3),true)
    end
end

function rw_hex:IsHidden() return false end
function rw_hex:IsPermanent() return false end
function rw_hex:IsPurgable() return true end
function rw_hex:AllowIllusionDuplicate() return false end

function rw_hex:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
		self:SetStackCount(self.power_a)
		self:SetDuration(self.power_b*0.3,true)
    end
end


function rw_hex:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_MOVESPEED_MAX
		}
	return funcs
end



function rw_hex:GetModifierModelChange ()
	return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end

function rw_hex:CheckState()
	local state = {
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
	return state
end

function rw_hex:IsDebuff() return true end

function rw_hex:GetTexture()
	return "rw_mod/rw_hex"
end

function rw_hex:GetModifierMoveSpeedOverride() return 300-self:GetStackCount()*3 end
function rw_hex:GetModifierMoveSpeedMax() return  300-self:GetStackCount()*3  end
