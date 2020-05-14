#!/usr/bin/env fish
# title       : FlyFish Prompt: Main Prompt Function Script
# author      : anirath
# created     : 2019.11.18
# modified    : 2020.05.14
# usage       : autoloaded by `fish`
# file        : `./main.fish`
# description : main script for the FlyFish prompt for `fish`.
# ============================================================
# Segment Separator -- flyfish_separator()
# ========================================
function flyfish_separator --description "Formats and writes a separator for prompt segments."
    # Format and print a separator for prompt segments.
    set_color normal; set_color -o blue; printf " :: "; set_color normal
end
# ====================================
# Autoloaded Function -- fish_prompt()
# ====================================
function fish_prompt --description "Write the primary shell user prompt with configured segments."
    set -l last_status $status
    # ---------
    # Timestamp
    # ---------
    #set_color white; printf "["; set_color cyan; printf '%s' (date +%H:%M); set_color white; printf "]"; flyfish_separator
    # -----------
    # User & Host
    # ----------
    # Format the text and output the user and hostname for this segment.
    set_color -o bryellow; printf '%s' (whoami); set_color white; printf '@'; set_color -o brmagenta;
    printf '%s' (hostname|cut -d . -f 1); flyfish_separator
    # -----------
    # CWD Segment
    # -----------
    if not test -w (pwd)
        # If the PWD isn't writable then color the text bright red.
        set_color -i brred
    else
        # If the PWD is writable color the text bright green.
        set_color -i brgreen
    end
    # Print the indicator using the assigned color, set a new color and italics, then print segment.
    printf ">> "; set_color -i 999999; printf '%s' (string trim -c=" >" (string replace -a "/" " > "  (pwd))); set_color normal
    # ------------
    # Error Status
    # ------------
    if not test "$last_status" -eq 0
        flyfish_separator
        # If the last status is anything but 0 then set the error in this segment.
        set_color -o red; printf "%b" "\U203C Error $last_status \U203C "; set_color normal
    end
    # -------------
    # Input Segment
    # -------------
    # Set up the user input segment below the prompt's first line.
    echo; set_color blue; printf '>> '; set_color normal
end
