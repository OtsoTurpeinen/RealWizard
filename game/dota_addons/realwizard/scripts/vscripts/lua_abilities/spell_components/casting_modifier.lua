if wizard_casting_modifier == nil then
    wizard_casting_modifier = class({})
end

function wizard_casting_modifier:OnCreated(keys)
end

function wizard_casting_modifier:OnDestroy()

end

function wizard_casting_modifier:IsDebuff() return false end
function wizard_casting_modifier:IsHidden() return false end
function wizard_casting_modifier:IsPermanent() return true end
function wizard_casting_modifier:IsPurgable() return false end
function wizard_casting_modifier:IsPurgeException() return false end
function wizard_casting_modifier:IsStunDebuff() return false end
function wizard_casting_modifier:AllowIllusionDuplicate() return false end
function wizard_casting_modifier:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end


--[[
Ideas:
	Focal Crystal : Spell has 50% chance of being cast even if channel is interrupted.
	+Dragon Claws (Gloves) : Spell is cast even if the channel is interrupted.
	Veil of Whispers : Component effect sound is replaced with unidentifiable sound.
	+Mask of Silence : Component effect sound is disabled.
	Staff of Apprentice : Component particle has 50% chance of not appearing.
	+Staff of Teacher : Component particle is show to team only.
	+Staff of Deception : Component particle shows random component.
	Empty Scroll : Use to store next spell to this scroll.
	Filled Scroll : Use to cast stored spell.




]]--
