set ARROW_LEFT ""
set ARROW_RIGHT ""

set COLOR_0 %COLOR_BLACK_L% 
set COLOR_1 %COLOR_PURPLE_L%
set COLOR_1D %COLOR_PURPLE%
set COLOR_2 %COLOR_YELLOW%
set COLOR_BAT %COLOR_TEAL%

set LBAR_DESKTOPS (bspc query -D --names)
set LBAR_ACTIVE (bspc query -D -d focused --names)
function lbar_desktops 
	if test $LBAR_DESKTOPS[1] = $LBAR_ACTIVE[1]
		printf "%%{F#%s}" $COLOR_1D
	else
		printf "%%{F#%s}" $COLOR_1
	end
	for dktp in $LBAR_DESKTOPS
		if test "$dktp" = $LBAR_ACTIVE[1]
			set lbar_color $COLOR_1D
		else
			set lbar_color $COLOR_1
		end
		printf "%%{B#%s}$ARROW_RIGHT%%{F#fff} %s %%{F#%s}" $lbar_color $dktp $lbar_color
	end
	printf "%%{B#%s}$ARROW_RIGHT" $COLOR_0
end
fish -c '
	bspc subscribe desktop &
	fish -c \'
		while true
			printf "LBAR_WIFI %s\n" (iwgetid -r)
			sleep 1
		end
	\' &
	begin
		while true 
			printf "LBAR_TIME %s\n" (date +%H:%M)
			sleep 10
		end
	end 
' | while true
	read LINE
	set PARTS (string split " " "$LINE")
	if test $PARTS[1] = "desktop_focus" 
		set LBAR_ACTIVE (bspc query -D -d focused --names)
	else 
		set $PARTS[1] $PARTS[2..-1]
	end

	printf "%%{l}%s%%{c}%%{F#fff}%s%%{r}%%{F#%s}$ARROW_LEFT%%{B#%s}%%{F#fff} %s %%{F#%s}$ARROW_LEFT%%{B#%s}%%{F#fff} %s%% %%{B#%s}\n" (lbar_desktops | string collect) "$LBAR_TIME" $COLOR_2 $COLOR_2 "$LBAR_WIFI" \
		"$COLOR_BAT" "$COLOR_BAT" (cat /sys/class/power_supply/BAT0/capacity) $COLOR_0
end
