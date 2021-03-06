local function randomness()
	return 0.1 + 0.5*math.random()
end

BindGlobal()

--Generic Biome Rooms

--Generic BG
TheMod:AddRoom("BGCloud", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			skyflower = 1.3,
			tea_bush = 0.05,
			crystal_light = 0.065,
			cloud_fruit_tree = 0.0065,
			owl = 0.007,
		},
	    countprefabs = {
	        lionblob = function() if math.random(1,4) == 4 then return 1 end return 0 end,
	        golden_sunflower = 6,
	        thunder_tree = math.random(2,3),
	        sheepherd = math.random(1,4),
	    }		
	}
})

--Generic Spawnzone
TheMod:AddRoom("BeanstalkSpawn", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents =  {
		distributepercent = 0.4,
		distributeprefabs = {
			skeleton = 0.01,
			tea_bush = 0.06,
			skyflower = 1.1,
			beanlet = 0.004,
		},
	}
})

--Skyflowers
TheMod:AddRoom("SkyflowerGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.CLOUDSWIRL,
	contents = {
		custom_tiles={
			GeneratorFunction = RUNCA.GeneratorFunction,
			data = {iterations=6, seed_mode=CA_SEED_MODE.SEED_WALLS, num_random_points=1,
						translate={	{tile=GROUND.CLOUDSWIRL, items={"sheep"}, item_count=3},
									{tile=GROUND.CLOUDSWIRL, items={"cloud_bush"}, item_count=5},
									{tile=GROUND.CLOUDSWIRL, items={"skytrap"}, item_count=6},
								   },
			},
		},	
		distributepercent = randomness(),
		distributeprefabs = {
			skyflower = 0.1,
			skytrap = 0.08,
			golden_rose = 0.1,
			cloud_bush = 0.02,
		},
	    countprefabs= {
	        weavernest = 4,
	        sheepherd = 4,
	    }			
	},
})

--Sheep
TheMod:AddRoom("SheepHerd", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.CLOUDLAND,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			sheep = 0.1,
			sheepherd = 0.07,
			skyflower = 0.6,
		},
	},
})

--Cloudbushes
TheMod:AddRoom("BushGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			cloud_bush = 0.04,
			tea_bush = 0.02,
			skyflower = 0.5,
			frog = 0.01,
		},
	    countprefabs= {
	        weavernest = 4,
	    }		
	},
})


---------

--Aurora Biome Rooms

--Aurora BG
TheMod:AddRoom("BGAurora", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.AURORA,
	contents =  {
		custom_tiles={
			GeneratorFunction = RUNCA.GeneratorFunction,
			data = {iterations=1, seed_mode=CA_SEED_MODE.SEED_CENTROID, num_random_points=1,
						translate={	{tile=GROUND.AURORA, items={"alien"}, item_count=3},
									{tile=GROUND.AURORA, items={"skeleton"}, item_count=5},
									{tile=GROUND.AURORA, items={"cloudcrag"}, item_count=17},
									{tile=GROUND.AURORA, items={"dragonblood_tree"}, item_count=6},
									{tile=GROUND.AURORA, items={"skyflower"}, item_count=30},
							},
					centroid= 	{tile=GROUND.SNOW, items={"scarecrow"}, item_count=1},
			},
		},
		distributepercent = randomness(),
		distributeprefabs = {
			alien = 0.02,		
			skeleton = 0.001,
			gustflower = 0.03,
			dragonblood_tree = 0.09,
			skyflower = 1.0,
			cloudcrag = 0.04,
		},
		countprefabs = {
			--mantaspawner = math.random(1,4),
		}
	}
})

--Vines
TheMod:AddRoom("Vine_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.AURORA,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			vine = 0.2,
			dragonblood_tree = 0.4,
			beanlet = 0.07,
			gustflower = 0.2,
			skeleton = 0.1,
		},
	},
})

--Cloudcrags
TheMod:AddRoom("CragLanding", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.AURORA,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			--sky_lemur = 0.005,
			beanlet = 0.00002,
			cloud_fruit_tree = 0.00002,
			goose = 0.000007,
		},
	    countprefabs = {
	        goose = 1,
	        beanlet_hut = 4,
	    }	
	},
})

--Longbills
TheMod:AddRoom("Bigbird_Nest", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.AURORA,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			goose = 0.00006,
			longbill = 0.00002,
			dragonblood_tree = 0.0001,
			skyflower = 0.1,
		},
	    countprefabs = {
	        goose = 6,
	    }		
	},
})

--Beanlets
TheMod:AddRoom("Beanlet_Den", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.AURORA,
	contents = {
		distributepercent = 0.6*randomness(),
		distributeprefabs = {
			beanlet_hut = 0.0005,
			skyflower = 0.1,
			dragonblood_tree = 0.01,
		},
	    countprefabs = {
	        goose = 1,
	    }
	},
})


----------
	
--Snow Biome Rooms

--Snow BG
TheMod:AddRoom("BGSnow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			thunder_tree = 0.008,
			ball_lightning = 0.001,
			frog = 0.002,
			skyflower = 0.1,
			--owl = 0.001,
			skyflower = 0.1,
		},
	}
})

--Thunder Trees
TheMod:AddRoom("Thunder_Forest", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			thunder_tree = 0.0011,
			crystal_quartz = 0.0010,
			--owl = 0.004,
			live_gnome = 0.0010,
			skyflower = 0.1,
		},
	    countprefabs= {
	        weavernest = 4,
	        crystal_black = 4,
	    }
	}
})

TheMod:AddRoom("Sea_Mimic", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			cloud_algae = 0.15,
			cloud_coral = 0.15,
			thunder_tree = 0.09,
			skyflower = 0.2,
		},
		countprefabs = {
			--mantaspawner = math.random(1,4),
		}
	},
})

TheMod:AddRoom("Manta_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			cloud_bush = 0.03,
			cloud_fruit_tree = 0.025,
			--colored_corn = 0.04,
			jellyshroom_blue = 0.08,
			owl = 0.007,
			skyflower = 0.1,
		},
		countprefabs = {
			--mantaspawner = math.random(1,4),
		}
	},
})

----------


--Rainbow Biome Rooms

--Rainbow BG
TheMod:AddRoom("BGRainbow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			jellyshroom_red = 0.02,
			jellyshroom_blue = 0.03,
			jellyshroom_green = 0.04,
			skyflower = 0.1,
		},
	    countprefabs= {
	        gummybear_den = math.random(2,4),
	    }
	},
})

--Marshmallows
TheMod:AddRoom("Rainbow_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			hive_marshmallow = 0.03,
			jellyshroom_red = 0.02,
			bee_marshmallow = 0.1,
			skyflower = 0.1,		
		},
	    countprefabs= {
	        crystal_white = 4,
	    }
	},
})

--Crystals
TheMod:AddRoom("Crystal_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		custom_tiles={
			GeneratorFunction = RUNCA.GeneratorFunction,
			data = {iterations=12, seed_mode=CA_SEED_MODE.SEED_RANDOM, num_random_points=2,
						translate={	{tile=GROUND.RAINBOW, items={"crystal_spire"}, item_count=4},
									{tile=GROUND.RAINBOW, items={"crystal_water"},	item_count=4},
									{tile=GROUND.RAINBOW, items={"crystal_light"}, item_count=4},
									{tile=GROUND.RAINBOW, items={"crystal_black"},	item_count=1},
									{tile=GROUND.RAINBOW, items={"crystal_white"}, item_count=1},
								},
			},
		},
		distributepercent = randomness(),
		distributeprefabs = {
			crystal_spire = 0.025,
			crystal_water = 0.025,
			crystal_light = 0.025,
			--rainbowcoon = 0.05,
			jellyshroom_green = 0.05,
			skyflower = 0.1,
			owl = 0.007,
		},
		countprefabs= {
	        crystal_black = 4,
	    }
	},
})

--Flying Fish
TheMod:AddRoom("Fish_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		distributepercent = randomness(),
		distributeprefabs = {
			cloudcrag = 0.03,
			crystal_water = 0.025,
			golden_sunflower = 0.02,
			jellyshroom_blue = 0.05,
			skyflower = 0.1,
			weavernest = 0.01,
		},
	},
})
