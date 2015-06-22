putlog "EggRPG Loading"

#Globals
# How many character slots can be made
set MaxCharacterSlots 3
# The channel to run in
set RPGChan #EggRPG 

# How many seconds between RPG updates
set RPGInterval 5
# How many seconds in between auto healing
set RPGHealPulse 60
# How many seconds in between travel pulse
set RPGTravelPulse 60
# What percentage of life to heal each pulse
set RPGHealPulsePower 2

#################################################################
#XTRAs
# Logged - whether user is logged in as a character or not
# CharacterSlot# - Character slots

# Health#
# MaxHealth#
# MaxMana#
# Mana#
# Speed# 
# Strength# 
# Willpower#

# Armor# - what they're wearing
# Weapon# - Current weapon being held
# ActiveSkill# - Current skill
# ActiveSpell# - Current spell

# Location# - Current area
# Travelling# - Travelling to
# TravelDist - Where


#################################################################
#BINDS
bind msg - create RPG_Create
bind msg - login RPG_Login
bind msg - logout RPG_Logoff
bind msg - delete RPG_Delete
bind msg - listcharacters RPG_ListCharacters
bind msg - whoami RPG_WhoAmI
bind msg - stats RPG_Stats
bind msg - travel RPG_Travel

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
# LOCATIONS

source scripts/EggRPG/data.tcl

# Format: Name,Description,Health,Mana,Speed,Strength,Will,Exp,Gold,Armor,Weapon,Skill,Spell,Loot

#set NurseryCreatures {
#	"a Fly,A small housefly buzzes annoyingly,6,1,2,2,1,2,1,,,,,1"
#	"a Snail,A simple snail gets in your way,6,1,1,2,1,1,1,,,,,1"
#}

#set MeadowCreatures {
#	"a Fly,A small housefly buzzes annoyingly,6,1,2,2,1,2,1,,,,,1"
#	"a Snail,A simple snail gets in your way,6,1,1,2,1,1,1,,,,,1"
#	"a Bee,Watch out it can sting,16,3,3,3,1,3,3,,it's stinger,,,2"
#}
#
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
# LOOT

set LootLists {
	"123"
}



#################################################################
#Do not edit below unless you know
#################################################################
# INIT
set RPGtime 0
set RPGheal 0
set RPGtrav 0
foreach timer [utimers] {
	set time [lindex $timer 0]
	set string [lindex $timer 1]
	set control [lindex $timer 2]
	if {[string match "*RPG_Timer*" $string]} {
		set RPGtime 1
	}
	if {[string match "*RPG_HealPulse*" $string]} {
		set RPGheal 1
	}
	if {[string match "*RPG_TravelPulse*" $string]} {
		set RPGtrav 1
	}
}

if {$RPGtime == 0} {
	utimer $RPGInterval "RPG_Timer"	
}

if {$RPGheal == 0} {
	utimer $RPGHealPulse "RPG_HealPulse"	
}

if {$RPGtrav == 0} {
	utimer $RPGTravelPulse "RPG_TravelPulse"	
}

##################################################################################################################################
# Main

