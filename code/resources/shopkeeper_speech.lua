--[[
-- This function takes an entity and returns its gender, caching the result
-- (since GetGenderStrings() is quite inefficient)
--]]
local get_inst_gender = (function()
	local cache = {}

	return function(inst)
		local p = inst.prefab
		if not p then return "MALE" end

		local ret = cache[p]
		if not ret then
			ret = _G.GetGenderStrings(p) or "MALE"
			cache[p] = ret
		end

		return ret
	end
end)()

--[[
-- This defines translations of words in the speeches below according to
-- the specified function.
--
-- The original word can be specified in any combination of lower/upper case.
--
-- When mapping a word, the final word preserves the capitalization of the
-- word as found in the text.
--]]
WORD_MAP = {
	fella = function(listener)
		return get_inst_gender(listener) == "FEMALE" and "darling" or "fella"
	end,
	gentleman = function(listener)
		return get_inst_gender(listener) == "FEMALE" and "lady" or "gentleman"
	end,
}

-- These are the shopkeeper's speeches.
--
-- Each speech is a function receiving a SpeechManager object as its first
-- parameter (see components/speechgiver.lua and search for the "@README@"
-- string in a comment).
--
-- The speaker entity (the Shopkeeper) is in the "speaker" field, and the
-- listening entity (the player) in the "listener" field.
--
-- I hope the following usage is simple and self-explanatory, even without
-- checking the speechgiver.lua file.
SPEECHES = {}


local metalsnd = "dontstarve/common/destroy_metal"


--This is the speech where he asks for beefalo in exchange for magic beans.
SPEECHES.BEAN_QUEST = function(mgr)
	mgr:MakeNonInterruptible()
	mgr:EnterCutScene()

	mgr:PlaySound(metalsnd)
	mgr "Hello there, fella."

	mgr "You look tired."

	Sleep(0.5)

	mgr "What if I told you I had something that could get you out?"
	mgr "That could whisk you away from this miserable plane?"

	Sleep(0.5)

	mgr "Interested?"
	mgr "Then let's make a deal."

	Sleep(0.5)

	mgr "I have need of a Beefalo."
	mgr "Those hairy beasts you've seen roaming the grasslands."
	mgr "Bring me one..."
	Sleep(1)
	mgr "...And I'll give you the ticket out."

	mgr:ExitCutScene()
	Sleep(0.5)

	mgr:PlaySound(metalsnd)
	mgr "Get to it, fella."
end


--This is for when a trade is successful.
--
--args is the table specified in inst.components.speechgiver:AddSpeechData()
--in the shopkeeper constructor.
SPEECHES.BEAN_SUCCESS = function(mgr, args)
	assert( args.givebeans )

	mgr:MakeNonInterruptible()
	mgr:EnterCutScene()

	Sleep(1.5)

	mgr:PlaySound(metalsnd)
	mgr "You fulfilled your end of the bargain."

	mgr:PlaySound(metalsnd)
	mgr "Now for me to keep mine."

	mgr:KillVoice()
	Sleep(0.5)

	args.givebeans(mgr.speaker, mgr.listener)

	Sleep(0.5)

	mgr:PlaySound(metalsnd)
	mgr "Your ticket out of here."

	Sleep(0.75)

	-- Goes straight into the BEANS_HINT speech, so I removed the part below.
end


--This is for when the player attacks the shopkeeper.
--(the entity gets removed, it will never run!)
SPEECHES.HIT = function(mgr)
	if mgr.listener:HasTag("player") then
		--mgr:EnterCutScene()
		mgr:MakeNonInterruptible()

		Sleep(1)
		mgr "..."
		Sleep(1)
	end
end

--This is for when the player keeps bugging the shopkeeper about the beans.
SPEECHES.BEAN_REMINDER = function(mgr)
	Sleep(0.25)

	mgr:PlaySound(metalsnd)
	mgr "Get to it, fella."
end

--This is to flag the player down.
SPEECHES.FLAG_PLAYER = function(mgr)
	Sleep(0.25)

	mgr:PlaySound(metalsnd)
	mgr "Hey you! Yes, you there!"
end

--This gives the player a hint about the beans.
SPEECHES.BEAN_HINT = function(mgr)
	if mgr:EnterCutScene() then
		mgr:MakeNonInterruptible()
		Sleep(0.75)
	end

	mgr:PlaySound(metalsnd)
	mgr "Now, you can't just plant those beans in any old soil."

	mgr:PlaySound(metalsnd)
	mgr "They require a powerful fertilizer."

	mgr:PlaySound(metalsnd)
	mgr "Bonemeal, perhaps. A grave?"

	mgr "Then..."
	Sleep(1.5)

	mgr:PlaySound(metalsnd)
	mgr "...Just let the moon do the rest."

	Sleep(0.75)
end

--This gives the player the kettle.
SPEECHES.GIVE_GIFTS = function(mgr, args)
	assert( args.givekettle )
	assert( args.givelectern )

	mgr:EnterCutScene()
	mgr:MakeNonInterruptible()

	Sleep(0.75)

	mgr "But I have some gifts."

	Sleep(0.5)


	mgr "First, a kettle."

	Sleep(0.75)
	mgr:KillVoice()
	args.givekettle(mgr.speaker, mgr.listener)
	Sleep(0.75)
	
	mgr "After all,"
	mgr "no gentleman should be without a good cup of tea."


	Sleep(0.75)

	
	mgr "Second, a blueprint for something to help you learn."
	Sleep(0.75)
	mgr:KillVoice()
	args.givelectern(mgr.speaker, mgr.listener)
	Sleep(0.75)
	mgr "Many strange and wonderful things were discovered up there."
	Sleep(0.5)
	mgr "And summarily lost."
	Sleep(0.5)
	mgr "But perhaps they were lost with good reason, hmm?"

	Sleep(1)
end

-- This is played in the first encounter after the player hit the shopkeeper.
SPEECHES.ALL_IS_FORGIVEN = function(mgr)
	if mgr:EnterCutScene() then
		mgr:MakeNonInterruptible()
		Sleep(0.75)
	end

	mgr "Well, have we calmed down finally?"

	Sleep(1.5)

	mgr "Good."

	Sleep(1)
end
