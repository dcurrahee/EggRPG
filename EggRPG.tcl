putlog "\002RPG\002 Loaded!"

#Globals
set MaxCharacterSlots 3 
set rpgchan #EggRPG

#XTRAs
# Logged - whether user is logged in as a character or not
# CharacterSlot# - Character/Password slots
# Health# - characters health
# Mana# - characters mana
# Speed# - characters speed

#BINDS
bind msg - register RPG_Register
bind msg - login RPG_Login
bind msg - logoff RPG_Logoff
bind msg - delete RPG_Delete
bind msg - listcharacters RPG_ListCharacters
bind msg - whoami RPG_WhoAmI

proc RPG_WhoAmI { nick host hand arg } {
	set Logged [check_logged_in $hand]
	if {$Logged > 0} {
		set char [getuser $hand XTRA [characterslot $hand $Logged]]
		puthelp "PRIVMSG $nick :You are $char"
	} else {
		puthelp "PRIVMSG $nick :You are no one."
	}
}

proc RPG_Register { nick host hand arg } { 
	putlog "RPG_Register"
	if {[llength $arg] < 1 || [llength $arg] > 1} {
		puthelp "PRIVMSG $nick :\002Usage:\002 register <Character Name> "
	} else {
		set available [find_char_slot $hand ""]
		if {$available == 0} {
			puthelp "PRIVMSG $nick :You have no free slots. If you want to create a new character you'll have to free up a slot"
			return 0
		} else {
			set slot [characterslot $hand $available] 
			setuser $hand XTRA $slot $arg
			logout $hand
			setuser $hand XTRA Logged $available
			puthelp "PRIVMSG $nick :$arg has been logged \002IN\002"	
		}
	}
} 

proc RPG_Delete { nick host hand arg } {
	global MaxCharacterSlots
	putlog "$hand delete $arg"
	if {[llength $arg] != 1} {
		puthelp "PRIVMSG $nick :$arg is not a character you own."
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
				puthelp "PRIVMSG $nick :$arg has been \002DELETED\002"
				return 0
			}
		}
	}
}

proc RPG_Login { nick host hand arg} {
	global MaxCharacterSlots
	putlog "$hand login $arg"
	if {[llength $arg] == 1} {
		set slot [find_char_slot $hand $arg]
		if {$slot == 0} {
			puthelp "PRIVMSG $nick :No such character by the name of $arg is found."
			return 0
		}
		set logged [check_logged_in $hand]
		if {$logged == $slot} {
			puthelp "PRIVMSG $nick :$arg is already logged in"
			return 0
		}
		logout $hand
		setuser $hand XTRA Logged $slot
		puthelp "PRIVMSG $nick :$arg has been logged \002IN\002"
	} else {
		puthelp "PRIVMSG $nick :\002Usage:\002 login <Character Name>"
		return 0
	}
}

proc RPG_Logoff { nick host hand arg} {
	set Logged [logout $hand]
	if { $Logged == 0 } {
		puthelp "PRIVMSG $nick :You are currently not logged into any characters"
	}
}

proc RPG_ListCharacters { nick host hand arg } {
	global MaxCharacterSlots
	puthelp "PRIVMSG $nick :\002Characters:\002"
	for {set i 1} {$i <= $MaxCharacterSlots} { incr i } {
		set slot [characterslot $hand $i]
		set char [getuser $hand XTRA $slot]
		if {$char != ""} {
			puthelp "PRIVMSG $nick :Slot $i: $char"
		}
	}
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
		puthelp "PRIVMSG $nick :$char has been logged \002OUT\002"
		return $Logged
	}
	return 0
}

proc characterslot { hand numb } {
	set slot "CharacterSlot"
	append slot $numb
	return $slot
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
