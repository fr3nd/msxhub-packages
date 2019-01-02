proc wait_until_boot {} {
  global throttle
  set boot_done -1
  if {[catch {set boot_done [string first "BOOT COMPLETED" [get_screen]]} err_msg]} {
    puts stderr "warning: $err_msg"
  }
  if {$boot_done == -1} {
    after time 5 wait_until_boot
  } else {
    set throttle on
  }
}

diskmanipulator create DSK.dsk 32m
hda DSK.dsk
diskmanipulator import hda ./dsk/

set save_settings_on_exit off
set throttle off
after realtime 1 wait_until_boot
