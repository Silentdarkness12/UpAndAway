--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/rock_stalagmite.zip"),
}

local prefabs =
{
   --"crystal_white_fragment",
}

local loot = 
{
   --"crystal_white_fragment",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("rock_stalagmite")
	inst.AnimState:SetBuild("rock_stalagmite")
    inst.AnimState:PlayAnimation("full")

	inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

	return inst
end

return Prefab ("common/inventory/monolith", fn, assets, prefabs) 
