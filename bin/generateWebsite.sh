#!/bin/bash

SCRIPTLOC=`dirname $0`
cd $SCRIPTLOC

# generate xml data in the xslt directory
${SCRIPTLOC}/output.rb

cd xslt

#TODO -- make this a configuration item
xsltproc createHTML.xsl data.xml > /home/mcormier/sites/stats/index.html
