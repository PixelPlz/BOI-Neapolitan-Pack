local mod = SweetPack

local descriptionEN = {
	"Entering an uncleared normal room grants 1-2 blue flies and 0-1 blue spiders",
	"{{MiniBoss}} Entering an uncleared miniboss room spawns 2-3 blue flies and 1-2 blue spiders",
	"{{BossRoom}} Entering an uncleared boss room spawns 5 horsemen locusts",
}
local descriptionRU = {
	"При входе в неочищенную обычную комнату дает 1-2 синих мух и 0-1 синих пауков",
	"{{MiniBoss}} При входе в неочищенную комнату минибосса создает 2-3 синих мух и 1-2 синих пауков",
	"{{BossRoom}} При входе в неочищенную комнату босса создает 5 саранчи всадников",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_LAMBS_SACKCLOTH, descriptionEN, "Lamb's Sackcloth", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_LAMBS_SACKCLOTH, descriptionRU, "Мешковина ягненка", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_LAMBS_SACKCLOTH, descriptionEN)



function mod:LambSackNewRoom()
	local room = Game():GetRoom()

	if room:IsClear() == false then
		for i = 0, Game():GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)

			for j = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LAMBS_SACKCLOTH, false) do
				-- Locusts in boss rooms
				if room:GetType() == RoomType.ROOM_BOSS then
					for k = 1, 5 do
						Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, k, player.Position, Vector.Zero, player)
					end

				-- Blue flies and spiders in regular and miniboss rooms
				else
					-- Get the amount to spawn
					local flyCount = {1, 2}
					local spiderCount = {0, 1}
					if room:GetType() == RoomType.ROOM_MINIBOSS then
						flyCount = {2, 3}
						spiderCount = {1, 2}
					end

					-- Blue flies
					flyCount = mod:Random(flyCount[1], flyCount[2])
					player:AddBlueFlies(flyCount, player.Position, nil)

					-- Blue spiders
					spiderCount = mod:Random(spiderCount[1], spiderCount[2])
					for k = 1, spiderCount do
						local pos = player.Position + mod:RandomVector(30)
						player:ThrowBlueSpider(player.Position, pos)
					end
				end

				-- Sound
				SFXManager():Play(SoundEffect.SOUND_MENU_RIP, 1.25)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.LambSackNewRoom)