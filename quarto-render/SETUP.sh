#!/bin/bash
quarto add --no-prompt --quiet pandoc-ext/abstract-section
quarto add --no-prompt --quiet andrewheiss/quarto-output-styling
quarto add --no-prompt --quiet iagopinal/figure-table-formatter
quarto add --no-prompt --quiet cl-roberts/code-appendix
quarto add --no-prompt --quiet coatless-quarto/custom-callout
quarto add --no-prompt --quiet coatless-quarto/panelize

wget -O .gitignore https://raw.githubusercontent.com/promicrobial/Assets/refs/heads/main/.gitignore

git init
git add -f _assets/* end.qmd index.qmd index-html.qmd intro.qmd README.md SETUP.sh

git commit -m 'feat(quarto): initialise project structure and setup

- automate installation of essential quarto extensions for enhanced document features using SETUP.sh.
- add custom styling assets to control the visual presentation of html and latex outputs.
- establish a quarto document structure with dynamic documents detailing rendering information, and session details for reproducibility.
- add citation format files'

if [[ -d manuscript ]]; then
  git add manuscript/base.bib
  git commit -m 'feat(bib): add generic bibliography

  - adds general references applicable across multiple projects
    - adds commonly used software references
    - includes commonly cited articles/methods e.g. FDR correction'

  git add manuscript/references.qmd manuscript/references.bib
  git commit -m "feat(bib): add project specific bibliography and reference doc"
fi
