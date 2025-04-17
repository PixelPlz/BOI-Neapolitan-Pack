local mod = SweetPack

local descriptionEN = {
    "{{Coin}} Entering a new floor grants +7 coins",
	"↑ +1 Health",
	"{{GoldenHeart}} +1 Golden Heart",
}
local descriptionRU = {
    "{{Coin}} Заходя на новый этаж дает +7 монет",
	"↑ +1 к здоровью",
	"{{GoldenHeart}} +1 Золотое Сердце",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_HEART_OF_GOLD, descriptionEN, "Heart of Gold", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_HEART_OF_GOLD, descriptionRU, "Сердце Золота", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_HEART_OF_GOLD, descriptionEN)



function mod.HeartOfGoldNewLevel()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        for j = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HEART_OF_GOLD, false) do
            player:AddCoins(7)
            SFXManager():Play(SoundEffect.SOUND_NICKELPICKUP, 0.5)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.HeartOfGoldNewLevel)



-- Give golden hearts
function mod:GiveHeartOfGold(player)
    local data = player:GetData()

    if player:HasCollectible(CollectibleType.COLLECTIBLE_HEART_OF_GOLD, true)
    and (not data.HeartsOfGold or data.HeartsOfGold < player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HEART_OF_GOLD, true)) then
        if not data.HeartsOfGold then
            data.HeartsOfGold = 0
        end
        data.HeartsOfGold = data.HeartsOfGold + 1

        player:AddGoldenHearts(1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveHeartOfGold)