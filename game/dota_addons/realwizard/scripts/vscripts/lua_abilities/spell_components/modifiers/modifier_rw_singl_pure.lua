if rw_singl_pure == nil then
    rw_singl_pure = class({})
end

function rw_singl_pure:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_singl_pure:IsHidden() return false end
function rw_singl_pure:IsPermanent() return false end
function rw_singl_pure:IsPurgable() return true end
function rw_singl_pure:AllowIllusionDuplicate() return false end

function rw_singl_pure:OnCreated(keys)
	if IsServer() then
		self:SuperOnCreated(keys)
		local hAbility = self:GetAbility()
		local nDamageCalc = self.power_b*self.power_a*1.25
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = nDamageCalc,
			damage_type = DAMAGE_TYPE_PURE,
			ability = hAbility
		}
		local dm = ApplyDamage(damageTable)
		local part = "particles/msg_fx/msg_damage.vpcf"
		local digits = self:countDigits(dm)
		
		local nFXIndex = ParticleManager:CreateParticle( part, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1,Vector(0,dm,6))
		ParticleManager:SetParticleControl( nFXIndex, 2,Vector(digits*0.5,digits+1,0))
		ParticleManager:SetParticleControl( nFXIndex, 3,Vector(255,100,200))
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		
		self:Destroy()
    end
end
function rw_singl_pure:countDigits(num)
	local count=0;
	while(num > 1) do
	  num=num/10;
	  count = count + 1;
	end
	return count;
end
