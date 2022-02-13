## Blood on The Clocktower Custom Script Generator

Generates custom scripts and night orders for 8.5x11" paper with two scripts per sheet using Python and Latex with the roles.json and icons from clocktower.online

#### Usage

To create a script, have your script's json in the same file as generate_script.py,  and run it with your scriptname (without ".json") as the first argument (you can also just change the default scriptname variable inside the file), and run it. It will generate a .tex file that can be compiled with script.cls to create the script.

Make sure to use LuaLatex to compile, as I use the fontspec command to load the Lora font. You can set this in Overleaf by using the menu at the top

You will also need to have roles.json the icons folder, and the Lora folder in the same directory. You can upload everything as a zip to Overleaf and it should just work.

You might need to find and edit the 4.35in (4.35 inches) number to make the night order side look good (increase or decrease it), I wasn't able to make it fancy Latex, maybe later. It's just a rule that has that height and controls the position of the other nights side, but I use a rotatebox that refuses to compile with the origin set to top, so it's hard to predict.

#### Notes

Some characters have images that don't load when I trim them to the size of the other images, looks like it's expansion characters added after May 2021, when the Bra1n images were cleaned. Need to clean these manually; working on it.

You can definitely get this to work with custom scripts, I haven't put in the effort yet. It should also be pretty easy to edit the generated output directly.

#### Example Image

![Trouble Brewing Example](https://github.com/LectronPusher/botc-custom-script-generator/blob/main/Trouble%20Brewing.png?raw=true)
