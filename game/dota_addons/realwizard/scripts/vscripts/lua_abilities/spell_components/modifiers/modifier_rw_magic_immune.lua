if rw_magic_immune == nil then
    rw_magic_immune = class({})
end

function rw_magic_immune:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end
function rw_magic_immune:OnRefresh( keys )
    if IsServer() then
        local duration = self:GetDuration()
		self.power_a = keys.power_a
		self.power_b = keys.power_b
		local dur = self.power_b*0.25+self.power_a*0.05
		self:SetDuration(math.max(duration,dur),true)
    end
end


function rw_magic_immune:OnCreated(keys)
	if IsServer() then
        self:SuperOnCreated(keys)
            self:SetDuration(self.power_b*0.25+self.power_a*0.05,true)
    end
end



function rw_magic_immune:CheckState()
	local state = {
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return state
end

function rw_magic_immune:IsDebuff()
	return false
end

 function rw_magic_immune:IsPurgable() 
	return false
end
 
function rw_magic_immune:GetEffectName()
		return "particles/items_fx/black_king_bar_avatar.vpcf"
end
 
function rw_magic_immune:GetEffectAttachType()
		return PATTACH_OVERHEAD_FOLLOW
end
 

function rw_magic_immune:GetTexture()
	return "rw_mod/rw_magic_immune"
end