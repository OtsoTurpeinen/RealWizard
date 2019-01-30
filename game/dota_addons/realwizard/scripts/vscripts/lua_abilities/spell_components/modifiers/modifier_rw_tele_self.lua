if rw_tele_self == nil then
    rw_tele_self = class({})
end

function rw_tele_self:SuperOnCreated(keys)
    self.data = keys
    self.power_a = keys.power_a
    self.power_b = keys.power_b
end

function rw_tele_self:IsHidden() return false end
function rw_tele_self:IsPermanent() return false end
function rw_tele_self:IsPurgable() return true end
function rw_tele_self:AllowIllusionDuplicate() return false end

function rw_tele_self:OnCreated(keys)
	if IsServer() then
		self:SuperOnCreated(keys)
        self:Blink(self:GetCaster(),self:GetParent():GetAbsOrigin())--,1000,100)
		self:Destroy()
    end
end



function rw_tele_self:Blink(hTarget, vPoint)--, nMaxBlink, nClamp)
    local vOrigin = hTarget:GetAbsOrigin() --Our units's location
    ProjectileManager:ProjectileDodge(hTarget)  --We disjoint disjointable incoming projectiles.
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hTarget) --Create particle effect at our caster.
    hTarget:EmitSound("DOTA_Item.BlinkDagger.Activate") --Emit sound for the blink
    --local vDiff = vPoint - vOrigin --Difference between the points
    --if vDiff:Length2D() > nMaxBlink then  --Check caster is over reaching.
    --    vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp -- Recalculation of the target point.
    --end
    hTarget:SetAbsOrigin(vPoint) --We move the caster instantly to the location
    FindClearSpaceForUnit(hTarget, vPoint, false) --This makes sure our caster does not get stuck
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hTarget) --Create particle effect at our caster.
end