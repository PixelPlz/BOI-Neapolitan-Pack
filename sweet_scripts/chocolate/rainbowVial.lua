local mod = SweetPack

local description = {
	"{{Heart}} +1 Health up",
	"{{SoulHeart}} +1 Soul Heart",
	"{{EternalHeart}} +1 Eternal Heart",
	"{{BlackHeart}} +1 Black Heart",
	"{{GoldenHeart}} +1 Golden Heart",
	"{{BoneHeart}} +1 Bone Heart",
	"{{RottenHeart}} +1 Rotten Heart",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_RAINBOW_VIAL, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_RAINBOW_VIAL, description)



-- Give the hearts
function mod:GiveRainbowHearts(player)
    local data = player:GetData()

    if player:HasCollectible(CollectibleType.COLLECTIBLE_RAINBOW_VIAL, true)
    and (not data.RainbowVialHearts or data.RainbowVialHearts < player:GetCollectibleNum(CollectibleType.COLLECTIBLE_RAINBOW_VIAL, true)) then
        if not data.RainbowVialHearts then
            data.RainbowVialHearts = 0
        end
		data.RainbowVialHearts = data.RainbowVialHearts + 1

		player:AddEternalHearts(1)
        player:AddGoldenHearts(1)
        player:AddBoneHearts(1)
		player:AddRottenHearts(1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveRainbowHearts)