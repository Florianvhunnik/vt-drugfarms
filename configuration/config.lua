Config = {}

Config.debugMode = true
Config.resourceName = GetCurrentResourceName()

Config.drugFarms = {
    ["Weed Field"] = {
        spawnLimit = 10,
        harvestAnimation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer",
        },
        blip = {
            enabled = true,
            label = "Weed Field",
            sprite = 496,
            color = 25,
            scale = 0.8,
        },
        item = {
            spawnName = "weed",
            randomized = {
                min = 1,
                max = 3,
            },
        },
        target = {
            propType = "prop_weed_01",
            icon = "fas fa-cannabis",
            label = "Harvest weed",
            distance = 2.0,
        },
        zone = {
            vec(85.8871, -1006.3552, 29.2485),
            vec(113.5505, -1016.5567, 29.3334),
            vec(112.8641, -978.5941, 29.4073),
        }
    },
    ["Weed Field1"] = {
        spawnLimit = 10,
        harvestAnimation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer",
        },
        blip = {
            enabled = true,
            label = "Weed Field",
            sprite = 496,
            color = 25,
            scale = 0.8,
        },
        item = {
            spawnName = "weed",
            randomized = {
                min = 1,
                max = 3,
            },
        },
        target = {
            propType = "prop_weed_01",
            icon = "fas fa-cannabis",
            label = "Harvest weed",
            distance = 2.0,
        },
        zone = {
            vec(122.0877, -1016.0814, 29.3637),
            vec(129.5682, -995.9285, 29.3030),
            vec(142.9541, -999.5405, 29.2557),
        }
    },
}