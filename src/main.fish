#!/usr/bin/env fish 
# title       : Flyfish Prompt Main Script
# author      : anirath
# created     : 2019.11.18
# modified    : 2020.05.01
# usage       : sourced by the Fish Shell when FlyFish is installed.
# file        : `./main.fish`
# description : main script file for the FlyFish prompt.
# ==================================================================
# PWD Functions -- prompts_pwd()
# ==============================
function prompts_pwd --description "A smaller version of `prompt_pwd` to shorten `pwd` without arguments."
    # Generate a formatted PWD string.
    set -l len 1; and set -l tmp (pwd); and string replace -ar '(\.?[^/]{'"$len"'})[^/]*/' '$1/' $tmp
end
# ========================================================
# Segment Separator Function -- prompts_segmentSeparator()
# ========================================================
function prompts_segmentSeparator --description "Formats and writes a separator for prompt segments."
    # Format and print a separator for prompt segments.
    set_color normal; and set_color -o blue; and printf '%s' " :: "; and set_color normal
end
# =====================================
# Main Prompt Function -- fish_prompt()
# =====================================
function fish_prompt --description "Write the primary shell user prompt with configured segments."
    # -------------------
    # User & Host Segment
    # -------------------
    # Format the text and output the user and hostname for this segment.
    set_color -o bryellow; and printf '%s' (whoami); and set_color -o white; and printf '@'
    set_color -o brmagenta; and printf '%s' (hostname|cut -d . -f 1); and prompts_segmentSeparator
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
    printf "%s" ">> "; and set_color -i A3A3A3
    set _path (string trim -c=" >" (string replace -a "/" " > "  (prompts_pwd))); and printf "%s" "$_path"
    prompts_segmentSeparator
    # --------------
    # Python Segment
    # --------------
    if test (count *.py) -gt 0
        # If any files with extension '.py' are present in the PWD then print out the Python Segment.
        set_color -o brgreen; and printf '%b' "\U1F40D Python Project \U1F40D"; and prompts_segmentSeparator
    end
    # -------------
    # Input Segment
    # -------------
    # Set up the user input segment below the prompt's first line.
    echo; and set_color cyan; and printf '>> '; and set_color normal
end
