BindGlobal()

local assets =
{
	Asset("ANIM", "anim/golden_petals.zip"),

	Asset( "ATLAS", "images/inventoryimages/golden_petals.xml" ),
	Asset( "IMAGE", "images/inventoryimages/golden_petals.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("golden_petals")
	inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

   	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 10
    
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/golden_petals.xml"

	return inst
end

return Prefab ("common/inventory/golden_petals", fn, assets) 
