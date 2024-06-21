
# Import harddisk (note max 16mb for msxdos1)
if {[catch {diskmanipulator create DSK.dsk 15m} err_msg]} {
	puts stderr "error: create $err_msg"
	exit 1
}
if {[catch {hda DSK.dsk} err_msg]} {
	puts stderr "error: hda $err_msg"
	exit 1
}
if {[catch {diskmanipulator import hda ./dsk/} err_msg]} {
	puts stderr "error: import $err_msg"
	exit 1
}

# Export harddisk (note openmsx converts all to lower case)
after quit {
	if {[catch {diskmanipulator chdir hda \\} err_msg]} {
		puts stderr "error: chdir $err_msg"
		exit 1
	}
	if {[catch {diskmanipulator export hda ./dsk/} err_msg]} {
		puts stderr "error: export $err_msg"
		exit 1
	}
}

# Dynamic override of msx throttled speed.
if {[info exists ::env(SPEED)] && ([string trim $::env(SPEED)] != "")} {
	if {[catch {set speed [string trim $::env(SPEED)]} err_msg]} {
		puts stderr "error: env.SPEED value $err_msg"
		exit 1
	}
}

# Debug override to select SDL renderer for boot process.
if {[info exists ::env(RENDERER)] && ([string trim $::env(RENDERER)] != "")} {
	if {[catch {set renderer [string trim $::env(RENDERER)]} err_msg]} {
		puts stderr "error: env.RENDERER value $err_msg"
		exit 1
	}
}

# Enabled openMSX gui from inside
proc enable_gui {} {
	global renderer
	global throttle
	set renderer SDL
	set throttle on
}
