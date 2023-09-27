local mod = SweetPack

local description = {
	"{{HalfHeart}} Heals half a red heart when entering an uncleared room at or below three red hearts",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_HIS_BLOOD, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_HIS_BLOOD, description)



function mod:HisBloodHeal()
	if Game():GetRoom():IsClear() == false then
		for i = 0, Game():GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			local doEffect = false

			-- Heal
			for j = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HIS_BLOOD, false) do
				if player:HasFullHearts () == false and player:GetHearts() <= 6 then
					player:AddHearts(1)
					doEffect = true
				end
			end

			-- Effects
			if doEffect == true then
				local visual = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector.Zero, nil):ToEffect()
				visual:FollowParent(player)
				visual.DepthOffset = player.DepthOffset + 10
				visual.SpriteOffset = Vector(0, player.SpriteScale.Y * -35)

				SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.HisBloodHeal)