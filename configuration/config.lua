Config = {}

Config.debugMode = true

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
        items = {
            spawnName = "weed",
            randomized = {
                min = 1,
                max = 3,
            },
        },
        target = {
            propType = "prop_weed_01",
            icon = "fas fa-cannabis",
            label = "Weed Plukken",
            distance = 2.0,
        },
        zone = {
            vec(85.8871, -1006.3552, 29.2485),
            vec(113.5505, -1016.5567, 29.3334),
            vec(112.8641, -978.5941, 29.4073),
        }
    },
    ["Weed Field 1"] = {
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
        items = {
            spawnName = "weed",
            randomized = {
                min = 1,
                max = 3,
            },
        },
        target = {
            propType = "prop_weed_01",
            icon = "fas fa-cannabis",
            label = "Weed Plukken",
            distance = 2.0,
        },
        zone = {
            vec(122.4700, -1016.2653, 29.3636),
            vec(128.9477, -998.6619, 29.3925),
            vec(149.6940, -1018.8648, 29.3984),
        }
    },
}