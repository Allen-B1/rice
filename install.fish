#!/bin/fish
cp ./sxhkdrc ~/.config/sxhkd/sxhkdrc

set COLOR_RED a65b5b
set COLOR_RED_L cc8585
set COLOR_GREEN 6c8059
set COLOR_GREEN_L 91a67c
set COLOR_YELLOW a78253
set COLOR_YELLOW_L bfaa6b
set COLOR_BLUE 606080
set COLOR_BLUE_L 8f95b3
set COLOR_PURPLE 7a6080
set COLOR_PURPLE_L ad8fb3
set COLOR_TEAL 668080
set COLOR_TEAL_L 8fb3b3
set COLOR_BLACK 1f2126
set COLOR_BLACK_L 32363f
set COLOR_GRAY 767680
set COLOR_WHITE bdbdc7

function replace_all
	set output (string join "
" $argv | string collect)
	set colors COLOR_RED COLOR_RED_L \
		COLOR_GREEN COLOR_GREEN_L \
		COLOR_YELLOW COLOR_YELLOW_L \
		COLOR_BLUE COLOR_BLUE_L \
		COLOR_PURPLE COLOR_PURPLE_L \
		COLOR_TEAL COLOR_TEAL_L \
		COLOR_BLACK COLOR_BLACK_L \
		COLOR_GRAY COLOR_WHITE

	for color in $colors
		set output (string replace "%$color%" "$$color" "$output" | string collect)
	end

	echo $output
end

set RICEDIR (fish -c "cd "(dirname (status filename))" && pwd")
echo '#!/bin/bash' > ~/.config/bspwm/bspwmrc
echo "RICEDIR=$RICEDIR" >> ~/.config/bspwm/bspwmrc
replace_all (cat ./bspwmrc) >> ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/bspwmrc

replace_all (cat ./lemonbar.fish)  > out/lemonbar.fish
replace_all (cat ./urxvt.xres) > out/urxvt.xres
