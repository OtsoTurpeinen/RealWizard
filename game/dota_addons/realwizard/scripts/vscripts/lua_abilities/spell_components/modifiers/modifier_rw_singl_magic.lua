if rw_singl_magic == nil then
    rw_singl_magic = class({})
end

function rw_singl_magic:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_singl_magic:IsHidden() return false end
function rw_singl_magic:IsPermanent() return false end
function rw_singl_magic:IsPurgable() return true end
function rw_singl_magic:AllowIllusionDuplicate() return false end

function rw_singl_magic:OnCreated(keys)
	if IsServer() then
		self:SuperOnCreated(keys)
		local hAbility = self:GetAbility()
		local nDamageCalc = self.power_b*self.power_a*2
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = nDamageCalc,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility
		}
		local dm = ApplyDamage(damageTable)
		local part = "particles/msg_fx/msg_damage.vpcf"
		local digits = self:countDigits(dm)
		
		local nFXIndex = ParticleManager:CreateParticle( part, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1,Vector(0,dm,4))
		ParticleManager:SetParticleControl( nFXIndex, 2,Vector(digits*0.5,digits+1,0))
		ParticleManager:SetParticleControl( nFXIndex, 3,Vector(255,50,150))
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		
		self:Destroy()
    end
end
function rw_singl_magic:countDigits(num)
	local count=0;
	while(num > 1) do
	  num=num/10;
	  count = count + 1;
	end
	return count;
end