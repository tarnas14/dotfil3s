ybacklight
==========

It's no [xbacklight](https://cgit.freedesktop.org/xorg/app/xbacklight/).

Why?
----

Maybe you can't set your brightness via `xbacklight` but are able to change the brightness by manually modifying the files under `/sys/class/backlight`

How?
----

Since `ybacklight` aims to be a `xbacklight` replacement, expect to find similar CLI behaviour (for the functionality that's easy to implement):

	Usage:
		-set <value> # Set brightness to given percentage
		-inc <value> # Increase brightness by the given percentage
		-dec <value> # Increase brightness by the given percentage
        -get # Get the brightness percentage
		-raw_set <value> # Set absolute brightness (maximum depends on the system)
		-raw_get # Get absolute brightness (maximum depends on the system)
