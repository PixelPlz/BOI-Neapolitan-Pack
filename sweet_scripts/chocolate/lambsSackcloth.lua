local mod = SweetPack

local description = {
	"Entering an uncleared normal room grants 1-2 blue flies and 0-1 blue spiders",
	"{{MiniBoss}} Entering an uncleared miniboss room spawns 2-3 blue flies and 1-2 blue spiders",
	"{{BossRoom}} Entering an uncleared boss room spawns 5 horsemen locusts",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_LAMBS_SACKCLOTH, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_LAMBS_SACKCLOTH, description)



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
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.LambSackNewRoom)