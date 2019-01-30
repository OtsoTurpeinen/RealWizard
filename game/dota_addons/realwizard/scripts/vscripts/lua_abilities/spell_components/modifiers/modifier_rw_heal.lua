if rw_heal == nil then
    rw_heal = class({})
end

function rw_heal:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_heal:IsHidden() return false end
function rw_heal:IsPermanent() return false end
function rw_heal:IsPurgable() return true end
function rw_heal:AllowIllusionDuplicate() return false end

function rw_heal:OnCreated(keys)
	if IsServer() then
		self:SuperOnCreated(keys)
		self:GetParent():Heal(self.power_b*self.power_a,self:GetAbility())
		local dm = self.power_b*self.power_a
		local part = "particles/msg_fx/msg_damage.vpcf"
		local digits = self:countDigits(dm)
		
		local nFXIndex = ParticleManager:CreateParticle( part, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1,Vector(0,dm,0))
		ParticleManager:SetParticleControl( nFXIndex, 2,Vector(digits*0.5,digits+1,0))
		ParticleManager:SetParticleControl( nFXIndex, 3,Vector(50,250,50))
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		self:Destroy()
    end
end


function rw_heal:countDigits(num)
	local count=0;
	while(num > 1) do
	  num=num/10;
	  count = count + 1;
	end
	return count;
end