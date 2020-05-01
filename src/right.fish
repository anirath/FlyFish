#!/usr/bin/env fish 
# title       : Flyfish Prompt Right Script
# author      : anirath
# created     : 2019.11.18
# modified    : 2020.05.01
# usage       : sourced by the Fish Shell when FlyFish is installed.
# file        : `./right.fish`
# description : right script file for the FlyFish prompt.
# ==================================================================
# Right Prompt Function
# =====================
function fish_right_prompt -d "Write out the right prompt"
    # Before the segments set $last_status and $is_git_repository to reflect if using git.
    set -l last_status $status; and set -l is_git_repository (git rev-parse --is-inside-work-tree ^/dev/null)
    # --------------
    # Status Segment
    # --------------
    if not test "$last_status" -eq 0
        # If the last status is anything but 0 then set the error in this segment.
        set_color -o red; and printf "%b" "\U203C Error Code: $last_status \U203C"; and set_color normal
    end
    # -----------
    # Git Segment
    # -----------
    if test -n "$is_git_repository"
        # If the PWD is a git repository then print the git message and check the git status.
        set_color A3A3A3; and echo -n "[git:"
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
        echo -n "$branch]"
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
                echo -n " ⇡ "
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
                echo -n " ⇣ "
            end
            # Reset text formatting
            set_color normal
        end
        if test (git stash list | wc -l) -gt 0
            # If there are any stashed changes print the corresponding symbol to the prompt.
            set_color A3A3A3; and echo -n " ☰ "
        end
        # Reset text formatting.
        set_color normal
    end
end