proc RPG_Timer {} {
	global RPGChan WorldLocations botnick RPGInterval
	foreach nick [chanlist $RPGChan] {
		if {$nick == $botnick} {
			continue
		}
		set hand [nick2hand $nick $RPGChan]
		set Logged [check_logged_in $hand]
		if {$Logged > 0} {
			set char [getstat $hand "CharacterSlot"]
			set loc [getstat $hand "Location"]
			if {[getuser $hand XTRA [statslot "Travelling" $Logged]] == ""} {
				set Creatures [dict get $WorldLocations $loc Creatures]
				set HuntingChance [dict get $WorldLocations $loc Hunt]
				global [set Creatures]
				if {[rand 100] < $HuntingChance} { #roughly 1/3 chance to encounter an enemy
					set numb [dict size $Creatures]
					set random [rand $numb]
					set Creature [lindex [dict keys $Creatures] [rand $numb]]
					putlog "here now $Creature"
					set Ename $Creature
					set Edesc [dict get $Creatures $Creature Description]
			                set Ehealth [dict get $Creatures $Creature Health] 
			                set Emana [dict get $Creatures $Creature Mana]
                  			set Espeed [dict get $Creatures $Creature Speed]
					set Estrength [dict get $Creatures $Creature Strength]
					set Ewill [dict get $Creatures $Creature Will]
					set Eexp [dict get $Creatures $Creature Exp]
					set Egold [expr [dict get $Creatures $Creature Gold] + 1]
					set Earmor [dict get $Creatures $Creature Armor]
					set Eweapon [dict get $Creatures $Creature Weapon]
					set Eskill [dict get $Creatures $Creature Skill]
					set Espell [dict get $Creatures $Creature Spell]
					set Eloot [dict get $Creatures $Creature Loot]
					putnick $nick "$char is in $loc and has encountered $Ename ($Edesc)"
					# check whos speed is higher
					set fight ""
					if {[rand [getstat $hand "Speed"]] > [rand $Espeed]} { #player rolled a higher speed
						set attacker $hand
						set astrength [getstat $hand "Strength"]
						set defender $Ename
						set dstrength $Estrength
						append fight "$char attacks $Ename first!"
					} else { #Enemy rolled a higher or equal speed
						set attacker $Ename
						set astrength $Estrength
						set defender $hand
						set dstrength [getstat $hand "Strength"]
						append fight "[U]$Ename attacks $char first![U]"
					}
					#back and forth hits for winner
					while {[getstat $hand "Health"] > 0 && $Ehealth > 0} {
						set hit [rand $astrength]
						if {$attacker == $hand} {
							set Ehealth [expr $Ehealth - $hit]
							append fight " $char hits $Ename [B][C]04$hit[C][B]!"
						} else {
							setstat $hand Health [expr [getstat $hand Health] - $hit]
							append fight " [U]$Ename hits $char for [B][C]04$hit[C][B]![U]"
						}
                                                set hit [rand $dstrength]
                                                if {$defender == $hand} {
                                                        set Ehealth [expr $Ehealth - $hit]
							append fight " $char hits $Ename for [B][C]04$hit[C][B]!"
                                                } else {
                                                        setstat $hand Health [expr [getstat $hand Health] - $hit]
							append fight " [U]$Ename hits $char for [B][C]04$hit[C][B]![U]"
                                                }
					}
					if {$Ehealth <= 0} {
						append fight " $Ename is dead! You"
						set goldwon [rand $Egold]
						if {$goldwon > 0} {
							append fight " acquire [C]08,14 $goldwon gold bounty [C] and"
							setstat $hand "Gold" [expr [getstat $hand "Gold"] + $goldwon]
						}
						append fight " gain [C]06,11 $Eexp experience [C]" 
						foreach loot $Eloot {
							set loot [split $loot ":"]
							set lootname [lindex $loot 0]
							set lootval [lindex $loot 1]
							set lootchance [lindex $loot 2]
							if {[rand 100] <= $lootchance} {
								set lootval [rand $lootval]
								if {$lootval == 0} {
									set lootval 1
								}
								append fight " You have found $lootval $lootname!"
							}
						}
						setstat $hand "Gold" [expr [getstat $hand "Gold"] + $Egold]
						setstat $hand "Exp" [expr [getstat $hand "Exp"] + $Eexp]
						set h [getstat $hand "Health"]
						set m [getstat $hand "Mana"]
						set mh [getstat $hand "MaxHealth"]
						set mm [getstat $hand "MaxMana"]
						append fight " -- [C]04$h/$mh Health[C] [C]02$m/$mm Mana[C]"
					} elseif {[getstat $hand "Health"] <= 0} {
						append fight "[C]04,01$hit You have been incapacitated.[C]"
						utimer 15 [logout $hand]
					} else {
						putlog "no one died?"
					}
					putnick $nick $fight
				} else { # did not find anything
					putnick $nick "You find nothing at [getstat $hand Location], your chance was $HuntingChance%"
				}
			}
		}
	}
	foreach timer [utimers] {
		set time [lindex $timer 0]
		set string [lindex $timer 1]
		set control [lindex $timer 2]
		if {[string match "*RPG_Timer*" $string]} {
			killtimer $control
		}
	}
	utimer $RPGInterval "RPG_Timer"
}

