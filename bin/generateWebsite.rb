#!/usr/bin/env ruby

script_location = File.expand_path File.dirname(__FILE__)
to_load = script_location + '/../config/config.properties'
load to_load

xsl_loc=script_location+'/../data/themes/' + @theme + '/xsl/createHTML.xsl'

dbScript_loc=script_location+'/../data/themes/' + @theme + '/dbScript'

cmd = 'xsltproc ' + xsl_loc + ' ' + script_location + '/' + @xmlDataFile + ' > ' + @outputHTMLFile
value = `#{cmd}`

if @enableGraphs then
  require dbScript_loc
end

puts value
