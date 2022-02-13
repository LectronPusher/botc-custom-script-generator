
\ProvidesClass{script}

\LoadClass[10pt,letterpaper,landscape]{article}

\usepackage[left=0.25in,top=0.25in,right=0.25in,bottom=0.25in]{geometry}
\usepackage[parfill]{parskip} % Remove paragraph indentation
\usepackage{array}
\usepackage{tabu}
\usepackage{vcell}
\usepackage{color}
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

% creates two side by side copies of the data
\newenvironment{doubledoc}[1]{
	\begin{minipage}[t]{5.0in}
		#1
	\end{minipage}
	\hspace{.45in} % why does .45 makes the margins equal instead of .5???
	\begin{minipage}[t]{5.0in}
		#1
	\end{minipage}
}{}

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

\newenvironment{chartype}[1]{ % 1: character type
	\rule[3pt]{2in}{0.5pt} % parametrizing this was too complicated - deal
	\hfill {\large \bf #1} \hfill
	\rule[3pt]{2in}{0.5pt}
	\\
	\begin{tabular}{@{} I D @{\hspace{\betweenwidth}} I D @{}}
}{
	\end{tabular}
}

\newcommand{\character}[3]{ % 1: character id, 2: name, 3: description
	% trim order is: left bottom right top
	\includegraphics[width=\linewidth,trim=0 120 0 35,clip]{#1.png}
	& {\bf\small#2}
	\newline \vspace{-.2em}
	\scriptsize #3
}

\newlength{\nighticonwidth}
\setlength{\nighticonwidth}{0.3in}
\newcolumntype{F}{>{\centering\arraybackslash}m{\nighticonwidth}}
\newcolumntype{N}{>{\centering\arraybackslash}l}

\newlength{\nightspacing}
\setlength{\nightspacing}{2.0ex}
\newcommand{\nighttext}[2]{ % 1: text, 2: name
	{\large\bf#1}
	% the tabular centers the vertical space which makes everything nice
	& {\small\bf#2} \begin{tabular}{l} \vspace{\nightspacing} \end{tabular} \\
}
\newcommand{\night}[2]{ % 1: character id, 2: name
	\nighttext{\includegraphics[width=\linewidth,trim=0 120 0 35,clip]{#1.png}}{#2}
}

\newenvironment{nights}[4]{
	\begin{tabu}{l X[1,c] r}
		\vcell{
		\begin{tabular}{F N}
			\nighttext{}{\large First Night}
			\nighttext{*}{Travellers}
			#1
			\nighttext{}{$\sim$ Dawn $\sim$}
		\end{tabular}
		}& \vcell{\rule{0pt}{#2} #3} & \vcell{
		\rotatebox{180}{
		\begin{tabular}{F N}
			\nighttext{}{\large Other Nights}
			\nighttext{}{$\sim$ Dusk $\sim$}
			\nighttext{*}{Travellers}
			#4
			\nighttext{}{$\sim$ Dawn $\sim$}
		\end{tabular}
		}} \\[-\rowheight]
		\printcelltop & \printcellmiddle & \printcellbottom
	\end{tabu}
}
% holy shit - it doesn't compile unless I have two blank lines here
% what the actual fuck

