SweetPack = RegisterMod("Neapolitan Pack", 1)
local mod = SweetPack



--[[ Load scripts ]]--
function mod:LoadScripts(scripts, subfolder)
	subfolder = subfolder or ""
	for i, script in pairs(scripts) do
		include("sweet_scripts." .. subfolder .. "." .. script)
	end
end


-- General
local generalScripts = {
	"constants",
	"library",
}
mod:LoadScripts(generalScripts)


-- Vanilla pack
local vanillaPackScripts = {
    "cinnamonGumball",
    "radRoach",
	"faustianDonut",
	"curseOfTheEmperor",
    "heartOfGold",
	"glassOfWater",
}
mod:LoadScripts(vanillaPackScripts, "vanilla")


-- Chocolate pack
local chocoPackScripts = {
    "lambsSackcloth",
	"tammysAshes",
    "drumOfWar",
	"hisBlood",
	"curseOfTheFool",
    "rainbowVial",
}
mod:LoadScripts(chocoPackScripts, "chocolate")


-- Neapolitan pack
local neapolitanPackScripts = {
	"elLoco",
    "x",
}
mod:LoadScripts(neapolitanPackScripts, "neapolitan")