#!/usr/bin/env fish
# title       : FlyFish Prompt: Right Prompt Function Script
# author      : anirath
# created     : 2019.11.18
# modified    : 2020.05.14
# usage       : autoloaded by `fish`
# file        : `./right.fish`
# description : right script for the FlyFish prompt for `fish`.
# =============================================================
# Autoloaded Function -- fish_right_prompt()
# ==========================================
function fish_right_prompt -d "Write out the right prompt"
    # --------------
    # Git Repository
    # --------------
    # Use a variable to detect if CWD is a git repository.
    set -l is_git_repository (git rev-parse --is-inside-work-tree ^/dev/null)
    if test -n "$is_git_repository"
        # If the PWD is a git repository then print the git message and check the git status.
        set_color 999999; printf "[git:"
        set -l branch (git symbolic-ref --short HEAD ^/dev/null; or git show-ref --head -s --abbrev | head -n1 ^/dev/null)
        git diff-files --quiet --ignore-submodules ^/dev/null; or set -l has_unstaged_files
        git diff-index --quiet --ignore-submodules --cached HEAD ^/dev/null; or set -l has_staged_files
        if set -q has_unstaged_files
            # If the repository has unstaged files then set the status to red.
            set_color red
        else if set -q has_staged_files
            # If the repository has staged files then set the status to yellow.
            set_color yellow
        else
            # If the repository is clean then set the status to green.
            set_color green
        end
        # Print the git branch into the segment with the previously formatted colors.
        printf "$branch"; set_color 999999
        # Set the variables to determine upstream status.
        git rev-parse --abbrev-ref '@{upstream}' >/dev/null; and set -l has_upstream
        if set -q has_upstream
            # If the repository has upstream then set variables for the details.
            set -l commit_counts (git rev-list --left-right --count 'HEAD...@{upstream}' ^/dev/null)
            set -l commits_to_push (echo $commit_counts | cut -f 1 ^/dev/null)
            set -l commits_to_pull (echo $commit_counts | cut -f 2 ^/dev/null)
            # Test the commits to push and set the text color appropriately.
            if test $commits_to_push != 0
                if test $commits_to_pull -ne 0
                    set_color red
                else if test $commits_to_push -gt 3
                    set_color yellow
                else
                    set_color green
                end
                # Print the upstream push symbol with the set color.
                printf "⇡"
            end
            # Test the commits to pull and set the text color appropriately.
            if test $commits_to_pull != 0
                if test $commits_to_push -ne 0
                    set_color red
                else if test $commits_to_pull -gt 3
                    set_color yellow
                else
                    set_color green
                end
                # Print the upstream pull symbol with the set color.
                printf "⇣"
            end
        end
        if test (git stash list | wc -l) -gt 0
            # If there are any stashed changes print the corresponding symbol to the prompt.
            set_color 999999; printf ":"; set_color white; printf "☰"
        end
        set_color 999999; printf "]"; set_color normal
    end
    # --------------
    # Python Segment
    # --------------
    if test (count *.py) -gt 0
        # If any files with extension '.py' are present in the CWD then print out the Python Segment.
        flyfish_separator; set_color -o green; printf "\U1F40D Python \U1F40D"; set_color normal
    end
end