proc RPG_HealPulse {} {
	global RPGHealPulse RPGHealPulsePower MaxCharacterSlots
	foreach user [userlist] {
		for {set i 1} {$i <= $MaxCharacterSlots} {incr i} {
			set MaxHealth [getuser $user XTRA [statslot "MaxHealth" $i]]
			set Health [getuser $user XTRA [statslot "Health" $i]]
			if {$Health < $MaxHealth} {
				set power [expr $RPGHealPulsePower * 0.01]
				set more [string trimright [expr ceil($MaxHealth * $power)] ".0"]
				incr Health $more
				setuser $user XTRA [statslot "Health" $i] $Health
			}
		}
	}
	foreach timer [utimers] {
		set time [lindex $timer 0]
		set string [lindex $timer 1]
		set control [lindex $timer 2]
		if {[string match "*RPG_HealPulse*" $string]} {
			killtimer $control
		}
	}
	utimer $RPGHealPulse "RPG_HealPulse"
}

proc RPG_TravelPulse {} {
	global RPGChan WorldLocations botnick RPGTravelPulse MaxCharacterSlots
	foreach nick [chanlist $RPGChan] {
		if {$nick == $botnick} {
			continue
		}
		set hand [nick2hand $nick]
		for {set i 1} {$i <= $MaxCharacterSlots} {incr i} {
			set Travelling [getuser $hand XTRA [statslot "Travelling" $i]]
			if {$Travelling != ""} {
				set TravelDist [getstat $hand [statslot "TravelDist" $i]]
				set Dist [dict get $WorldLocations $Travelling Distance]
				if {$TravelDist < $Dist} {
					setstat $hand [statslot "TravelDist" $i] [expr $TravelDist + 1]
				} elseif {$TravelDist > $Dist} {
					setstat $hand [statslot "TravelDist" $i] [expr $TravelDist - 1]
				} else {
					set char [getuser $hand XTRA [statslot "CharacterSlot" $i]]
					setuser $hand XTRA [statslot "Location" $i] $Travelling
					setuser $hand XTRA [statslot "Travelling" $i] ""
					set desc [loc_desc $hand]
					putnick $nick "$char has travelled to $Travelling"
					if {$i == [check_logged_in $hand]} {
						putnick $nick $desc
					}
				}
			}
		}
	}
	foreach timer [utimers] {
		set time [lindex $timer 0]
		set string [lindex $timer 1]
		set control [lindex $timer 2]
		if {[string match "*RPG_TravelPulse*" $string]} {
			killtimer $control
		}
	}
	utimer $RPGTravelPulse "RPG_TravelPulse"
}

##################################################################################################################################

proc RPG_Travel { nick host hand arg } {
	global WorldLocations
	set real 0
	foreach location [dict keys $WorldLocations] {
		if {[string tolower $location] == [string tolower $arg]} {
			if {$location == [getuser $hand XTRA [statslot "Location" [getuser $hand XTRA Logged]]]} {
				putnick $nick "You're already located at $location"
				return 0
			}
			set real $location
			setstat $hand "Location" ""
			setstat $hand "Travelling" $location
			break
		}
	}
	if {$real != 0} {
		putnick $nick "Beginning the journey to $real"
	} else {
		putnick $nick "How can you travel to $arg if you don't even know where it's at?"
	}
}

proc RPG_Stats { nick host hand arg } {
	set Logged [check_logged_in $hand]
	if {$Logged > 0} {
		set char [getuser $hand XTRA [characterslot $hand $Logged]]
		set out "Stats for $char"
		set stats {
			"MaxHealth"
			"Health"
			"MaxMana"
			"Mana"
			"Speed"
			"Strength"
			"Will"
			"Exp"
			"Gold"
			"Armor"
			"Weapon"
			"ActiveSkill"
			"ActiveSpell"
			"Location"
			"Travelling"
		}
	
		foreach stat $stats {
			set slot [statslot $stat $Logged]
			set st [getuser $hand XTRA $slot]
			append out " $stat: $st"
		}
		putnick $nick $out
	} else {
		putnick $nick "You have no stats because you're not logged in"
	}
}

