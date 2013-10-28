--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/kiki_basic.zip"),
	Asset("ANIM", "anim/kiki_build.zip"),
	Asset("ANIM", "anim/kiki_nightmare_skin.zip"),
	Asset("SOUND", "sound/monkey.fsb"),
}

local prefabs =
{
   --"crystal_black_fragment",
}

local loot = 
{
   --"crystal_black_fragment",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("kiki")
	inst.AnimState:SetBuild("kiki_basic")
	
	inst.AnimState:PlayAnimation("idle_loop", true)    

	inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

	return inst
end

return Prefab ("common/inventory/sky_lemur", fn, assets, prefabs) 
