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
# Title       : Fish Script -- Right Prompt Autoloaded Function
# Author      : Anirath
# Created     : 2019.11.18
# Revised     : 2020.06.28
# Revision    : `rev.02`
# Usage       : Sourced by `fish`
# File        : Source -- `./src/functions_right.fish` :: Release Default -- `~/.config/fish/functions/fish_right_prompt.fish`
# Description : This script sets up the functions for the right prompt of FlyFish for the `fish` shell.
# ================================================================================================================================
# Autoloaded Function
# ===================
function fish_right_prompt -d "Autoloaded by the shell to print the right part of the prompt."
    # ---------
    # Variables
    # ---------
    # Set a local variable that stores whether the CWD is a `git` repository.
    set -l is_git_repository (git rev-parse --is-inside-work-tree ^/dev/null)
    # Set a local variable with a boolean value for when a separator is needed, and default to `false`.
    set -l need_sep "false"
    # --------------
    # Git Repository
    # --------------
    # Test the local variable `$is_git_repository` to check if the CWD is a repository.
    if test -n "$is_git_repository"
        # If the CWD is a repository then start by printing the beginning of this segment.
        set_color 999999; printf "[git:"
        # Get the status of the repository.
        set -l branch (git symbolic-ref --short HEAD ^/dev/null; or git show-ref --head -s --abbrev | head -n1 ^/dev/null)
        git diff-files --quiet --ignore-submodules ^/dev/null; or set -l has_unstaged_files
        git diff-index --quiet --ignore-submodules --cached HEAD ^/dev/null; or set -l has_staged_files
        # Query the relevant variables to check for staged files.
        if set -q has_unstaged_files
            # Set the text color to `red` if there are unstaged files.
            set_color red
        else if set -q has_staged_files
            # Set the color to `yellow` if there are staged files.
            set_color yellow
        else
            # Set the color to `green` for a clean repository.
            set_color green
        end
        # Print the current branch using the previously set text color then set the color to `999999`.
        printf "$branch"; set_color 999999
        # Get the upstream status of the repository.
        git rev-parse --abbrev-ref '@{upstream}' >/dev/null; and set -l has_upstream
        # Query `$has_upstream` to check for upstream.
        if set -q has_upstream
            # If the repository has upstream set the pertinent status in variables.
            set -l commit_counts (git rev-list --left-right --count 'HEAD...@{upstream}' ^/dev/null)
            set -l commits_to_push (echo $commit_counts | cut -f 1 ^/dev/null)
            set -l commits_to_pull (echo $commit_counts | cut -f 2 ^/dev/null)
            # Check for any commits to push.
            if test $commits_to_push != 0
                # If there are commits to push then check for commits to pull.
                if test $commits_to_pull -ne 0
                    # If there are commits to pull set the text color to `red`.
                    set_color red
                else if test $commits_to_push -gt 3
                    # If there are no commits to pull, and more than `3` commits to push, set the text color to `yellow`.
                    set_color yellow
                else
                    # If there are no commits to pull, and `3` or less commits to push, set the text color to `green`.
                    set_color green
                end
                # Print the upstream push symbol using the set text color.
                printf "⇡"
            end
            # Check for any commits to pull.
            if test $commits_to_pull != 0
                # If there commits to pull then check for commits to push.
                if test $commits_to_push -ne 0
                    # If there are commits to push too then set the text color to `red`.
                    set_color red
                else if test $commits_to_pull -gt 3
                    # If there are no commits to push, and greater than `3` commits to pull, set the text color to `yellow`.
                    set_color yellow
                else
                    # If there are no commits to push, and `3` or less commits to pull, set the text color to `green`.
                    set_color green
                end
                # Print the upstream pull symbol using the set text color.
                printf "⇣"
            end
        end
        # Check for any stashed changes.
        if test (git stash list | wc -l) -gt 0
            # If stashed changes are found format and print the corresponding symbol.
            set_color 999999; printf ":"; set_color white; printf "☰"
        end
        # Finish the segment with a close bracket and reset the text color.
        set_color 999999; printf "]"; set_color normal
    end
    # --------------
    # Fish Scripting
    # --------------
    # Check the CWD for any `.fish` files.
    if test (count *.fish) -gt 0
        # Check if the CWD is a `git` repository.
        if test -n "$is_git_repository"
            # Print a separator if necessary.
            flyfish_separator
        end
        # Format and print the segment, and set `$need_sep` to `true`.
        set_color -o cyan; printf "\U1F41F Fish \U1F41F"; set_color normal; set need_sep "true"
    end
    # ------
    # Python
    # ------
    # Check the CWD for any `.py` files.
    if test (count *.py) -gt 0
        # Check if the CWD is a `git` repository.
        if test -n "$is_git_repository"
            or test "$need_sep" = "true"
            # If it is a repository, or `$need_sep` is set to `true`, print a separator.
            flyfish_separator
        end
        # Format and print the segment.
        set_color -o green; printf "\U1F40D Python \U1F40D"; set_color normal
    end
    # --------------
    # Variable Reset
    # --------------
    # Erase the local variables created by this function. They will be created again next time the prompt is called.
    set -e is_git_repository
    set -e need_sep
end
