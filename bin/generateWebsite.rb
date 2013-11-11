#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'

script_location = File.expand_path File.dirname(__FILE__)
to_load = script_location + '/../config/config.properties'
load to_load

theme_root = '/../data/themes/'

#----------------------------
# Extract phase
#----------------------------
extract_root= script_location + theme_root + @theme + '/_extract/'

# Process all rb files in the theme _extract directory
Dir.glob(extract_root + '*.rb') do |rb_file|
  require rb_file
end


xsl_loc=script_location+'/../data/themes/' + @theme + '/xsl/createHTML.xsl'

#dbScript_loc=script_location+'/../data/themes/' + @theme + '/dbScript'

#----------------------------
# Transform phase
#----------------------------
# TODO - push logic to the _transform directory
cmd = 'xsltproc ' + xsl_loc + ' ' + script_location + '/' + @xmlDataFile + ' > ' + @outputHTMLFile
value = `#{cmd}`

#if @enableGraphs then
#  require dbScript_loc
#end

puts value
