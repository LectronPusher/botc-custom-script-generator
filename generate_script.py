#!/usr/bin/python3

import json
import sys

# default scriptname - change if just running
# if using a commandline, specify the name as the first arg
filename = "Trouble Brewing.json"
if len(sys.argv) > 1:
	filename = sys.argv[1]

with open(filename) as f:
	script = json.load(f)

scriptname = filename.split(".")[0] # this might be replaced if _meta is set

with open("roles.json") as f:
	roles = json.load(f)

# gather all the roles into 3 lists
# one separated into the character types and ordered same as the json
# and two for the night order
# this is big-O inefficient but I don't care
char_types = {'townsfolk': [], 'outsider': [], 'minion': [], 'demon': []}
first_night = []
other_nights = []
num_chars = 0 # only count travellers and fabled
for char in script: # preserve character order from the json
	if char['id'] == "_meta":
		scriptname = char['name']
		continue # don't add _meta to the script
	char['id'] = char['id'].replace('_','')
	for role in roles:
		if role['id'] == char['id']:
			char = role
			break
	if char.get('team', None) in char_types:
		num_chars += 1
		char_types[char['team']].append(char)
		if char.get('firstNight', 0) != 0:
			first_night.append((char['firstNight'], char))
		if char.get('otherNight', 0) != 0:
			other_nights.append((char['otherNight'], char))

first_night = sorted(first_night)
other_nights = sorted(other_nights)

teensy = num_chars <= 18 # a basic heuristic for being full size vs teensy

# one big string that will become the latex file
# start with the header and the front side
latex = "% autogenerated latex script: " + scriptname + '''
\documentclass{script}\n
% this sets whether things stretch to the bottom of the page or not
% I figure most teensyville scripts will be cut smaller so don't need to stretch
\\setboolean{teensyville}{''' + ("true" if teensy else "false") + '''}\n
\\begin{document}
\\begin{doubledoc}{
\\scriptname{''' + scriptname + '''}\n
'''

# add the characters of each type - ignore tavellers and fabled
def add_char_type(team, name):
	string = "\\begin{chartype}{" + name + "}\n"
	for role in char_types[team]:
		string += "\\character{" + role['id'] + "}{" + role['name'] + "}{" + role['ability'] + "}\n"
	string += "\\end{chartype}\n\n"
	return string
latex += add_char_type('townsfolk', "Townsfolk")
latex += add_char_type('outsider', "Outsiders")
latex += add_char_type('minion', "Minions")
latex += add_char_type('demon', "Demons")

# add the front footer
latex += '''\\notfirstnight
}\\end{doubledoc}
'''

# add night order on a new page
latex += '''
\\newpage\n
\\begin{doubledoc}{\n
\\begin{nights}{
'''
demon_info_added = False
minion_info_added = False
for role in first_night:
	if not minion_info_added and role[1]['firstNight'] > 5:
		latex += "\\nighttext{\color{red}M}{Minion Info}\n"
		minion_info_added = True
	if not demon_info_added and role[1]['firstNight'] > 7.5:
		latex += "\\nighttext{\color{red}D}{Demon Info}\n"
		demon_info_added = True
	latex += "\\nighticon{" + role[1]['id'] + "}{" + role[1]['name'] + "}\n"
if not minion_info_added:
	latex += "\\nighttext{\color{red}M}{Minion Info}\n"
if not demon_info_added:
	latex += "\\nighttext{\color{red}D}{Demon Info}\n"

latex += "}{\n"
for role in other_nights:
	latex += "\\nighticon{" + role[1]['id'] + "}{" + role[1]['name'] + "}\n"

# and the final footer
latex += '''}\\end{nights}\n
}\\end{doubledoc}
\\end{document}
'''

# fix ampersands in abilities
latex = latex.replace('&','\\&')

# write latex string to the file
texname = filename.split(".")[0] + ".tex"
with open(texname, "w") as f:
	f.write(latex)
