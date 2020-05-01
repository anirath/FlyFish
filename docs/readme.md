# README #

## Flyfish Prompt ##
[FlyFish][1] is a small set of scripts containing functions to replace the Fish Shell's prompt. It replaces both
the main prompt and the right prompt. At this time the project is technically functioning, but the
documentation needs to be updated, and there may be future updates. For now, you can still easily install and
configure [FlyFish][1].

## Download ##
You can download [FlyFish][1] from the [releases][2] page, or you can clone the [github repository][4].

## Install ##
Installing [FlyFish][1] is made easy with the included [install][3] script. Or, if you feel like it you can
manually install it by moving the proper scripts into your Fish Shell's Config. Follow the steps below to
install and configure [FlyFish][1] as your Fish Shell's prompt.

### Acquiring FlyFish ###
First you need to get your hands on [FlyFish][1] by either downloading a release from [here][2], as mentioned
above, or by cloning the [github repository][4]. Details for each can be found below:

#### Release Download ####
    - Pickup a release from [here][2].
    - Unpack it using: `tar -xzf RELEASE_FILE` where *RELEASE_FILE* will point to the archive you downloaded.
    
#### Clone GitHub Repository ####
    - Clone the repository with `git clone https://github.com/anirath/FlyFish.git TARGET` where *TARGET* is
    the folder you wish to clone it into.
    
### Installing FlyFish ###
Now that you have the files you need install the project. There are two methods to achieve this. You can
either run the included [install][3] script or manually copy the files to the proper location. Details for
both methods are below:

#### Install Script ####
- Navigate to the root of the project. This will either be inside the folder you unpacked from your release
archive, or inside the repository you cloned.
- Execute the install script: `./install.sh`. *If you can't execute it try using `chmod +x install.sh` first.*
- Follow the prompts to automatically install [FlyFish][1].
- The script should notify you of a successful installation.

#### Manual Installation ####
- Copy the two script files, `./src/main.fish` and `./src/right.fish` into the functions folder for Fish. *This will be `~/.config/fish/functions/` by default.*
- Rename the main script to `fish_prompt.fish`.
- Rename the right script to `fish_right_prompt.fish`.
- That's it! You should be using [FlyFish][1] now. Open up the Fish Shell to check it out.

[1]: https://anirath.github.io/FlyFish
[2]: https://github.com/anirath/FlyFish/releases
[3]: https://github.com/anirath/FlyFish/blob/master/install.sh
[4]: https://github.com/anirath/FlyFish
