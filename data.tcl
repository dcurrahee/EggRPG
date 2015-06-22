#################################################################
# LEVELS 

set Levels {
}

#################################################################
# SKILLS 

set Skills {
}

#################################################################
# SPELLS 

set Spells {
}

#################################################################
# WEAPONS 

set Weapons {
}

#################################################################
# ARMOR 

set Armor {

}

#################################################################
# CREATURES

proc C {} { return "\003" }
proc U {} { return ^_ }
proc B {} { return "\002" }

# Format: Name,Description,Health,Mana,Speed,Strength,Will,Exp,Gold,Armor,Weapon,Skill,Spell,Loot

set NurseryCreatures [dict create]
set MeadowCreatures [dict create]
set NurseryAlleyCreatures [dict create]

dict set NurseryCreatures "a Fly" Description "A small housefly buzzes annoyingly"
dict set NurseryCreatures "a Fly" Health 6
dict set NurseryCreatures "a Fly" Mana 1
dict set NurseryCreatures "a Fly" Speed 2
dict set NurseryCreatures "a Fly" Strength 2
dict set NurseryCreatures "a Fly" Will 1
dict set NurseryCreatures "a Fly" Exp 1
dict set NurseryCreatures "a Fly" Gold 1
dict set NurseryCreatures "a Fly" Armor 0
dict set NurseryCreatures "a Fly" Weapon 0
dict set NurseryCreatures "a Fly" Skill 0
dict set NurseryCreatures "a Fly" Spell 0
dict set NurseryCreatures "a Fly" Loot {}

dict set NurseryCreatures "a Snail" Description "A simple snail gets in your way"
dict set NurseryCreatures "a Snail" Health 7
dict set NurseryCreatures "a Snail" Mana 1
dict set NurseryCreatures "a Snail" Speed 1
dict set NurseryCreatures "a Snail" Strength 2
dict set NurseryCreatures "a Snail" Will 1
dict set NurseryCreatures "a Snail" Exp 1
dict set NurseryCreatures "a Snail" Gold 1
dict set NurseryCreatures "a Snail" Armor 0
dict set NurseryCreatures "a Snail" Weapon 0
dict set NurseryCreatures "a Snail" Skill 0
dict set NurseryCreatures "a Snail" Spell 0
dict set NurseryCreatures "a Snail" Loot {Shell:1:15}

dict set MeadowCreatures "a Fly" Description "A small housefly buzzes annoyingly"
dict set MeadowCreatures "a Fly" Health 6
dict set MeadowCreatures "a Fly" Mana 1
dict set MeadowCreatures "a Fly" Speed 2
dict set MeadowCreatures "a Fly" Strength 2
dict set MeadowCreatures "a Fly" Will 1
dict set MeadowCreatures "a Fly" Exp 1
dict set MeadowCreatures "a Fly" Gold 1
dict set MeadowCreatures "a Fly" Armor 0
dict set MeadowCreatures "a Fly" Weapon 0
dict set MeadowCreatures "a Fly" Skill 0
dict set MeadowCreatures "a Fly" Spell 0
dict set MeadowCreatures "a Fly" Loot {}

dict set MeadowCreatures "a Snail" Description "A simple snail gets in your way"
dict set MeadowCreatures "a Snail" Health 7
dict set MeadowCreatures "a Snail" Mana 1
dict set MeadowCreatures "a Snail" Speed 1
dict set MeadowCreatures "a Snail" Strength 2
dict set MeadowCreatures "a Snail" Will 1
dict set MeadowCreatures "a Snail" Exp 1
dict set MeadowCreatures "a Snail" Gold 1
dict set MeadowCreatures "a Snail" Armor 0
dict set MeadowCreatures "a Snail" Weapon 0
dict set MeadowCreatures "a Snail" Skill 0
dict set MeadowCreatures "a Snail" Spell 0
dict set MeadowCreatures "a Snail" Loot {Shell:1:15}

set MeadowCreatures {
        "a Fly,A small housefly buzzes annoyingly,6,1,2,2,1,2,1,,,,,1"
        "a Snail,A simple snail gets in your way,6,1,1,2,1,1,1,,,,,1"
        "a Bee,Watch out it can sting,16,3,3,3,1,3,3,,it's stinger,,,2"
}

set NurseryAlleyCreatures {
        "a Garbage Fly,A large dirty fly,14,2,4,2,2,4,2,,,,"
        "a Rat,It can chew through cement,20,4,4,4,4,4,4,,,,"
        "a Garbage Fly,A large dirty fly,14,2,4,2,2,4,2,,,,"
        "a Tom Cat,It hisses at you slowly circling,28,6,8,5,4,6,6,,it's Claws,,"
        "a Garbage Fly,A large dirty fly,14,2,4,2,2,4,2,,,,"
        "a dirty dog,A low growl flows from his mouth as does the foam,40,6,7,8,6,10,10,,it's teeth,,"
        "a Garbage Fly,A large dirty fly,14,2,4,2,2,4,2,,,,"
        "a Rat,It can chew through cement,20,4,4,4,4,4,4,,,,"
        "a Garbage Fly,A large dirty fly,14,2,4,2,2,4,2,,,,"
        "a Tom Cat,It hisses at you slowly circling,28,6,8,5,4,6,6,,it's Claws,,"
        "a Garbage Fly,A large dirty fly,14,2,4,2,2,4,2,,,,"
}




#################################################################
# LOCATIONS

# Format: Name:Description:Distance:Creatures:HuntingChance
#"the Nursery:\00301,15Starting area for all new characters. There's not much trouble to get in here\003:0:NurseryCreatures:33"
#	"a Meadow:\00303Tall grass and rolling hills spotted with flowers makes for a picturesque view\003:2:MeadowCreatures:33"
#	"the Nursery Alley:\00300,14Behind the Nursery in the alley is not a friendly place! There are plenty of hiding places for small animals, the stench is daunting.\003:1:NurseryAlleyCreatures:50"

set WorldLocations [dict create]

proc C {} { return "\003" }
proc U {} { return  }
proc B {} { return "\002" }

dict set WorldLocations "the Nursery" Description "[C]01,15Starting area for all new characters. There's not much trouble to get in here[C]"
dict set WorldLocations "the Nursery" Distance 0
dict set WorldLocations "the Nursery" Creatures $NurseryCreatures
dict set WorldLocations "the Nursery" Hunt 100

dict set WorldLocations "A Meadow" Description "[C]03Tall grass and rolling hills spotted with flowers makes for a picturesque view[C]"
dict set WorldLocations "A Meadow" Distance 2
dict set WorldLocations "A Meadow" Creatures $MeadowCreatures
dict set WorldLocations "A Meadow" Hunt 33

dict set WorldLocations "The Nursery Alley" Description "[C]01,15Starting area for all new characters. There's not much trouble to get in here[C]"
dict set WorldLocations "The Nursery Alley" Distance 1
dict set WorldLocations "The Nursery Alley" Creatures $NurseryAlleyCreatures
dict set WorldLocations "The Nursery Alley" Hunt 45
