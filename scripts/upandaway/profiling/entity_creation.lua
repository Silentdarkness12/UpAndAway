---
-- @author simplex

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Lambda = wickerrequire "paradigms.functional"
local Debuggable = wickerrequire "adjectives.debuggable"


local EntityCreationProfiler = Class(Debuggable, function(self)
	Debuggable._ctor(self, "EntityCreationProfiler")

	self:SetConfigurationKey("PROFILING", "ENTITY_CREATION")

	self.data = {}
end)

function EntityCreationProfiler:GetDescriptionString(info)
	return ("%s (%s:%d)"):format(info.name or "?", info.source or "?", info.currentline or -1)
end

EntityCreationProfiler.Datum = Class(function(self)
	self.creations = 0
	self.destructions = 0
end)

function EntityCreationProfiler.Datum:PlusPlus()
	self.creations = self.creations + 1
end

function EntityCreationProfiler.Datum:MinusMinus()
	assert(self.destructions < self.creations)
	self.destructions = self.destructions + 1
end

function EntityCreationProfiler.Datum:Balance()
	return self.creations - self.destructions
end

function EntityCreationProfiler.Datum.Less(a, b)
	return a:Balance() < b:Balance()
end

--[[
-- Use at most one profiler.
--]]
function EntityCreationProfiler:Bind()
	self:Say("Binding")

	local oldCreateEntity = _G.CreateEntity
	
	function _G.CreateEntity(...)
		local info = debug.getinfo(2, "Sln")

		if info.source and info.source:match("fx%.lua") then
			self:Say(debug.traceback())
		end

		local s = self:GetDescriptionString(info)
		self.data[s] = self.data[s] or self.Datum()
		local datum = self.data[s]
		datum:PlusPlus()

		local inst = oldCreateEntity(...)
		inst.Remove = (function(inst)
			local oldRemove = inst.Remove
			return function(inst)
				if datum then
					datum:MinusMinus()
					datum = nil
				end
				return oldRemove(inst)
			end
		end)(inst)
		return inst
	end

	self.Bind = Lambda.Nil
end


function EntityCreationProfiler:Report()
	local fname = assert( self:GetConfig "OUTPUT_FILE" )

	self:Say("Generating report at ", fname)

	local f = io.open( MODROOT .. fname, "w" )
	assert(f, "Can't open entity creation profiling file " .. fname .. "!")

	f:write("Entity creation profiling report (", os.date("%F %X"), ")", "\r\n\r\n")

	local odata = {}
	for k, v in pairs(self.data) do
		table.insert(odata, {k, v})
	end
	table.sort(odata, function(a, b)
		return self.Datum.Less(b[2], a[2])
	end)

	for _, t in ipairs(odata) do
		local datum = t[2]
		f:write( t[1], ": ", ("%d (%d - %d)"):format(datum:Balance(), datum.creations, datum.destructions), "\r\n" )
	end

	f:close()
end



TheMod:AddSimPostInit(function(inst)
	local P = EntityCreationProfiler()

	inst:DoTaskInTime(math.max(0, P:GetConfig("START_DELAY") or 0), function()
		P:Bind()
	end)

	inst.OnSave = (function()
		local oldOnSave = inst.OnSave

		return function(...)
			P:Report()

			return (oldOnSave or Lambda.Nil)(...)
		end
	end)()
end)
