#!/bin/bash
# script for rendering multiple adoc's to HTML and PDF
# notes: - output are moved to ./build
#        - images are embedded in html if you use the paremter "-a data-uri" (you should use it to keep everything in one file)
#
# requirements: 
#       - each document project should be stored in a subfolder with a specific prefix
#           example: /docs/project-a, /docs/project-b, /docs/project-c
#
#       - each document project has a entering point named index.adoc
#           example: /docs/project-a/index.adoc


SCRIPT_DIR="$(dirname $0)"

if [ "$SCRIPT_DIR" != "." ]; then
  echo 'Must be executed from its directory!'
  exit 1
fi

rm build/*.html
rm build/*.pdf


for D in `find project-* -type d -maxdepth 0`
do
  echo "render document $D"
  cd $D

  echo 'Building HTML...'
  asciidoctor -v -r asciidoctor-diagram -a data-uri -b xhtml5 index.adoc
  mv index.html ../build/$D.html

  echo 'Building PDF...'
  asciidoctor -v -r asciidoctor-pdf -r asciidoctor-diagram -b pdf index.adoc
  mv index.pdf ../build/$D.pdf

  cd ..
done
