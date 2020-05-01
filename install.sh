#!/usr/bin/env bash
# title       : Install FlyFish
# author      : anirath
# created     : 2020.04.30
# modified    : 2020.05.01
# version     : v1.0
# released    : 2020.05.01
# usage       : `./install.sh`
# file        : install.sh
# description : installs the two fish scripts for the FlyFish prompt into the user's Fish Shell config.
# =====================================================================================================
# Start Init
# ==========
# ----------------
# Handle Arguments
# ----------------
while true; do
    if [[ $# -eq 1 ]]; then
        # If one argument was provided then set $option to $1, $args to 1, and break from the loop.
        export option="$1" && export args=1 && break
    elif [[ $# -gt 1 ]]; then
        # If too many arguments were provided display a quick message and exit 1.
        echo "You provided too many arguments, please run the script again with valid or no arguments."
        echo "Try '-h' or '--help' to view a useful help message." && exit 1
    else
        # If no arguments were provided then set $option to null, $args to 0, and break from the loop.
        export option='' && export args=0 && break
    fi
done
# ----------------
# Export Variables
# ----------------
# Files & Directories
export install_script=$(basename "$0") && install_script=$(readlink -f "$install_script")
export project_dir=$(dirname "$0") && project_dir=$(readlink -f "$project_dir")
export docs="${project_dir}/docs/"
export readme="${docs}readme.md"
export project_src="${project_dir}/src/"
export src_script_1="${project_src}main.fish"
export src_script_2="${project_src}right.fish"
export install_log="${project_dir}/install.log"
export fish_config="${HOME}/.config/fish/"
export install_target="${fish_config}functions/"
export script_1="fish_prompt.fish"
export script_2="fish_right_prompt.fish"
# Functionality
export err=''
export input=''
export input_2=''
export str=''
export param=''
export switch=''
export datestamp=$(date +%H:%M\ \o\n\ %Y.%m.%d)
export alert=$(tput bel)
# Text Formatting
export txt_clear=$(tput clear)
export txt_reset=$(tput sgr0)
    # Foreground
export txt_bold=$(tput bold)
export txt_uline_on=$(tput smul)
export txt_uline_off=$(tput rmul)
export txt_dim=$(tput dim)
export txt_red=$(tput setaf 1)
export txt_green=$(tput setaf 2)
export txt_yellow=$(tput setaf 3)
export txt_cyan=$(tput setaf 6)
    # Background
export txtbg_black=$(tput setab 0)
# Error Messages
export err_msg_1="Undefined exception has occurred. This error should never happen. If you see this please try again, or contact the developer if the error persists."
export err_msg_2="No directory was found at the provided path. Please try again, and provide a valid existing path."
export err_msg_3="You have provided an invalid response. Please try again."
export err_msg_4="The install failed while trying to create the functions directory for the Fish config."
export err_msg_5="The install was unable to write the FlyFish script files to your Fish config directory. Please try again, or contact the developer if this issue persists."
export err_msg_6="The script was unable to create the provided Fish Shell config directory."
export err_msg_7="The install script was unable to write the logfile to disk! Try again, or contact the developer if this issue persists."
export err_msg_8="The readme file couldn't be viewed with your selected command. Please manually open the readme, ${readme}, in your preferred application."
export err_msg_9="You can't install FlyFish while an existing script for Fish's prompt exists in the selected config directory. Please remove any existing files from the Fish config, or allow the install script to remove them next time."
export err_msg_10="The install was unable to rename the existing logfile with a '.old' suffix. Please try again, or contact the developer if this issue persists."
export err_msg_11="The install failed while attempting to remove a conflicting file from your Fish config."
# -------------
# Export Arrays
# -------------
export conflicts=( "script_1" "script_2" )
export err_array=( "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" )
export clean_vars=( "option" "install_script" "project_dir" "docs" "readme" "project_src" "src_script_1" )
clean_vars=( "${clean_vars[@]}" "src_script_2" "install_log" "fish_config" "install_target" "script_1" )
clean_vars=( "${clean_vars[@]}" "script_2" "err" "input" "input_2" "str" "param" "switch" "datestamp" "alert" )
clean_vars=( "${clean_vars[@]}" "txt_clear" "txt_reset" "txt_uline_on" "txt_uline_off" "txt_dim" "txt_red" )
clean_vars=( "${clean_vars[@]}" "txt_green" "txt_yellow" "txt_cyan" "txtbg_black" )
for i in "${err_array[@]}"; do
    clean_vars=( "${clean_vars[@]}" "err_msg_${i}" )
done
# -----------------
# Declare fish_funcs
# -----------------
# quit() -- handles quitting the script.
function quit () {
    # Set $i to $1 and run cleanup() before quitting.
    cleanup
    if [[ $i -gt 0 ]]; then
        # If $i is greater than 0 run exit "$i".
        exit "$i"
    else
        # Otherwise, just run exit 0.
        exit 0
    fi
}
# error() -- processes errors that occur by displaying the corresponding message and handling the error.
function error () {
    # Set $err to the passed parameter, set $str to the corresponding message, and display the message.
    err="$1" && str="err_msg_${err}" && printf "${txt_reset}" && echo
    printf "${txtbg_black}${txt_red}${txt_uline_on}ERROR!${txt_uline_off} ${txt_bold}[Code: ${err}]"
    printf "${txt_reset}${txtbg_black} ${txt_red}${!str}${txt_reset}\n\n"
    if [[ $err == 2 || $err == 3 ]]; then
        # For errors that aren't fatal run cont_prompt(), clear $err & $str, and return 0.
        cont_prompt && err='' && str='' && return 0
    else
        # If the error is fatal then run quit($err).
        quit "$err"
    fi
}
# cleanup() -- cleans up after the script then returns.
function cleanup () {
    for i in "${clean_vars[@]}"; do
        # For each item in the $clean_vars[@] array unset the corresponding variable.
        unset "$i"
    done
    # After the cleanup unset the arrays and return 0.
    unset conflicts && unset err_array && unset clean_vars && return 0
}
# check_options() -- checks the provided argument for any valid options.
function check_options () {
    if [[ $option == -h || $option == --help ]]; then
        # If the help option is selected run help().
        help
    else
        # Display a quick message for invalid argument's and quit 1.
        echo "You provided an invalid argument, please run the script again with valid or no arguments."
        echo "Try '-h' or '--help' to view a useful help message." && quit 1
    fi
}
# help() -- displays the script's help message to the user.
function help () {
    # Clear screen, run banner() to display the welcome banner, and display the help page header.
    printf "${txt_clear}" && banner
    printf "${txt_green}Help for the ${txt_bold}FlyFish${txt_reset}${txt_green} install script.${txt_reset}\n\n"
    # Display a short help message and ask the user if they'd like to view the readme file.
    printf "FlyFish's documentation can be found in the 'docs' subdirectory of the project's source: ${txt_uline_on}${docs}${txt_uline_off}\n"
    printf "Or, you can visit the project's webpage at ${txt_uline_on}https://flyfish.github.io/${txt_reset}.\n"
    printf "Most questions can likely be answered by reading the project's readme file: ${txt_uline_on}${readme}${txt_reset}\n\n"
    while true; do
        printf "    ${txt_yellow}${txt_bold}View Readme or Cancel:${txt_reset}${txt_yellow}\n"
        printf "      1) Pager\n      2) Cat\n      3) Cancel${txt_bold}\n>> "
        read -res -n 1 input && printf "${txt_reset}"
        case "$input" in
            "1")
                # If the user selects 'Pager' run the command on $readme.
                pager "$readme" || error 8
                # After the user exits their pager program run quit(0).
                quit 0;;
            "2")
                # If the user selects 'Cat' then run cat on $readme, and quit(0).
                cat "$readme" || error 8
                quit 0;;
            "3")
                # If the user selects 'Cancel' then run quit(0).
                quit 0;;
            *)
                # Handle an invalid user input with error(3) and continue the loop.
                error 3 && continue;;
        esac
    done
}
function banner () {
    # Display a welcome banner for FlyFish then return 0.
    printf "${txt_bold}${txt_cyan}"
    printf "  ______ _       ______ _     _     \n"
    printf " |  ____| |     |  ____(_)   | |    \n"
    printf " | |__  | |_   _| |__   _ ___| |__  \n"
    printf " |  __| | | | | |  __| | / __| '_ \ \n"
    printf " | |    | | |_| | |    | \__ \ | | |\n"
    printf " |_|    |_|\__, |_|    |_|___/_| |_|\n"
    printf "            __/ |                   \n"
    printf "           |___/                    \n\n"
    printf "${txt_reset}" && return 0
}
function goodbye () {
    printf "You have successfully installed ${txt_green}${txt_bold}FlyFish${txt_reset} at ${datestamp}!\n"
    printf "${txt_dim}To review all changes this install script made open the logfile: ${txt_uline_on}"
    printf "${install_log}${txt_reset}\n\n"
    quit 0
}
# cont_prompt() -- prompts the user to press any key to continue.
function cont_prompt () {
    # Prompt the user to press any key and return 0.
    printf "${txt_dim}" && read -res -n 1 -p "[Press any key to continue...]"
    printf "${txt_reset}" && echo && return 0
}
# init() -- initializes the FlyFish install script.
function init () {
    # Display the init() function's welcome header after the banner() function.
    banner
    printf "${txt_green}Welcome to the install script for ${txt_bold}FlyFish${txt_reset}${txt_green}!${txt_reset}\n\n"
    # Prompt the user to select their type of installation.
    printf "${txt_dim}You can choose to run this install in basic or advanced mode. For most users the basic option should be best.${txt_reset}\n\n"
    while true; do
        printf "    ${txt_yellow}${txt_bold}Select Installation Type:${txt_reset}${txt_yellow}\n"
        printf "      1) Basic\n      2) Advanced\n      3) Help${txt_bold}\n>> "
        read -res -n 1 input && printf "${txt_reset}"
        case "$input" in
            "1")
                # Set $typeof to 1 and return 0 for a basic install.
                echo && typeof=1 && return 0;;
            "2")
                # Set $typeof to 2 and return 0 for an advanced install.
                echo && typeof=2 && return 0;;
            "3")
                # If the user selects help then run help().
                help;;
            *)
                # Handle an invalid user input with error(3) and continue the loop.
                error 3 && continue;;
        esac
    done
}
# configure() -- allow the user to configure the path to their Fish's config directory.
function configure () {
    # Check the default config directory first.
    if [[ -d $fish_config ]]; then
        while true; do
            # Display a message if the default config is detected then prompt the user if they want to use it.
            printf "The default location of the Fish Shell's config was detected at: ${txt_uline_on}${fish_config}${txt_uline_off}\n"
            printf "${txt_yellow}Would you like to use the default config? ${txt_bold}[Y/n]\n"
            read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
            case "$input" in
                [Yy])
                    # If the user selects to use the default config, which was already detected, then return 0.
                    return 0;;
                [Nn])
                    # If the user selects not to use the default config then break from the loop.
                    break;;
                *)
                    # Handle invalid input with error(3) and continue.
                    error 3 && continue;;
            esac
        done
    fi
    # Display a message to the user for providing the Fish config.
    printf "\nYou have selected to manually provide the path to the config directory for the Fish Shell.\n"
    printf "Please enter the full path below.\n"
    while true; do
        # Prompt the user to input the path to the config, trim trailing slashes, then set variables.
        printf "${txt_yellow}Path to Fish Config (e.g. ~/.config/fish/):${txt_bold}\n"
        read -re -p ">> " input && input=$(echo $input | sed 's:/*$::') && input="${input}/"
        fish_config="$input" && install_target="${fish_config}functions/" && printf "${txt_reset}"
        if [[ ! -d $fish_config ]]; then
            # If the provided path doesn't exist run error(2) and continue the loop.
            error 2 && continue
        elif [[ ! -d $install_target ]]; then
            # If the $install_target doesn't exist attempt to create it. If successfull then return 0.
            mkdir "$install_target" || error 4
            return 0
        else
            # If the provided input is all valid then return 0.
            return 0
        fi
    done
}
function configure_advanced () {
    # --------------------
    # Intro & Confirmation
    # --------------------
    # Display a message for advanced install users, and show all current settings.
    printf "${txt_dim}You've chosen an advanced install. You have the option to configure most details.${txt_reset}\n"
    printf "${txt_yellow}${txt_bold}Current Settings:${txt_reset}\n"
    printf "Fish Config                     : ${txt_uline_on}${fish_config}${txt_uline_off}\n"
    printf "Fish Functions (Install Target) : ${txt_uline_on}${install_target}${txt_uline_off}\n"
    printf "FlyFish Main Script Filename    : ${txt_uline_on}${script_1}${txt_uline_off}\n"
    printf "FlyFish Right Script Filename   : ${txt_uline_on}${script_2}${txt_uline_off}\n"
    printf "FlyFish Install Logfile         : ${txt_uline_on}${install_log}${txt_reset}\n\n"
    while true; do
        # Prompt the advanced install user to either continue with current settings or configure them.
        printf "${txt_yellow}Continue Installation With Current Settings? ${txt_bold}[Y/n]\n"
        read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
        case "$input" in
            [Yy])
                # If the user would like to continue with the current settings then return 0.
                return 0;;
            [Nn])
                # If the user wants to configure settings then set $switch 0 and break loop.
                switch=0 && break;;
            *)
                # Handle an invalid user input with error(3) and continue the loop.
                error 3 && continue;;
        esac
    done
    # -------------------
    # User Config Prompts
    # -------------------
    while true; do
        if [[ $switch == 1 ]]; then
            # If the user just finished inputting settings then display the new settings.
            printf "${txt_yellow}${txt_bold}New Settings:${txt_reset}\n"
            printf "Fish Config                     : ${txt_uline_on}${fish_config}${txt_uline_off}\n"
            printf "Fish Functions (Install Target) : ${txt_uline_on}${install_target}${txt_uline_off}\n"
            printf "FlyFish Main Script Filename    : ${txt_uline_on}${script_1}${txt_uline_off}\n"
            printf "FlyFish Right Script Filename   : ${txt_uline_on}${script_2}${txt_uline_off}\n"
            printf "FlyFish Install Logfile         : ${txt_uline_on}${install_log}${txt_reset}\n\n"
            while true; do
                # Prompt the user to confirm the new settings or configure them again.
                printf "${txt_yellow}Confirm Settings? ${txt_bold}[Y/n]\n"
                read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
                case "$input" in
                    [Yy])
                        # If confirmed then set $switch='', echo, and return 0.
                        switch='' && return 0;;
                    [Nn])
                        # If the user needs to change settings again then set $switch 0 and break loop.
                        switch=0 && break;;
                    *)
                        # Handle an invalid user input with error(3) and continue the loop.
                        error 3 && continue;;
                esac
            done
            # If the user didn't confirm the new settings continue loop.
            continue
        fi
        while true; do
            # Prompt for the Fish config directory.
            printf "${txt_yellow}Change the Fish Config? ${txt_bold}[Y/n]\n"
            read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
            case "$input" in
                [Yy])
                    # If the user configures the Fish config the prompt and change variables from $input.
                    printf "${txt_yellow}Path to Fish Config (e.g. ~/.config/fish/):${txt_bold}\n"
                    read -re -p ">> " input && input=$(echo $input | sed 's:/*$::') && input="${input}/"
                    fish_config="$input" && install_target="${fish_config}functions/" && printf "\n${txt_reset}"
                    if [[ ! -d $fish_config ]]; then
                        # If the config directories don't exist attempt to create them.
                        mkdir "$fish_config" || error 6
                        mkdir "$install_target" || error 4
                    elif [[ ! -d $install_target ]]; then
                        # If the $install_target doesn't exist attempt to create it.
                        mkdir "$install_target" || error 4
                    fi
                    # Break from the loop after providing the $install_target.
                    break;;
                [Nn])
                    # Break the loop immediately if no need to configure the $install_target.
                    break;;
                *)
                    # Handle an invalid user input with error(3) and continue the loop.
                    error 3 && continue;;
            esac
        done
        while true; do
            # Prompt for the Main Script Target Filename.
            printf "${txt_yellow}Change the Main Script Filename? ${txt_bold}[Y/n]\n"
            read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
            case "$input" in
                [Yy])
                    # If the user says yes then prompt for input, set variables, and break loop.
                    printf "${txt_yellow}Main Script Filename (e.g. fish_prompt.fish):${txt_bold}\n"
                    read -re -p ">> " input && script_1="$input" && printf "\n${txt_reset}" && break;;
                [Nn])
                    # If the user declines to input then break loop.
                    break;;
                *)
                    # Handle invalid user input with error(3) and continue.
                    error 3 && continue;;
            esac
        done
        while true; do
            # Prompt for the Right Script Target Filename.
            printf "${txt_yellow}Change the Right Script Filename? ${txt_bold}[Y/n]\n"
            read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
            case "$input" in
                [Yy])
                    # If the user says yes then prompt for input, set variables, and break loop.
                    printf "${txt_yellow}Right Script Filename (e.g. fish_right_prompt.fish):${txt_bold}\n"
                    read -re -p ">> " input && script_2="$input" && printf "\n${txt_reset}" && break;;
                [Nn])
                    # If the user declines to input then break loop.
                    break;;
                *)
                    # Handle invalid user input with error(3) and continue.
                    error 3 && continue;;
            esac
        done
        while true; do
            # Prompt for the Logfile Target.
            printf "${txt_yellow}Change the Logfile Target? ${txt_bold}[Y/n]\n"
            read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
            case "$input" in
                [Yy])
                    # If the user says yes then prompt for input, set variables, and break loop.
                    printf "${txt_yellow}Logfile Target (e.g. /path/to/install.log):${txt_bold}\n"
                    read -re -p ">> " input && install_log="$input" && printf "\n${txt_reset}" && break;;
                [Nn])
                    # If the user declines to input then break loop.
                    break;;
                *)
                    # Handle invalid user input with error(3) and continue.
                    error 3 && continue;;
            esac
        done
        # After the user has gone through the config options set $switch 1 and continue the loop.
        switch=1 && continue
    done
}
# check_funcs() -- checks the set configuration for conflicts or issues.
function check_funcs () {
    for i in "${conflicts[@]}"; do
        # For each item in $conflicts[@] set $check to the full path.
        check="${install_target}${!i}"
        if [[ -f $check ]]; then
            # If $check is an existing file then display a message to the user.
            printf "A conflict was found while checking the config: ${txt_uline_on}${check}${txt_uline_off}\n"
            while true; do
                # Prompt the user to confirm removal of conflicting file.
                printf "${txt_yellow}Remove Conflicting File? ${txt_bold}[Y/n]\n"
                read -res -n 1 -p ">> " input && printf "\n${txt_reset}"
                case "$input" in
                    [Yy])
                        # If the user confirms then remove $check, increment $switch, and break from loop.
                        rm "$check" || error 11
                        break;;
                    [Nn])
                        # If the user doesn't confirm file removal then run error(9).
                        error 9;;
                    *)
                        # Handle an invalid user response.
                        error 3 && continue;;
                esac
            done
        fi
    done
    if [[ -f $install_log ]]; then
        # If the target install log already exists then add a '.old' suffix.
        input="${install_log}.old"
        if [[ -f $input ]]; then
            rm "$input" || error 7
        fi
        input='' && mv "$install_log" "${install_log}.old" || error 10
    fi
    # Reset some variables, create the logfile, and return 0.
    check='' && input='' && touch "$install_log" || error 7
    return 0
}
# install_log() -- creates, and fills in, a logfile for the install script.
function install_log () {
    echo "Successfully installed FlyFish at ${datestamp}." >> "$install_log" || error 7
    echo "" >> "$install_log" || error 7
    echo "Installed Files --" >> "$install_log" || error 7
    echo "Fish Shell Config   : ${fish_config}" >> "$install_log" || error 7
    echo "Main Prompt Script  : ${install_target}${script_1}" >> "$install_log" || error 7
    echo "Right Prompt Script : ${install_target}${script_2}" >> "$install_log" || error 7
    return 0
}
# flyfish_install() -- installs FlyFish with the configured settings.
function flyfish_install () {
    # Install the necessary scripts using cp from the source files.
    cp "${src_script_1}" "${install_target}${script_1}" || error 5
    cp "${src_script_2}" "${install_target}${script_2}" || error 5
    # Use chmod to make them executable if needed.
    chmod +x "${install_target}${script_1}" || error 5
    chmod +x "${install_target}${script_2}" || error 5
    # Set the $datestamp, run install_log(), and then goodbye().
    datestamp=$(date +%H:%M\ \o\n\ %Y.%m.%d) && install_log && goodbye
}
# ========
# End Init
# =============
# Start Program
# =============
# --------------
# Handle Options
# --------------
if [[ $args -eq 1 ]]; then
    check_options
fi
# ----
# Init
# ----
init
# ------------------
# User Configuration
# ------------------
if [[ $typeof == 1 ]]; then
    # If basic is selected run configure().
    configure
elif [[ $typeof == 2 ]];then
    # If advanced is selected then run configure_advanced().
    configure_advanced
fi
# ---------------
# FlyFish Install
# ---------------
# Run check_funcs() followed by flyfish_install() to install with configured settings.
check_funcs && flyfish_install
# ===========
# End Program
# ===========