proc RPG_WhoAmI { nick host hand arg } {
	set Logged [check_logged_in $hand]
	if {$Logged > 0} {
		set char [getuser $hand XTRA [characterslot $hand $Logged]]
		putnick $nick "You are $char"
	} else {
		putnick $nick "You are no one."
	}
}

proc RPG_Create { nick host hand arg } { 
	if {[llength $arg] < 1 || [llength $arg] > 1} {
		putnick $nick "[B]Usage:[B] create <Character Name> "
	} else {
		set available [find_char_slot $hand ""]
		if {$available == 0} {
			putnick $nick "You have no free slots. If you want to create a new character you'll have to free up a slot"
			return 0
		} else {
			set slot [characterslot $hand $available] 
			setuser $hand XTRA $slot $arg
			logout $hand
			setuser $hand XTRA Logged $available
			create_new_char $hand
			putnick $nick "$arg has been logged [B]IN[B]"	
		}
	}
} 

proc RPG_Delete { nick host hand arg } {
	global MaxCharacterSlots
	if {[llength $arg] != 1} {
		putnick $nick "$arg is not a character you own."
		return 0
	} else {
		for {set i 1} {$i <= $MaxCharacterSlots} {incr i} {
			set slot [characterslot $hand $i]
			set slotchar [getuser $hand XTRA $slot]
			if {[string tolower $slotchar] == [string tolower $arg]} {
				if {[getuser $hand XTRA Logged] == $i} {
					logout $hand
				}
				setuser $hand XTRA $slot ""	
				putnick $nick "$arg has been [B]DELETED[B]"
				return 0
			}
		}
	}
}

proc RPG_Login { nick host hand arg} {
	global MaxCharacterSlots
	if {[llength $arg] == 1} {
		set slot [find_char_slot $hand $arg]
		if {$slot == 0} {
			putnick $nick "No such character by the name of $arg is found."
			return 0
		}
		set logged [check_logged_in $hand]
		if {$logged == $slot} {
			putnick $nick "$arg is already logged in"
			return 0
		}
		logout $hand
		setuser $hand XTRA Logged $slot
		putnick $nick "$arg has been logged [B]IN[B]"
		set desc [loc_desc $hand]
		putnick $nick $desc
	} else {
		putnick $nick "[B]Usage:[B] login <Character Name>"
		return 0
	}
}

proc RPG_Logoff { nick host hand arg} {
	set Logged [logout $hand]
	if { $Logged == 0 } {
		putnick $nick "You are currently not logged into any characters"
	}
}

proc RPG_ListCharacters { nick host hand arg } {
	global MaxCharacterSlots
	set characters 0
	putnick $nick "[B]Characters:[B]"
	for {set i 1} {$i <= $MaxCharacterSlots} { incr i } {
		set slot [characterslot $hand $i]
		set char [getuser $hand XTRA $slot]
		if {$char != ""} {
			putnick $nick "Slot $i: $char"
			incr characters 
		}
	}
	if {$characters == 0} {
		putnick $nick "None."
	}
}

proc loc_desc { hand } {
	global WorldLocations
	set travel [getuser $hand XTRA [statslot "Travelling" [getuser $hand XTRA Logged]]]
	if {$travel != ""} {
		return "Travelling to $travel" 
	}
	set loc [getuser $hand XTRA [statslot "Location" [getuser $hand XTRA Logged]]]
	set desc [dict get $WorldLocations $loc Description]
	return $desc
}

proc putnick { nick text } {
	msg "privmsg" $nick $text
}

proc logon { hand } {
	
}

