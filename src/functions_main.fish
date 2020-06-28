#!/usr/bin/env fish
# ================================================================================================================================
# Project Metadata
# ----------------
# Title       : FlyFish
# Version     : `v1.0-alpha`
# Created     : 2019.11.18
# Released    : 2020.06.28
# Description : Adds a custom prompt to the `fish` shell configured with various useful segments.
# ================================================================================================================================
# File Metadata
# -------------
# Title       : Fish Script -- Main Prompt Autoloaded Function
# Author      : Anirath
# Created     : 2019.11.18
# Revised     : 2020.06.28
# Revision    : `rev.02`
# Usage       : Sourced by `fish`
# File        : Source -- `./src/functions_main.fish` :: Release Default -- `~/.config/fish/functions/fish_prompt.fish`
# Description : This script sets up the functions for the main prompt of FlyFish for the `fish` shell.
# ================================================================================================================================
# Support Functions
# =================
# Segment Separator
# -----------------
function separator --description "Prints a segment separator when called by the prompt function."
    # Format and print a separator for prompt segments.
    set_color normal; set_color -o blue; printf " :: "; set_color normal
end
# ===================
# Autoloaded Function
# ===================
# Main Prompt
# -----------
function fish_prompt --description "Autoloaded by the shell to print the main part of the prompt."
    # Set a local variable containing the last status returned before handling the segments.
    set -l last_status $status
    # ---------
    # User/Host
    # ---------
    # Format and print the user/host segment
    set_color -o bryellow; printf '%s' (whoami); set_color white; printf '@'; set_color -o brmagenta
    printf '%s' (hostname|cut -d . -f 1); set_color normal
    # -------------------------
    # Current Working Directory
    # -------------------------
    # Print a separator before the segment.
    separator
    # Check the CWD write permissions.
    if not test -w (pwd)
        # Set the text color to `brred` if the CWD is not writable by the current user.
        set_color -i brred
    else
        # Set the text color to `brgreen` if the CWD is writable by the current user.
        set_color -i brgreen
    end
    # Using the previously set text color print out the write permissions indicator then format and print the CWD.
    printf ">> "; set_color -i 999999; printf '%s' (string trim -c=" >" (string replace -a "/" " > "  (pwd))); set_color normal
    # --------------------------
    # Python Virtual Environment
    # --------------------------
    # Query the `$VIRTUAL_ENV` variable to check for an active python virtual environment.
    if set -q VIRTUAL_ENV
        # If a virtual environment is detected print a separator before the segment.
        separator
        # Set a local variable containing the virtual environment's name.
        set -l venv (basename "$VIRTUAL_ENV");
        # Format and print the segment using the local variable `$venv`.
        set_color 999999; printf "[venv:"; set_color -o cc3300; printf "$venv"; set_color normal; set_color 999999; printf "]"
        set_color normal
    end
    # ------------
    # Error Status
    # ------------
    # Check the `$last_status` for any error codes.
    if not test "$last_status" -eq 0
        # If an error was returned print a separator before the segment.
        separator
        # Format and print the segment containing the current error code in `$last_status`.
        set_color -o red; printf "%b" "\U203C Error $last_status \U203C "; set_color normal
    end
    # -----------
    # User Prompt
    # -----------
    # Start a new line and print the user prompt indicator to finish executing the Main Prompt Function.
    echo; set_color blue; printf '>> '; set_color normal
end
