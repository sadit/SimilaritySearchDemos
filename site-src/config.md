<!--Add here global page variables to use throughout your website.-->
+++
author = "Eric S. Tellez <eric.tellez@infotec.mx>"
mintoclevel = 2

# Add here files or directories that should be ignored by Franklin, otherwise                                        
# these files might be copied and, if markdown, processed by Franklin which                                          
# you might not want. Indicate directories by ending the name with a `/`.                                            
# Base files such as LICENSE.md and README.md are ignored by default.                                                
ignore = ["node_modules/"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = false
website_title = "Demonstrations for the SimilaritySearch.jl package"
website_descr = "Demonstrations for the SimilaritySearch.jl package"
website_url   = "https://ingeotec.github.io/SimilaritySearchDemos/"
+++
@def title = "SimilaritySearchDemos"
@def prepath = "SimilaritySearchDemos"

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
\newcommand{\col}[2]{~~~<span style="color:~~~#1~~~">~~~!#2~~~</span>~~~}
\newcommand{\img}[4]{~~~<div style="!#4; padding: 0.5em; margin: 0.5em; text-align: center;"><img src="!#2" alt="!#1" style="width: 100%; left-margin: 0; padding: 0;" />
<div style="text-align: center; width: 100%;">#3</div>
</div>~~~}
\newcommand{\imginline}[4]{\img{!#1}{!#2}{!#3}{display: block-inline;} }
