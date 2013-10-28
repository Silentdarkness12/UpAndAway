--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/grass.zip"),
	Asset("ANIM", "anim/grass1.zip"),
}

local prefabs =
{
	"cloud_algae_fragment",
}

local loot =
{
	"cloud_algae_fragment",
	"cloud_algae_fragment",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()

	minimap:SetIcon( "grass.png" )
	    
	anim:SetBank("grass")
	anim:SetBuild("grass1")
	anim:PlayAnimation("idle",true)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(mined) 

   	inst:AddComponent("lootdropper") 
   	inst.components.lootdropper:SetLoot(loot)        

	return inst
end

return Prefab ("common/inventory/cloud_algae", fn, assets) 
