\ProvidesClass{script}

\LoadClass[10pt]{article}
% \documentclass[10pt]{article}

% some latex distributions approximate letterpaper with cm values
% and I'm too lazy to figure out how to change mine to use exact inches
\usepackage[paperheight=8.5in, paperwidth=11in,margin=0.25in]{geometry}

\usepackage[parfill]{parskip} % Remove paragraph indentation
\usepackage{array}
\usepackage{tabu}
\usepackage{vcell}
\usepackage{color}
\usepackage{ifthen}
\usepackage{graphicx}
\graphicspath{ {./icons/} }
\usepackage{fontspec}
\setmainfont[
	Path = Lora/,
	Extension = .ttf,
	UprightFont = *-Regular,
	BoldFont = *-Bold,
	ItalicFont = *-Italic,
	BoldItalicFont = *-BoldItalic
]{Lora}

% create two side by side copies of data
\newenvironment{doubledoc}[1]{
	\begin{minipage}[t][7.95in]{5.0in}
		#1
	\end{minipage}
	\hspace{.5in}
	\begin{minipage}[t][7.95in]{5.0in}
		#1
	\end{minipage}
}{}

% ------------------------- script front -------------------------

\newcommand{\scriptname}[1]{
	\centerline{\Large\textit{#1}}
	\smallskip
}

% this sets whether things stretch to the bottom of the page
% I figure most teensyville scripts will be cut smaller so don't need to stretch
\newboolean{teensyville}

\newcommand{\notfirstnight}{
	\ifthenelse{\boolean{teensyville}} {\smallskip} {\vfill}
	\centerline{\small\textbf{\textit{* Not the first night.}}}
	\smallskip
}

% parameterized widths for new column types
\newlength{\iconwidth}
\newlength{\descwidth}
\newlength{\betweenwidth}
\setlength{\iconwidth}{0.46in}
\setlength{\descwidth}{1.95in}
\setlength{\betweenwidth}{5pt}
% new column types for character Icons and Descriptions that make the tables work
\newcolumntype{I}{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{\iconwidth}}
\newcolumntype{D}{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{\descwidth}}
% and custom table spacing
\setlength{\tabcolsep}{2pt}
\renewcommand{\arraystretch}{1.05}

% these handle the two column nature of the character table
\newcounter{chartypes}
\newcounter{chars_in_type}[chartypes] % chars_in_type resets to 0 when chartypes increments
\setcounter{chartypes}{0}
\setcounter{chars_in_type}{0}

\newenvironment{chartype}[1]{ % 1: character type
	\stepcounter{chartypes}
	\rule[3pt]{2in}{0.5pt}
	\hfill {\large \textbf{#1}} \hfill
	\rule[3pt]{2in}{0.5pt}
	\\
	\begin{tabular}{@{} I D @{\hspace{\betweenwidth}} I D @{}}
}{
	\end{tabular}
}

\newcommand{\characterimage}[2]{ % 1: width, 2: icon file
	% trim order is: left bottom right top
	\includegraphics[width=#1,trim=0 120 0 35,clip]{#2}
}

\newcommand{\character}[3]{ % 1: character id, 2: name, 3: description
	\characterimage{\linewidth}{#1.png}
& {\small\textbf{#2}}
	\newline \vspace{-.2em}
	\scriptsize #3
	% this handles the two column nature of the character table
	\stepcounter{chars_in_type} % 1 indexing
	\ifthenelse{\isodd{\value{chars_in_type}}} {&} {\\}
}

% ------------------------- night order -------------------------

% parameterized widths for night stuff
\newlength{\nighticonwidth}
\setlength{\nighticonwidth}{0.3in}
\newcolumntype{F}{>{\centering\arraybackslash}m{\nighticonwidth}}
\newcolumntype{N}{>{\centering\arraybackslash}l}

\newlength{\nightspacing}
\setlength{\nightspacing}{2.0ex}
\newcommand{\nighttext}[2]{ % 1: text, 2: name
	{\large\textbf{#1}}
	% the tabular centers the vertical space which makes everything nice
	& {\small\textbf{#2}} \begin{tabular}{l} \vspace{\nightspacing} \end{tabular} \\
}
\newcommand{\nighticon}[2]{ % 1: character id, 2: name
	\nighttext{\characterimage{\linewidth}{#1.png}}{#2}
}

% don't worry about these - don't question it
\newsavebox{\fnightbox}
\newsavebox{\onightbox}
\newlength{\oheight}
\newlength{\fheight}
\newlength{\fwidth}
\newlength{\owidth}
\newlength{\diffh}
\newlength{\fillheight}
\newlength{\fillwidth}

\newenvironment{nights}[2]{
	% Getting other nights to align to the bottom of the page or the bottom of
	% first night was an incredible struggle of Latex fuckery. But it works
	% and it is beautiful.
	% technically you can just use tabular here, but tabu makes the line spacing
	% better and I'm not entirely sure why
	\savebox{\fnightbox}{
		\begin{tabu}{@{} F N @{}}
			\nighttext{}{\large First Night}
			\nighttext{*}{Travellers}
			#1
			\nighttext{}{$\sim$ Dawn $\sim$}
		\end{tabu}
	}
	\savebox{\onightbox}{
		\begin{tabu}{@{} F N @{}}
			\nighttext{}{\large Other Nights}
			\nighttext{}{$\sim$ Dusk $\sim$}
			\nighttext{*}{Travellers}
			#2
			\nighttext{}{$\sim$ Dawn $\sim$}
		\end{tabu}
	}
	% get the heights and widths of the nights and use them to set the lengths
	\settoheight{\oheight}{\usebox{\onightbox}}
	\settoheight{\fheight}{\usebox{\fnightbox}}
	\settowidth{\owidth}{\usebox{\onightbox}}
	\settowidth{\fwidth}{\usebox{\fnightbox}}
	\setlength{\diffh}{\fheight}
	\addtolength{\diffh}{-\oheight}
	\setlength{\fillheight}{\textheight}
	\addtolength{\fillheight}{-\oheight}
	\setlength{\fillwidth}{\linewidth}
	\addtolength{\fillwidth}{-\owidth}
	\addtolength{\fillwidth}{-\fwidth}
	\addtolength{\fillwidth}{-.25in}
	
	% actually print the table
	\begin{tabular}{@{} l @{\hspace{\fillwidth}} r @{}}
		\vcell{
			\usebox{\fnightbox} % first night is easy
		} & \vcell{
			\ifthenelse{\boolean{teensyville}} { % not other nights
				\ifthenelse{\lengthtest{\diffh > 0pt}} {
					% why can't I use a strut here?
					\raisebox{-\diffh}[0pt][0pt]{
						\rotatebox{180}{\usebox{\onightbox}}
					}}{\rotatebox{180}{\usebox{\onightbox}}}
			}{
				\rotatebox{180}{\usebox{\onightbox}}
				\rule{0pt}{\fillheight}
			}
		} \\[-\rowheight]
		\printcelltop & \printcellbottom \\
	\end{tabular}
}
% bruh - it doesn't compile unless I have at least two blank lines here
% this was weird to debug

