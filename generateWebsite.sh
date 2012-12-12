#!/bin/bash

# generate xml data in the xslt directory
./output.rb

cd xslt

xsltproc createHTML.xsl data.xml > /home/mcormier/sites/stats/index.html
