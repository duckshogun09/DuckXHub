return {

    SeedEventWorkbench = {
        Horsetail = { ["Stonebite Seed"] = 1, ["Bamboo"] = 1, ["Corn"] = 1, ["Sheckles"] = 50000 },
        Lingonberry = { ["Blueberry Seed"] = 3, Horsetail = 1, ["Sheckles"] = 450000 },
        ["Amber Spine"] = { ["Cactus Seed"] = 1, ["Pumpkin"] = 1, Horsetail = 1, ["Sheckles"] = 650000 },
        ["Grand Volcania"] = { ["Ember Lily"] = 2, ["Dinosaur Egg"] = 1, ["Ancient Seed Pack"] = 1, ["Sheckles"] = 950000 },
        ["Peace Lily"] = { ["Rafflesia Seed"] = 1, ["Cauliflower Seed"] = 1, SummerCoins = 3 },
        ["Aloe Vera"] = { ["Peace Lily Seed"] = 1, [" Prickly Pear"] = 1, SummerCoins = 18 },
        Guanabana = { ["Aloe Vera Seed"] = 1, ["Prickly Pear Seed"] = 1, Banana = 1, SummerCoins = 30 },
        ["Crafters Seed Pack"] = { ["Flower Seed Pack"] = 1, Honey = 10 },
        ["Manuka Flower"] = { ["Daffodil Seed"] = 1, ["Orange Tulip Seed"] = 1, Honey = 6 },
        Dandelion = { ["Manuka Flower"] = 1, ["Bamboo"] = 2, Honey = 20 },
        Lumira = { ["Pumpkin"] = 2, ["Dandelion Seed"] = 1, ["Flower Seed Pack"] = 1, Honey = 40 },
        Honeysuckle = { ["Pink Lily Seed"] = 1, ["Purple Dahlia Seed"] = 1, Honey = 80 },
        ["Bee Balm"] = { ["Crocus"] = 1, ["Lavender"] = 1, Honey = 10 },
        ["Nectar Thorn"] = { ["Cactus Seed"] = 1, ["Cactus"] = 2, ["Nectarshade Seed"] = 1, Honey = 20 },
        Suncoil = { ["Crocus"] = 1, ["Daffodil"] = 1, ["Pink Lily"] = 1, Honey = 40 }
    },

    GearEventWorkbench = {
        ["Lightning Rod"] = {
            BasicSprinkler = 1, AdvancedSprinkler = 1, GodlySprinkler = 1, Sheckles = 500000
        },
        Reclaimer = {
            CommonEgg = 1, HarvestTool = 1, Sheckles = 500000
        },
        ["Tropical Mist Sprinkler"] = {
            Coconut = 1, DragonFruit = 1, Mango = 1, GodlySprinkler = 1
        },
        ["Berry Blusher Sprinkler"] = {
            Grape = 1, Blueberry = 1, Strawberry = 1, GodlySprinkler = 1
        },
        ["Spice Spritzer Sprinkler"] = {
            Pepper = 1, EmberLily = 1, Cacao = 1, MasterSprinkler = 1
        },
        ["Flower Froster Sprinkler"] = {
            OrangeTulip = 1, Daffodil = 1, AdvancedSprinkler = 1, BasicSprinkler = 1
        },
        ["Stalk Sprout Sprinkler"] = {
            Bamboo = 1, Beanstalk = 1, Mushroom = 1, AdvancedSprinkler = 1
        },
        ["Sweet Soaker Sprinkler"] = {
            Watermelon = 3, MasterSprinkler = 1
        },
        ["Mutation Spray Choc"] = {
            CleaningSpray = 1, Cacao = 1, Sheckles = 200000
        },
        ["Mutation Spray Chilled"] = {
            CleaningSpray = 1, GodlySprinkler = 1, Sheckles = 500000
        },
        ["Mutation Spray Shocked"] = {
            CleaningSpray = 1, ["Lightning Rod"] = 1, Sheckles = 1000000
        },
        ["Anti Bee Egg"] = {
            BeeEgg = 1, Honey = 25
        },
        ["Small Toy"] = {
            CommonEgg = 1, CoconutSeed = 1, Coconut = 1, Sheckles = 1000000
        },
        ["Small Treat"] = {
            CommonEgg = 1, DragonFruitSeed = 1, Blueberry = 1, Sheckles = 1000000
        },
        ["Pack Bee"] = {
            ["Anti Bee Egg"] = 1, Sunflower = 1, PurpleDahlia = 1, Honey = 250
        },
        ["Mutation Spray Pollinated"] = {
            CleaningSpray = 1, BeeBalm = 1, Honey = 25
        },
        ["Honey Crafters Crate"] = {
            BeeCrate = 1, Honey = 12
        }
    }

    VirtualCurrencies = { "Sheckles", "Honey", "SummerCoins" },

    MutationList = {
        "Wet", "Shocked", "Chilled", "Frozen", "Moonlit", "Bloodlit", "Celestial", "Zombified",
        "Disco", "Pollinated", "HoneyGlazed", "Voidtouched", "Twisted", "Plasma", "Heavenly", "Choc",
        "Meteoric", "Burnt", "Cooked", "Molten", "Dawnbound", "Alienlike", "Galactic", "Verdant",
        "Paradisal", "Sundried", "Windstruck", "Drenched", "Wilt", "Wiltproof", "Aurora", "Fried",
        "Cloudtouched", "Sandy", "Clay", "Ceramic", "Amber", "OldAmber", "AncientAmber", "Tempestuous",
        "Friendbound", "Infected", "Tranquil", "Chakra", "Foxfire Chakra", "Radioactive", "Corrupt",
        "Corrupt Chakra", "Corrupt Foxfire Chakra", "Harmonised Chakra", "Subzero", "Jackpot",
        "Touchdown", "Blitzshock", "Sliced", "Pasta", "Sauce", "Meatball"
    },

    CookingRecipes = {
        Salad = {
            Uncommon = {
                { Tomato = 2 }
            },
            Rare = {
                { Tomato = 5 }
            },
            Legendary = {
                { ["Blood Banana"] = 2, Tomato = 2 },
                { Bamboo = 1, Mango = 1, Pineapple = 1, Tomato = 1, Beanstalk = 1 }
            },
            Mythical = {
                { Tomato = 1, ["Giant Pinecone"] = 1 },
                { ["Sugar Apple"] = 2, Pepper = 1, Tomato = 1 }
            },
            Divine = {
                { Beanstalk = 4, Tomato = 1 },
                { ["Bone Blossom"] = 2, Pineapple = 1, Pepper = 1, Tomato = 1 }
            },
            Prismatic = {
                { Tomato = 1, ["Bone Blossom"] = 4 }
            }
        },
    
        Sandwich = {
            Normal = {
                { Tomato = 2, Corn = 1 }
            },
            Legendary = {
                { Cacao = 1, Tomato = 1, Corn = 1 },
                { Tomato = 1, Corn = 1, ["Elder Strawberry"] = 1 }
            },
            Mythical = {
                { ["Giant Pinecone"] = 2, Tomato = 1, Corn = 1 }
            },
            Divine = {
                { ["Bone Blossom"] = 3, Tomato = 1, Corn = 1 }
            },
            Prismatic = {
                { Tomato = 1, Banana = 1, ["Bone Blossom"] = 3 }
            }
        },
    
        Pie = {
            Normal = {
                { Corn = 1, Pumpkin = 1 }
            },
            Legendary = {
                { Corn = 1, Coconut = 1 }
            },
            Mythical = {
                { Apple = 1, Pumpkin = 1 }
            },
            Divine = {
                { Coconut = 1, Beanstalk = 1 },
                { Coconut = 1, Pepper = 1, ["Elder Strawberry"] = 2, Celestiberry = 1 },
                { ["Sugar Apple"] = 3, Pumpkin = 1 }
            },
            Prismatic = {
                { Pumpkin = 1, ["Bone Blossom"] = 4 },
                { Coconut = 1, ["Bone Blossom"] = 2 }
            }
        },
    
        Waffle = {
            Normal = {
                { Strawberry = 1, Coconut = 1 }
            },
            Legendary = {
                { ["Sugar Apple"] = 1, Watermelon = 1, Corn = 1, Sugarglaze = 1 }
            },
            Mythical = {
                { ["Tranquil Bloom"] = 1, Starfruit = 1, Coconut = 1 },
                { Grape = 1, Coconut = 1, ["Dragon Fruit"] = 1, Cactus = 1, Peach = 1 }
            },
            Divine = {
                { ["Sugar Apple"] = 1, Coconut = 1 }
            },
            Prismatic = {
                { ["Bone Blossom"] = 3, ["Sugar Apple"] = 1, Coconut = 1 }
            }
        },
    
        HotDog = {
            Normal = {
                { Banana = 1, Pepper = 1 }
            },
            Legendary = {
                { Pepper = 1, Corn = 1 }
            },
            Mythical = {
                { ["Ember Lily"] = 1, Corn = 1 }
            },
            Divine = {
                { Corn = 1, ["Ember Lily"] = 4 },
                { ["Bone Blossom"] = 2, Beanstalk = 2, Corn = 1 }
            },
            Prismatic = {
                { Corn = 1, ["Bone Blossom"] = 4 },
                { ["Violet Corn"] = 1, ["Bone Blossom"] = 4 }
            }
        },
    
        IceCream = {
            Uncommon = {
                { Blueberry = 1, Corn = 1 },
                { Strawberry = 1, Corn = 1 }
            },
            Legendary = {
                { Banana = 2 },
                { Pineapple = 1, Corn = 1 }
            },
            Mythical = {
                { Banana = 1, ["Sugar Apple"] = 1 }
            },
            Divine = {
                { ["Sugar Apple"] = 3, Corn = 1 },
                { Tomato = 1, ["Bone Blossom"] = 1, ["Sugar Apple"] = 1 }
            },
            Prismatic = {
                { Sugarglaze = 1, ["Sugar Apple"] = 1, ["Bone Blossom"] = 3 }
            }
        },
    
        Donut = {
            Uncommon = {
                { Corn = 2, ["Spiked Mango"] = 1 },
                { Corn = 1, Blueberry = 1, Strawberry = 1 }
            },
            Legendary = {
                { ["Blood Banana"] = 1, ["Moon Melon"] = 1 }
            },
            Mythical = {
                { ["Sugar Apple"] = 1, Corn = 2 }
            },
            Divine = {
                { ["Bone Blossom"] = 1, ["Sugar Apple"] = 1, Banana = 1 }
            },
            Prismatic = {
                { Sugarglaze = 1, ["Bone Blossom"] = 4 }
            }
        },
    
        Pizza = {
            Rare = {
                { Banana = 1, Tomato = 1 }
            },
            Legendary = {
                { Corn = 2, Apple = 2, Pepper = 1 },
                { Cactus = 1, Corn = 1, Coconut = 1 }
            },
            Mythical = {
                { Tomato = 1, Corn = 1, Pepper = 1, ["Sugar Apple"] = 2 },
                { ["Giant Pinecone"] = 1, Corn = 1, Apple = 1, Mushroom = 1, Pepper = 1 }
            },
            Divine = {
                { ["Sugar Apple"] = 1, ["Bone Blossom"] = 1, Corn = 1 }
            },
            Prismatic = {
                { Beanstalk = 1, Banana = 1, ["Bone Blossom"] = 3 }
            }
        },
    
        Sushi = {
            Normal = {
                { Bamboo = 4, Corn = 1 }
            },
            Legendary = {
                { Pepper = 1, Coconut = 1, Bamboo = 1, Corn = 1 }
            },
            Mythical = {
                { ["Sugar Apple"] = 3, Bamboo = 1, Corn = 1 },
                { Bamboo = 2, ["Bone Blossom"] = 2, Corn = 1 }
            },
            Divine = {
                { ["Bone Blossom"] = 3, Bamboo = 1, Corn = 1 }
            },
            Prismatic = {
                { ["Bone Blossom"] = 3, ["Violet Corn"] = 1, ["Lucky Bamboo"] = 1 }
            }
        },
    
        Burger = {
            Legendary = {
                { Pepper = 1, Corn = 1, Tomato = 1 }
            },
            Mythical = {
                { Pepper = 1, Corn = 1, Tomato = 1, ["Bone Blossom"] = 1, Beanstalk = 1 }
            },
            Divine = {
                { ["Bone Blossom"] = 3, Corn = 1, Tomato = 1 }
            },
            Prismatic = {
                { ["Violet Corn"] = 1, Tomato = 1, ["Bone Blossom"] = 3 }
            }
        },
    
        Cake = {
            Uncommon = {
                { Corn = 2, Strawberry = 2 },
                { Blueberry = 2, Corn = 1, Tomato = 1 },
                { Corn = 2, Watermelon = 2 },
                { Pumpkin = 1, ["Giant Pinecone"] = 1, Corn = 1, Apple = 1 }
            },
            Rare = {
                { Blueberry = 1, Grape = 1, Apple = 1, Corn = 1 },
                { Banana = 2, Strawberry = 2, Pumpkin = 1 },
                { ["Ember Lily"] = 1, Peach = 2 }
            },
            Legendary = {
                { Kiwi = 2, Banana = 2 }
            },
            Mythical = {
                { ["Sugar Apple"] = 2, Corn = 2 }
            },
            Divine = {
                { Banana = 1, Kiwi = 1, ["Bone Blossom"] = 3 },
                { ["Sugar Apple"] = 4, Corn = 1 },
                { ["Elder Strawberry"] = 4, Corn = 1 }
            },
            Prismatic = {
                { ["Bone Blossom"] = 3, ["Sugar Apple"] = 1, Banana = 1 }
            }
        }
    }
}
