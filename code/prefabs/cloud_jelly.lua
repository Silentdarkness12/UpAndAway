BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),

    Asset( "ATLAS", "images/inventoryimages/cloud_jelly.xml" ),
    Asset( "IMAGE", "images/inventoryimages/cloud_jelly.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_jelly.xml"

	return inst
end

return Prefab ("common/inventory/cloud_jelly", fn, assets) 