proc logout { hand } {
	set Logged [check_logged_in $hand]
	if {$Logged > 0} {
		set slot [characterslot $hand $Logged]
		set char [getuser $hand XTRA $slot]
		setuser $hand XTRA Logged 0
		set nick [hand2nick $hand]
		putnick $nick "$char has been logged [B]OUT[B]"
		return $Logged
	}
	return 0
}

proc characterslot { hand numb } {
	set slot "CharacterSlot"
	append slot $numb
	return $slot
}

proc statslot { stat numb } {
	append stat $numb
	return $stat
}

proc getstat { hand stat } {
        return [getuser $hand XTRA [statslot $stat [getuser $hand XTRA Logged]]]
}

proc setstat { hand stat val } {
	setuser $hand XTRA [statslot $stat [getuser $hand XTRA Logged]] $val 
}


proc check_logged_in { hand } {
	set Logged [getuser $hand XTRA Logged]
        if {$Logged > 0} {
		return $Logged 
        } elseif {$Logged == ""} {
			setuser $hand XTRA Logged 0
        }
	return 0
}

proc find_char_slot { hand arg } {
	global MaxCharacterSlots
	for { set i 1 } { $i <= $MaxCharacterSlots } { incr i } {
		set slot [characterslot $hand $i]
		set slotcheck [getuser $hand XTRA $slot]
		if {[string tolower $slotcheck] == [string tolower $arg]} {
			return $i
		}
	}
	return 0
}

proc create_new_char { hand } {
	set Logged [check_logged_in $hand]
	set slot [statslot "Health" $Logged]
        setuser $hand XTRA $slot [expr [rand 8] + 10]
        set slot [statslot "Mana" $Logged]
        setuser $hand XTRA $slot [expr [rand 6] + 4]
        set slot [statslot "MaxHealth" $Logged]
        setuser $hand XTRA $slot [getuser $hand XTRA [statslot "Health" $Logged]] 
        set slot [statslot "MaxMana" $Logged]
        setuser $hand XTRA $slot [getuser $hand XTRA [statslot "Mana" $Logged]] 

        set slot [statslot "Speed" $Logged]
        setuser $hand XTRA $slot [expr [rand 4] + 2]
        set slot [statslot "Strength" $Logged]
        setuser $hand XTRA $slot [expr [rand 5] + 2]
        set slot [statslot "Will" $Logged]
        setuser $hand XTRA $slot [expr [rand 4] + 2]
        set slot [statslot "Exp" $Logged]
        setuser $hand XTRA $slot 0 
        set slot [statslot "Gold" $Logged]
        setuser $hand XTRA $slot 0 

	set slot [statslot "Armor" $Logged]
        setuser $hand XTRA $slot "rags" 
	set slot [statslot "Weapon" $Logged]
        setuser $hand XTRA $slot "bare hands" 
	set slot [statslot "ActiveSkill" $Logged]
        setuser $hand XTRA $slot "" 
	set slot [statslot "ActiveSpell" $Logged]
        setuser $hand XTRA $slot "" 
	set slot [statslot "Location" $Logged]
        setuser $hand XTRA $slot "the Nursery" 
	set slot [statslot "Travelling" $Logged]
        setuser $hand XTRA $slot ""
	set slot [statslot "TravelDist" $Logged]
        setuser $hand XTRA $slot "0" 

}


proc C {} { return "\003" }
proc U {} { return  }
proc B {} { return "\002" }

############################################################
#Not mine

proc msg {type dest data} { 
   set len [expr {512-[string len ":$::botname $type $dest :\r\n"]}] 
   foreach line [wordwrap $data $len] { 
      puthelp "$type $dest :$line" 
   } 
} 

proc wordwrap {data len} { 
   set out {} 
   foreach line [split [string trim $data] \n] { 
      set curr {} 
      set i 0 
      foreach word [split [string trim $line]] { 
         if {[incr i [string len $word]]>$len} { 
            lappend out [join $curr] 
            set curr [list $word] 
            set i [string len $word] 
         } { 
            lappend curr $word 
         } 
         incr i 
      } 
      if {[llength $curr]} { 
         lappend out [join $curr] 
      } 
   } 
   set out 
}

putlog "EggRPG Loaded!"
