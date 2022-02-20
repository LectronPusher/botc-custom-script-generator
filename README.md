## Blood on The Clocktower Custom Script Generator

Generates custom scripts and night order sheets for 8.5x11" paper with two scripts per sheet using Python and Latex with the roles.json and icons from [bra1n's townsquare](https://github.com/bra1n/townsquare) (Thank You Bra1n!)

#### Usage

To create a script, download all the files and your script's json to one directory,  then run generate_script.py with your json filename (with ".json") as the first argument (you can also just change the default filename variable inside the file). It will generate a .tex file that can be compiled with script.cls to create the script.

You can compile the Latex easily in [Overleaf](overleaf.com) by creating a new project from the included zip file (it's just Icons, Lora, and script.cls), then going to menu in the top left, changing the compiler from pdfLatex to LuaLatex, and pressing recompile with your generated script.

You need to use LuaLatex to compile as I use the \fontspec command to load the Lora font. You can set this in Overleaf by clicking "menu" at the top left.

#### Notes

Some characters have images that don't load when trimmed to fit, looks like it's expansion characters added to Bra1n's townsquare after May 2021, when the Bra1n images were cleaned and standardized. This is a problem that I haven't been able to solve in Latex, and might end up solving later. Unfortunately this means that custom images also won't work well as they aren't shifted the way most of the Bra1n images are.

This should work ok with custom scripts so long as they don't share an id with anything in roles.json, except for the problem with image trimmming.

I might add jinxes in the future. If like three people ask me to do it I could be persuaded.

You can also edit the .tex file directly to add spacing and custom things, script.cls is somewhat well commented, but I wouldn't expect to be able to parse it if you haven't used LaTex before.

#### Example Image

![Trouble Brewing Example](https://github.com/LectronPusher/botc-custom-script-generator/blob/main/Trouble%20Brewing%20front.png?raw=true)
![Trouble Brewing Example](https://github.com/LectronPusher/botc-custom-script-generator/blob/main/Trouble%20Brewing%20back.png?raw=true)
